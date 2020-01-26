# #!/bin/sh

# Bash script for displaying currently playing cmus song.
# To set up, run the following command inside cmus:
# :set status_display_program=<path-to-this-shell-script>

convertsecs() {
    # h=$(bc <<< "${1}/3600")
    ((m=(${1}%3600)/60))
    ((s=${1}%60))
    printf "%02d:%02d\n" $m $s
    # printf "%02d:%02d:%02d\n" $h $m $s
}

title=$(cmus-remote -Q | grep 'tag title' | cut -d ' ' -f 3-)
artist=$(cmus-remote -Q | grep 'tag artist' | cut -d ' ' -f 3-)
year=$(cmus-remote -Q | grep 'tag date' | cut -d ' ' -f 3-)
album=$(cmus-remote -Q | grep 'tag album' | cut -d ' ' -f 3-)
duration=$(cmus-remote -Q | grep 'duration' | cut -d ' ' -f 2-)
duration=$(convertsecs $duration)
# title=$(cmus-remote -Q | grep tag | head -n 3 | sort -r | cut -d ' ' -f 3- | head -n 1)
# album=$(cmus-remote -Q | grep tag | head -n 3 | sort -r | cut -d ' ' -f 3- | tail -n 1)
# artist=$(cmus-remote -Q | grep tag | head -n 3 | sort -r | cut -d ' ' -f 3- | head -n 2 | tail -n 1)
osascript -e "display notification \"${album//\"/\\\"}\" with title \"${title//\"/\\\"} (${year//\"/\\\"}) (${duration//\"/\\\"})\" subtitle \"${artist//\"/\\\"}\""
