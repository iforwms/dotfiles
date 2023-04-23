#!/usr/bin/env python3

import os, sys, subprocess, mutagen
import argparse
import time
import re
import glob
import shutil
from mutagen.wave import WAVE

debug = True
debug = False

mp3_gain = 0
playalong_gain = 0

if not debug:
    sys.tracebacklimit = 0

# Exporting files from Logic Pro
# 1. Split all tracks into individual regions
# 2. Create markers for each song (for multiple takes: NAME-TAKE#
# 5. File > Export > All Tracks as Audio Files... (Shift + Cmd + E)
# 6. Enable "Include Volume/Pan Automation"
# 7. Set the "Range" to "Extend File Length to Project End"
# 8. Set exported file name to: "DATE_,$TrackName"
# 9. List Editors (D) > Markers
# 10. View > Check "Show Event Time Position and Length as Time" (Ctrl+Opt+R) and deselect "Length as Absolute Position" (Ctrl+Shift+A)
# 11. Copy all marker info (Cmd + a, Cmd + c) and paste (Cmd + v) into a file called markers

# Marker file example
# 00:35:05:12.40  Song-1  00:03:30:12.40
# 00:38:36:00.00  Song-2  00:02:32:16.53
# 00:41:10:03.21  Song-3  00:04:15:05.05

t0 = time.time()

# Set global variables
working_directory = None
output_directory = None
markers_path = None
remote_path = None
recording_date = None
input_filetype = "wav"
output_filetype = "mp3"
sections = []
stems = []
help_text = "usage: logic_export.py [-h] [-r REMOTE_PATH] [-o] directory_path"

parser = argparse.ArgumentParser()
parser.add_argument("directory_path", help="full path to individual instrument stems", type=str)
parser.add_argument("-r", "--remote-path", help="full path to remote server directory", required=False, type=str)
parser.add_argument("-p", "--playalongs", help="generate playalong tracks", required=False, action="store_true")
parser.add_argument("-o", "--only-remote", help="only copy existing files to remote path", action="store_true")
args = parser.parse_args()

def preflight_checks():
    global args, working_directory, output_directory, markers_path, remote_path

    working_directory = args.directory_path
    output_directory = f"{working_directory}/output"
    markers_path = working_directory + "/markers"
    remote_path = args.remote_path

    if not os.path.isdir(working_directory):
        raise Exception("The specified directory does not exist. \n" + help_text)

    if not os.path.isfile(markers_path):
        raise Exception("Missing 'markers' file. \n" + help_text)

def check_raw_files():
    global working_directory, input_filetype, recording_date, raw_files, stems
    print(f"[STAGE] Validating {input_filetype.upper()} files...")
    for file in os.listdir(working_directory):
        if not file.endswith(f".{input_filetype}"):
            continue

        filepath = f"{working_directory}/{file}"
        stem = {
            'name': file.split("_")[1].replace(f".{input_filetype}", ""),
            'filename': file,
            'filepath': filepath,
            'duration': WAVE(filepath).info.length
        }
        stems.append(stem)

    recording_date = stems[0]['filename'].split("_")[0]

    if not all(i['duration'] == stems[0]['duration'] for i in stems):
        raise Exception("File durations are not the same, aborting.")

def read_markers_file():
    global markers_path, sections
    print("[STAGE] Reading markers file.")

    markers_regex = r"(\d{1,2}:\d{2}:\d{2}):(\d{2}).(\d{2})"
    markers_subst = "\\1.\\2\\3"
    markers_file = open(markers_path, 'r')
    markers = markers_file.readlines()
    for marker in markers:
        section_data = re.findall(r'\S+', marker)
        if not len(section_data):
            continue

        section_name = section_data[1]
        section = {
            'name': section_name,
            'dir_name': section_name.split("-")[0],
            'start_time': re.sub(markers_regex, markers_subst, section_data[0]),
            'duration': re.sub(markers_regex, markers_subst, section_data[2])
        }
        sections.append(section)

def change_gain(filepath, gain = 10):
    if gain == 0:
        return

    global output_filetype
    print(f"[INFO] Changing audio gain by {gain}dB.")
    temp_file = f"{filepath}.{output_filetype}"
    command = f"ffmpeg -i {filepath} -af 'volume=volume={gain}dB' {temp_file}"

    if debug is False:
        command += " -loglevel quiet"

    os.system(command)
    shutil.move(temp_file, filepath)

def split_raw_files_by_marker():
    global sections, stems, input_filetype, output_directory, recording_date, debug
    print(f"[STAGE] Splitting {input_filetype.upper()} files by section markers.")

    split_track_count = 1
    instrument_track_count = len(sections) * len(stems)
    for stem in stems:
        for section in sections:
            new_directory_path = f"{output_directory}/{section['dir_name']}/{input_filetype}s/{recording_date}"
            new_filename = f"{recording_date}_{section['name']}_{stem['name']}.{input_filetype}"

            os.makedirs(new_directory_path, exist_ok=True)

            print(f"[INFO] [{split_track_count}/{instrument_track_count}] Creating file {new_filename}")
            command = f"ffmpeg -y -nostdin -i '{stem['filepath']}' -ss '{section['start_time']}' -t '{section['duration']}' -c copy '{new_directory_path}/{new_filename}'" # 2>./error.log

            if debug is False:
                command += " -loglevel quiet"

            os.system(command)

            split_track_count += 1

