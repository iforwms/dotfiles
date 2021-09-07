#!/bin/bash

AUTHOR="Ifor Waldo Williams <ifor@cors.tech>"
NAME=mp3ToFolder
VERSION=0.0.1
RELEASE=20210907
VERBOSE=false
FORCE_MOVE=false

ONLY_CONSOLE=false
ONLY_LOG=false
INSTALL_LOG=/tmp/mp3ToFolder.log

INPUT_DIR=""
OUTPUT_DIR=""

function showHelp()
{
    echo
    echo "  ${NAME}"
    echo
    echo "  Read audio file metadata them move the files to a new directory structure."
    echo "  NOTE: This software requires the ffprobe package from ffmpeg to work."
    echo
    echo "  Syntax: ${NAME} -i <input directory> -o <output directory> [-vm|h|V]"
    echo
    echo "  Options:"
    echo "    i     Full path to input directory."
    echo "    o     Full path to output directory."
    echo "    v     Turn on verbose mode."
    echo "    m     Force moving files instead of copying."
    echo "    h     Print this Help."
    echo "    V     Print software version and exit."
    echo
    exit 1
}

function showVersion()
{
    echo "${NAME} ${VERSION} (release: ${RELEASE})"
    echo "Built by ${AUTHOR}"
    exit 0
}

function checkForFfmpeg()
{
    log "Checking if ffprobe exists."
    if ! command -v ffprobe &> /dev/null
    then
        showError "ffprobe is required and could not be found, please install the ffmpeg package."
        exit
    fi
    log "ffprobe exists, OK."
}

function log()
{
    TIMESTAMP=$(date '+[%Y-%m-%d %H:%M:%S]')
   local MESSAGE="${@}"
   if [[ "${VERBOSE}" == true ]]; then
      echo "${TIMESTAMP} [DEBUG] ${MESSAGE}"
   fi
}

function showError()
{
    TIMESTAMP=$(date '+[%Y-%m-%d %H:%M:%S]')
    local MESSAGE="${@}"
    COLOR=31 #red
    FG="\033[${COLOR}m"
    RESET="\033[0m"

    echo
    echo -e "${FG}  ${TIMESTAMP} [ERROR] ${MESSAGE}${RESET}"
    echo
}

function checkDirExists()
{
    log "Checking if ${1} exists."
    if [ ! -d "$1" ]; then
        showError "Directory ${1} does not exist."
        exit 1
    fi
    log "${1} exists, OK."
}

function generateAudioFileList()
{
    TEMP_LIST=/tmp/mp3ToFolder_folders-to-process
    log "Generating audio list for ${1}"
    find ${1} -type f -name '*.mp3' -o -name '*.flac' -o -name '*.m4a' > $TEMP_LIST
    log "Audio list generated, found $(wc -l < $TEMP_LIST) files."
}

function main()
{
    # If no input argument found, exit the script with help
    if [[ ${#} -eq 0 ]]; then
        log "No arguments supplied."
        showHelp
    fi

    # Get the options, leading : silences errors
    while getopts ":hmvVi:o:" option; do
        case $option in
            i)
                INPUT_DIR=${OPTARG}
                ;;
            o)
                OUTPUT_DIR=${OPTARG}
                ;;
            v)
                VERBOSE=true
                log "Verbose mode is ON"
                ;;
            m)
                FORCE_MOVE=true
                echo "Force move is ON"
                ;;
            V)
                showVersion
                ;;
            h)
                showHelp
                ;;
            :)
                showError "-${OPTARG} requires an argument."
                showHelp
                ;;
            \?)
                showError "Invalid option."
                showHelp
                ;;
        esac
    done

    if [ ! -n "$INPUT_DIR" ]; then
        showError "Input directory cannot be empty."
        showHelp
    fi

    if [ ! -n "$OUTPUT_DIR" ]; then
        showError "Output directory cannot be empty."
        showHelp
    fi

    checkDirExists "$INPUT_DIR"
    checkDirExists "$OUTPUT_DIR"
    checkForFfmpeg
    generateAudioFileList "$INPUT_DIR"
}

# If/else block to allow logging to various places
if [[ "${ONLY_CONSOLE}" == true ]]; then
    main $@
elif [[ "${ONLY_LOG}" == true ]]; then
    main $@ >> $INSTALL_LOG 2>&1
else
    main $@ 2>&1 | tee -a $INSTALL_LOG
fi

exit 0
# Make sure to use find with $(pwd) to get the full path
# of the files if using this script with multiple
# files.

####################
# TODO
# - Allow batch or single folder/file modes
# - Clean up empty folders
####################

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


# Generate list of all audio files to process
find $(pwd) -type f -name '*.mp3' -o -name '*.flac' -o -name '*.m4a' > ../music_to_process

# Process all audio files
while read line; do ~/.dotfiles/scripts/mp3ToFolder.sh "$line"; done < ../music_to_process

# delete small directories
find . -maxdepth 1 -type d -exec du -s {} \; | sort -rn | awk '$1 == 0 {print $0}' | cut -d. -f2- > ../todelete

# due to the 'cut' above we lose the leading period
while read line; do rm -rf ".$line"; done < ../todelete

# Purge album covers
find . -type f -name 'cover*.jp*g' -o -name 'cover*.png' -delete