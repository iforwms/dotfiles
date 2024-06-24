export VISUAL=vim
export EDITOR="$VISUAL"

set -o vi

dl_folder="${HOME}/storage/downloads"
if [[ -e "$dl_folder" ]]; then
  cd "$dl_folder"
fi

