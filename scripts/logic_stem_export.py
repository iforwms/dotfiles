import os, sys, subprocess, mutagen
import re
import glob
from mutagen.wave import WAVE

if len(sys.argv) < 2:
    raise Exception("Missing directory path.")

directory_path = sys.argv[1]
output_directory = f"{directory_path}/output"
markers_path = directory_path + "/markers"
original_files = []
track_names = []
file_durations = []
section_names = []
recording_date = None

if not os.path.isdir(directory_path):
    raise Exception("The specified directory does not exist.")

if not os.path.isfile(markers_path):
    raise Exception("Missing 'markers' file.")

for file in os.listdir(directory_path):
    if not file.endswith(".wav"):
        continue
    original_files.append(file)

print("[INFO] Validating WAV files...")
for file in original_files:
    filepath = f"{directory_path}/{file}"

    audio = WAVE(filepath)
    duration = audio.info.length

    # print(f"{filepath} - {duration}")
    file_durations.append(duration)

if not all(i == file_durations[0] for i in file_durations):
    raise Exception("File durations are not the same, aborting.")

markers_file = open(markers_path, 'r')
markers = markers_file.readlines()
markers_regex = r"(\d{1,2}:\d{2}:\d{2}):(\d{2}).(\d{2})"
markers_subst = "\\1.\\2\\3"

recording_date=original_files[0].split("_")[0]

print("[INFO] Splitting WAV files by section markers...")
for recording in original_files:
    track_name = recording.split("_")[1].replace(".wav", "")
    track_names.append(track_name)

    for line in markers:
        section_data = re.findall(r'\S+', line)
        start_time = re.sub(markers_regex, markers_subst, section_data[0])
        duration = re.sub(markers_regex, markers_subst, section_data[2])
        section_name = section_data[1]
        section_names.append(section_name)

        new_directory_path = f"{output_directory}/{section_name}"
        new_filename = f"{recording_date}_{section_name}_{track_name}.wav"

        os.makedirs(new_directory_path, exist_ok=True)

        command = f"ffmpeg -y -nostdin -i '{directory_path}/{recording}' -ss '{start_time}' -t '{duration}' -c copy '{new_directory_path}/{new_filename}'" # 2>./error.log #-loglevel quiet

        # os.system(command)

print("[INFO] Deleting empty WAVs...")
exit()

print("[INFO] Converting WAV files to MP3...")
files = glob.glob(f"{output_directory}/**/*.wav")
for file in files:
    # continue
    command = f"ffmpeg -y -i '{file}' -write_id3v1 1 -id3v2_version 3 -dither_method triangular -b:a 192k '{file.replace('.wav', '')}.mp3'"
    # os.system(command)

section_names = [*set(section_names)]

print("[INFO] Creating play-along tracks...")
for directory in os.listdir(f"{output_directory}"):
    song_directory_path = os.path.join(output_directory, directory)
    if os.path.isfile(song_directory_path):
        continue

    used_tracks = []
    files = glob.glob(f"{song_directory_path}/*.mp3")
    for file in files:
        used_tracks.append(file.split("/")[-1].split("_")[-1].replace(".mp3", ""))

    for track in used_tracks:
        command = "ffmpeg "
        debug = []
        track_count = 0
        for file in files:
            if file.endswith(f"{track}.mp3"):
                continue

            command += f"-i {file} "
            debug.append(file.split("/")[-1])
            track_count += 1
        command += f"-filter_complex amix=inputs={track_count}:duration=first {recording_date}_{directory}_NO_{track}.mp3"
        debug.append(f"NO_{track}")

        print(debug)
        # print(command)
    # os.system(command)
    # exit()

print("All done!")
exit()

