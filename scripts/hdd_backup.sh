#!/bin/bash

# Backup HDD contents from one disk to another
#
# a - Archive move; ensure common metadata is copied over
# h - Human readable numbers are output instead of bytes
# v - Increase verbosity of the output
# A - Preserve ACLs; also implies p (preserve permissions)
# E - Preserve executability
# delete - Delete file on the destination that don't exist on source; clean up deleted files in backup
# stats - Give some file-transfer stats

SOURCE=/Volumes/IFOR2T
DEST=/Volumes/IFOR2T_Backup

if [ ! -d $SOURCE ]; then
    echo "Source drive not found, aborting..."
    exit 1
fi

if [ ! -d $DEST ]; then
    echo "Destination drive not found, aborting..."
    exit 1
fi

echo "########### HDD backup starting at $(date) ###########"

rsync -ahvAE --delete --stats $SOURCE $DEST 2>&1 | tee /Users/ifor/hdd-backup.log

if [ "$?" -eq 0 ];
then
    echo
    echo "########### HDD backup completed at $(date) ###########"
    echo
    exit 0
else
    echo
    echo "HDD backup failed."
    echo
    exit 1
fi