def delete_empty_files():
    global output_directory, input_filetype, recording_date
    print(f"[STAGE] Purging empty {input_filetype.upper()}s.")
    glob_pattern = f"{output_directory}/**/{input_filetype}s/{recording_date}/*.{input_filetype}"
    stem_files = glob.glob(glob_pattern)

    for file in stem_files:
        command = f"ffmpeg -i {file} -af silencedetect=noise=0.001 -f null - 2>&1 | awk '/silence_duration/{{print $8}}'"

        silence_duration = subprocess.check_output(command, shell=True, encoding="UTF-8")
        if silence_duration == '':
            silence_duration = "0"
        if silence_duration.__contains__("\n"):
            silence_duration = silence_duration.split("\n")[-2]
        silence_duration = int(float(silence_duration))

        if silence_duration > 0:
            duration = int(WAVE(file).info.length)

            if duration == silence_duration:
                print(f"[INFO] [{file.split('/')[-1]}] {input_filetype.upper()} is silent, deleting.")
                os.remove(file)

def convert_files():
    global input_filetype, output_filetype, debug, recording_date, mp3_gain
    if output_filetype is input_filetype:
        print(f"[WARN] Input and output files are the same, skipping conversion.")
        return

    glob_pattern = f"{output_directory}/**/{input_filetype}s/{recording_date}/*.{input_filetype}"
    all_input_files = glob.glob(glob_pattern)
    print(f"[STAGE] Converting {input_filetype.upper()} files to {output_filetype.upper()}...")
    files_to_convert_count = len(all_input_files)
    current_file_count = 1
    for file in all_input_files:
        stem_dir = "/".join(file.split('/')[0:-1]) + "/../../stems/" + recording_date
        os.makedirs(stem_dir, exist_ok=True)
        print(f"[INFO] [{current_file_count}/{files_to_convert_count}] Converting {file.split('/')[-1]} to {output_filetype.upper()}")
        output_file = f"{stem_dir}/{file.split('/')[-1].replace('.' + input_filetype, '')}.{output_filetype}"
        command = f"ffmpeg -y -i '{file}' -write_id3v1 1 -id3v2_version 3 -dither_method triangular -b:a 192k '{output_file}'"

        if debug is False:
            command += " -loglevel quiet"

        os.system(command)

        change_gain(output_file, mp3_gain)

        current_file_count += 1

def merge_audio(output_file, files_to_merge):
    print(output_file, files_to_merge)
    exit()

def create_playalongs():
    global args, sections, output_directory, recording_date, output_filetype, playalong_gain
    gain_adjustment = playalong_gain
    print("[STAGE] Creating play-along tracks.")
    for directory in os.listdir(f"{output_directory}"):
        if os.path.isfile(os.path.join(output_directory, directory)):
            continue

        input_directory_path = os.path.join(output_directory, directory) + f"/stems/{recording_date}"
        for section in sections:
            if section['dir_name'] != directory:
                continue

            section_tracks = []
            for stem in stems:
                input_filename = f"{recording_date}_{section['name']}_{stem['name']}.{output_filetype}"
                if not os.path.isfile(f"{input_directory_path}/{input_filename}"):
                    continue
                output_filename = f"{recording_date}_{section['name']}_NO_{stem['name']}.{output_filetype}"
                mix_name = f"{recording_date}_{section['name']}_MIX.{output_filetype}"
                section_tracks.append({ 'filepath': f"{input_directory_path}/{input_filename}", 'filename': input_filename, 'playalong_name': output_filename, 'mix_name': mix_name })

            total_playalong_tracks = len(section_tracks)
            current_playalong_tracks = 1

            # Create Playalongs
            if args.playalongs:
                for track_to_create in section_tracks:
                    command = "ffmpeg "
                    for track in section_tracks:
                        if track['filename'] == track_to_create['filename']:
                            continue

                        command += f"-i {track['filepath']} "

                    print(f"[INFO] [{current_playalong_tracks}/{total_playalong_tracks}] Creating {track_to_create['playalong_name']} play-along track for {directory}.")
                    playalong_dir = f"{input_directory_path}/../../playalongs/{recording_date}"
                    os.makedirs(playalong_dir, exist_ok=True)
                    output_file = f"{playalong_dir}/{track_to_create['playalong_name']}"
                    command += f"-filter_complex amix=inputs={total_playalong_tracks - 1}:duration=first {output_file}"

                    if debug is False:
                        command += " -loglevel quiet"

                    current_playalong_tracks += 1
                    os.system(command)
                    change_gain(output_file, gain_adjustment)

            # Create Mixes - TODO: Refactor
            command = "ffmpeg "
            for track in section_tracks:
                command += f"-i {track['filepath']} "

            print(f"[INFO] Creating mix for {directory}.")
            mix_dir = f"{input_directory_path}/../../mixes"
            os.makedirs(mix_dir, exist_ok=True)
            output_file = f"{mix_dir}/{track['mix_name']}"
            command += f"-filter_complex amix=inputs={total_playalong_tracks}:duration=first {output_file}"

            if debug is False:
                command += " -loglevel quiet"

            current_playalong_tracks += 1
            os.system(command)
            change_gain(output_file, gain_adjustment)

def copy_to_remote():
    global output_filetype, output_directory, remote_path
    if not remote_path:
        print("[WARN] No remote path specified, skipping remote copy.")
        return

    print("[STAGE] Uploading files to remove server.")
    command = f"rsync --archive --recursive --verbose --include='*.{output_filetype}' --exclude='wavs' --exclude='*.*' {output_directory}/ {remote_path}"
    os.system(command)
    print("[SUCCESS] Remote copy complete.")

preflight_checks()

if args.only_remote:
    if not args.remote_path:
        print("[ERROR] No remote path specified, aborting.")
        exit()
    copy_to_remote()
    exit()

check_raw_files()
read_markers_file()
split_raw_files_by_marker()
delete_empty_files()
convert_files()
create_playalongs()

t1 = round(time.time() - t0, 2)
print("[SUCCESS] Audio file generation complete, time elapsed (secs): ", t1)

if args.remote_path:
    copy_to_remote()

exit()

