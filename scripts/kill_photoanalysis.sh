#!/bin/bash

# Installation:
# crontab -e
# * * * * * /Users/ifor/.dotfiles/scripts/kill_photoanalysis.sh
sudo killall photoanalysisd 2>/dev/null
