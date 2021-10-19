#!/bin/bash

TEMP_FILE=/tmp/sbl_page_source
TEMP_DIR=$(mktemp -d)
URL=$1
SEASON=1

if [[ $2 ]]; then SEASON=$2; fi

SEASON=$(printf "%02d" "$SEASON")

wget -qO $TEMP_FILE "$URL"

DOWNLOADS=$(
    grep :downloads= $TEMP_FILE | \
    sed 's/:downloads=//;s/"//g;s/&quot;/"/g;s/&amp;/and/g' | \
    jq '.[].url' | \
    tr -d '"'
)

FILES=$(
    grep init-course-modules $TEMP_FILE | \
    sed 's/:init-course-modules=//;s/"//g;s/&quot;/"/g;s/&amp;/and/g' | \
    jq '.[].items[].uri'
)

I=0
for F in $FILES; do
    ((I++))
    COURSE=$(echo "${F}" | cut -d "/" -f 2 | tr "-" ".")
    FILE=$(echo "${F}" | cut -d "/" -f 3 | sed 's/lesson [0-9]\+\( -\|:\) //ig' | tr "-" "." | tr -d '"')
    EPISODE=$(printf "%02d" "$I")
    FILENAME="${COURSE}.s${SEASON}e${EPISODE}.${FILE}"
    touch "${TEMP_DIR}/${FILENAME}"
    echo "Created ${TEMP_DIR}/${FILENAME}"
done

echo
echo "All files created!"

for D in $DOWNLOADS; do
    echo "Downloading ${D}"
    wget -qP "${HOME}/Downloads" "$D"
done

echo
echo "All files downloaded!"

open -a "/Applications/Sublime Text.app" "$TEMP_DIR"
