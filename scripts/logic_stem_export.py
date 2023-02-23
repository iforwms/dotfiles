import os, sys, subprocess, mutagen
import time
import re
import glob
from mutagen.wave import WAVE

debug = True

# Exporting files from Logic Pro
# 1. Split all tracks into individual regions
# 2. Create markers for each song
# 5. File > Export > All Tracks as Audio Files... (Shift + Cmd + E)
# 6. Enable "Include Volume/Pan Automation"
# 7. Set the "Range" to Extend File Length to Project Length
# 8. Set exported file name to: "DATE_,$TrackName"
# 9. List Editors (D) > Markers
# 10. View > Check both "Show Event Time Position and
#     Length as Time" and "Length as Absolute Position"
# 11. Copy all marker info (Cmd + a, Cmd + c) and paste (Cmd + v) into a file called markers

t0 = time.time()

if len(sys.argv) < 2:
    raise Exception("Missing directory path.")

directory_path = sys.argv[1]
output_directory = f"{directory_path}/output"
markers_path = directory_path + "/markers"
backup_path = None
recording_date = None
input_filetype = "wav"
output_filetype = "mp3"

original_files = []
track_names = []
file_durations = []
section_names = []

if not os.path.isdir(directory_path):
    raise Exception("The specified directory does not exist.")

if not os.path.isfile(markers_path):
    raise Exception("Missing 'markers' file.")

if len(sys.argv) > 2:
    backup_path = sys.argv[2]

for file in os.listdir(directory_path):
    if not file.endswith(f".{input_filetype}"):
        continue
    original_files.append(file)

print(f"\n[STAGE] Validating {input_filetype.upper()} files...")
for file in original_files:
    filepath = f"{directory_path}/{file}"

    audio = WAVE(filepath)
    duration = audio.info.length

    file_durations.append(duration)

if not all(i == file_durations[0] for i in file_durations):
    raise Exception("File durations are not the same, aborting.")

markers_file = open(markers_path, 'r')
markers = markers_file.readlines()
markers_regex = r"(\d{1,2}:\d{2}:\d{2}):(\d{2}).(\d{2})"
markers_subst = "\\1.\\2\\3"

recording_date=original_files[0].split("_")[0]
instrument_track_count = len(original_files) * len(markers)

print(f"\n[STAGE] Splitting {input_filetype.upper()} files by section markers...")
split_track_count = 1
for recording in original_files:
    track_name = recording.split("_")[1].replace(f".{input_filetype}", "")
    track_names.append(track_name)

    for line in markers:
        section_data = re.findall(r'\S+', line)
        start_time = re.sub(markers_regex, markers_subst, section_data[0])
        duration = re.sub(markers_regex, markers_subst, section_data[2])
        section_name = section_data[1]
        section_names.append(section_name)

        new_directory_path = f"{output_directory}/{section_name}/{input_filetype}s/{recording_date}"
        new_filename = f"{recording_date}_{section_name}_{track_name}.{input_filetype}"

        os.makedirs(new_directory_path, exist_ok=True)

        print(f"[INFO] [{split_track_count}/{instrument_track_count}] Creating file {new_filename}")
        command = f"ffmpeg -y -nostdin -i '{directory_path}/{recording}' -ss '{start_time}' -t '{duration}' -c copy '{new_directory_path}/{new_filename}'" # 2>./error.log
        if debug is False:
            command += " -loglevel quiet"

        os.system(command)
        split_track_count += 1

all_files_glob = f"{output_directory}/**/{input_filetype}s/{recording_date}/*.{input_filetype}"
all_input_files = glob.glob(all_files_glob)
section_names = [*set(section_names)] # Make section names unique

