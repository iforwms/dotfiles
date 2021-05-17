#!/bin/bash

source $HOME/.dotfiles/scripts/pretty_print.sh

if [[ ! $1 ]]; then
    ppe "Filename required."
    exit 1
fi

pandoc $1 --variable mainfont="Open Sans" --variable sansfont="Roboto" --variable monofont="Fira Code" --variable fontsize=12pt --metadata pagetitle="$1" --from=gfm --pdf-engine=wkhtmltopdf --output $1.pdf

