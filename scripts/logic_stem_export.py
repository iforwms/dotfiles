import os, sys

if len(sys.argv) < 2:
    raise Exception("Missing directory path.")

path = sys.argv[1]
original_files = []

if not os.path.isdir(path):
    raise Exception("The specified directory does not exist.")

if not os.path.isfile(path + "/markers"):
    raise Exception("Missing 'markers' file.")

for file in os.listdir(path):
    if not file.endswith(".wav"):
        continue
    original_files.append(file)

recording_date=original_files[0].split("_")[0]

pipe=os.popen("ffmpeg...")
print(pipe.read())

os.mkdir()

print("So far, so good!")
exit()

