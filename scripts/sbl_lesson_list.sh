#!/bin/bash

TEMP_FILE=/tmp/sbl_page_source
URL=$1
SEASON=1

if [[ $2 ]]; then SEASON=$2; fi

SEASON=$(printf "%02d" "$SEASON")

wget -qO $TEMP_FILE "$URL"

FILES=$(
    grep init-course-modules $TEMP_FILE | \
        sed 's/:init-course-modules=//;s/"//g;s/&quot;/"/g;s/&amp;/and/g;s/lesson [0-9]\+\( -\|:\) //ig' | \
    jq '.[].items[].text' | \
    sed 's/ /./g;s/://g'| \
    tr -d '"' | tr "[:upper:]" "[:lower:]"
)

I=0
for F in $FILES; do
    ((I++))
    EPISODE=$(printf "%02d" "$I")
    FILENAME="s${SEASON}e${EPISODE}.${F}"
    touch "${FILENAME}"
    echo "Created ${FILENAME}"
done

echo
echo "All files created!"
