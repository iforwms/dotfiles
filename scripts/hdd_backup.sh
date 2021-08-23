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

echo "########### Drive mirroring starting at `date` ###########"

SOURCE=/Volumes/IFOR2TB
DEST=/Volumes/IFOR2TB_Backup

rsync -ahvAE --dry-run --delete --stats $SOURCE $DEST 2>&1 | tee /var/log/hdd-backup.log

echo "########### Drive mirroring completed at `date` ###########"