print(f"\n[STAGE] Deleting empty {input_filetype.upper()}s...")
for file in all_input_files:
    # print(file)
    # exit()
    command = f"ffmpeg -i {file} -af silencedetect=noise=0.001 -f null - 2>&1 | awk '/silence_duration/{{print $8}}'"
    # continue

    silence_duration = subprocess.check_output(command, shell=True, encoding="UTF-8")
    if silence_duration == '':
        silence_duration = "0"
    if silence_duration.__contains__("\n"):
        silence_duration = silence_duration.split("\n")[-2]
    silence_duration = int(float(silence_duration))

    if silence_duration > 0:
        audio = WAVE(file)
        duration = int(audio.info.length)

        if duration == silence_duration:
            print(f"[INFO] [{file.split('/')[-1]}] {input_filetype.upper()} is silent, deleting.")
            os.remove(file)

# Covert files
all_input_files = glob.glob(all_files_glob)
if output_filetype is not input_filetype:
    print(f"\n[STAGE] Converting {input_filetype.upper()} files to {output_filetype.upper()}...")
    files_to_convert_count = len(all_input_files)
    current_file_count = 1
    for file in all_input_files:
        stem_dir = "/".join(file.split('/')[0:-1]) + "/../../stems/" + recording_date
        os.makedirs(stem_dir, exist_ok=True)
        print(f"[INFO] [{current_file_count}/{files_to_convert_count}] Converting {file.split('/')[-1]} to {output_filetype.upper()}")
        command = f"ffmpeg -y -i '{file}' -write_id3v1 1 -id3v2_version 3 -dither_method triangular -b:a 192k '{stem_dir}/{file.split('/')[-1].replace('.' + input_filetype, '')}.{output_filetype}'"

        if debug is False:
            command += " -loglevel quiet"

        os.system(command)
        current_file_count += 1


print("\n[STAGE] Creating play-along tracks...")
total_mix_count = len(markers)
current_mix_count = 1
for directory in os.listdir(f"{output_directory}"):
    if os.path.isfile(os.path.join(output_directory, directory)):
        continue

    song_directory_path = os.path.join(output_directory, directory) + f"/stems/{recording_date}"
    # print(output_directory, song_directory_path)
    # exit()
    used_tracks = []
    files = glob.glob(f"{song_directory_path}/*.{output_filetype}")
    for file in files:
        used_tracks.append(file.split("/")[-1].split("_")[-1].replace(f".{output_filetype}", ""))

    for track in used_tracks:
        command = "ffmpeg "
        debug_log = []
        track_count = 0
        for file in files:
            if file.endswith(f"{track}.{output_filetype}"):
                continue

            command += f"-i {file} "
            debug_log.append(file.split("/")[-1])
            track_count += 1

        # TODO: Fix counts
        print(f"[INFO] [{current_mix_count}/{total_mix_count}] Creating {track} play-along track for {directory}.")
        playalong_dir = f"{song_directory_path}/../../playalongs/{recording_date}"
        os.makedirs(playalong_dir, exist_ok=True)
        command += f"-filter_complex amix=inputs={track_count}:duration=first {playalong_dir}/{recording_date}_{directory}_NO_{track}.{output_filetype}"

        if debug is False:
            command += " -loglevel quiet"
        else:
            debug_log.append(f"NO_{track}")
            print(debug)

        os.system(command)

    # Create Main mix
    command = "ffmpeg "
    track_count = 0
    for file in files:
        command += f"-i {file} "
        track_count += 1

    mix_dir = f"{song_directory_path}/../../mixes/{recording_date}"
    os.makedirs(mix_dir, exist_ok=True)
    print(f"[INFO] [{current_mix_count}/{total_mix_count}] Creating mix for {directory}.")
    command += f"-filter_complex amix=inputs={track_count}:duration=first {mix_dir}/{recording_date}_{directory}_MIX.{output_filetype}"

    if debug is False:
        command += " -loglevel quiet"

    os.system(command)
    current_mix_count += 1

t1 = time.time() - t0

print("[SUCCESS] Audio file generation complete, time elapsed (secs): ", t1)

if backup_path:
    print("\n[STAGE] Uploading files to remove server...")
    # TODO: Improve rsync config
    command = f"rsync --archive --recursive --verbose --include='*.{output_filetype}' --exclude='*.*' {output_directory}/ {backup_path}"
    print(command)
    os.system(command)

print("\n[SUCCESS] All done!\n")

exit()

