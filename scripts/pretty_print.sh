
#!/bin/bash

# Pretty print echo statements
function pp() {
    # success - green - 32
    # warning - yellow - 33
    # error - red - 31
    # info - blue - 34

    COLOR=39 # default
    LEVEL=""
    SELF_NAME="[$(basename $0)] "

    if [[ $2 ]]; then
        LEVEL="[$2] "
    fi

    if [[ $3 ]]; then
        COLOR=$3
    fi

    # bold="\033[1m"
    # bold=""
    # dim="\033[2m"
    # dim=""
    # underlined="\033[4m"
    # underlined=""
    # inverted="\033[7m"
    # inverted=""
    FG="\033[${COLOR}m"
    RESET="\033[0m"
    NOW="$(date '+%Y-%m-%d %H:%M:%S') "

    echo
    echo -e "  ${FG}${NOW}${LEVEL}${SELF_NAME}${1}${RESET}"
    echo

    # echo -e "${fg}${inverted}${dim}${bold}${underlined}From pp func: $1${reset}"
}

# Pretty print success
function pps() {
    pp "$1" "SUCCESS" 32
}

# Pretty print info
function ppi() {
    pp "$1" "INFO" 34
}

# Pretty print warning
function ppw() {
    pp "$1" "WARNING" 33
}

# Pretty print error
function ppe() {
    pp "$1" "ERROR" 31
}

