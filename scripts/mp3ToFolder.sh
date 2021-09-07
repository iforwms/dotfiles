#!/bin/bash

# Make sure to use find with $(pwd) to get the full path
# of the files if using this script with multiple
# files.

properties="year disc date album track artist title disctotal tracktotal"

for property in $properties; do
    temp=$(ffprobe -loglevel quiet -show_entries format_tags="$property" "$1" | sed "1d;\$d;s/tag:${property}=//i")
    declare ${property}="$temp"
done

echo
for property in $properties; do
    echo ${property} - ${!property}
done
echo

if [ -z "$album" -a "$album" == "" ]; then
    album="Unknown - ${artist}"
fi

if [ -z "$title" -a "$title" == "" ]; then
    time=$(date '+[%Y-%m-%d %H:%M:%S]')
    echo
    echo "${time} [ERROR] ${1} has no meta data, skipping..." | tee -a $HOME/Music/music_copying.log
    echo
else
    # TODO: Clean this mess up!
    # dir="${artist}/[${year}] ${album}"
    # dir="${artist}/${album}"

    title="${title//\//_}"
    artist="${artist//\//_}"
    album="${album//\//_}"

    dir="${album}"
    full_dir="/Volumes/IFOR2T_BACKUP/Music/downloads/${dir}"
    track=$(echo $track|cut -d'/' -f1)
    track="${track//\//_}"
    track=$(printf %02d $track)
    # filename="${track} - ${title}"
    filename="${track} ${artist} - ${title}"
    ext="${1##*.}"

    mkdir -p "${full_dir}" 2>/dev/null

    time=$(date '+[%Y-%m-%d %H:%M:%S]')
    echo
    echo "${time} [INFO] Copying ${1} to ${full_dir}" | tee -a $HOME/Music/music_copying.log
    echo
    cp "$1" "${full_dir}/${filename}.${ext}"
fi

