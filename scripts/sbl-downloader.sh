#!/bin/bash

# Visit video page search for 720p. Right click on
# the container script tag and copy inner HTML.
# PAste this into an extensionless file with the
# desired name of the video file. Do this for as many
# files as you like then run the following command
# (where XX is a wildcard matching your files):
# for file in XX; do wget $(./sbl-downloader.sh $file) -O $file.mp4; done
cat $1|tr -d '\n'|grep -o 'var config.*; if (!config.request)'|sed 's/; if (!config.request)//;s/var config =//'|jq -r '.request.files.progressive[]|select(.quality == "720p")|.url'
