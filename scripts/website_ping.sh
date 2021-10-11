#!/bin/bash

echo "Checking if website is up"

WEBSITES=(
  dominochinese.com
  iforwms.com
  thyme.cors.tech
  cors.tech
)

for SITE in "${WEBSITES[@]}"; do
    ping -n 1 $SITE
done

# IF OS is Darwin
# osascript -e 'display notification "Lorem ipsum dolor sit amet" with title "Title"'

