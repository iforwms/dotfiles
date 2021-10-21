#!/bin/bash

set -o errexit  # Exit the script if any command fails (add "|| true" to allow failing)
set -o nounset  # Exit the script if an undeclared variable is used
set -o pipefail # Exit the script if an error occurs in a pipe
# set -o xtrace # Enable bash debug output
# set -o verbose # Enable verbose output

log()
{
    echo "----------"
    echo "log ${FUNCNAME} ${@}"
    echo "----------"
}

main()
{
    for n in 0 1 2 3 4 5
    do
          echo "BASH_VERSINFO[$n] = ${BASH_VERSINFO[$n]}"
      done

      log "${FUNCNAME}:${LINENO} testing 123"

      __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
      __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
      __base="$(basename ${__file} .sh)"
      __root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

      arg1="${1:-}"
       echo $__dir
       echo $__file
       echo $__base
       echo $__root
       echo $arg1


    if [[ "${OSTYPE}" = "linux-gnu" ]]; then
        echo "GNU Linux"
    elif [[ "${OSTYPE}" = "darwin"* ]]; then
        echo "Mac OSX"
    elif [[ "${OSTYPE}" = "cygwin" ]]; then
        echo "POSIX compatibility layer and Linux environment emulation for Windows"
    elif [[ "${OSTYPE}" = "msys" ]]; then
        echo "Lightweight shell and GNU utilities compiled for Windows (part of MinGW)"
    elif [[ "${OSTYPE}" = "win32" ]]; then
        echo "I'm not sure this can happen."
    elif [[ "${OSTYPE}" = "freebsd"* ]]; then
        echo "..."
    else
        echo "Unknown."
    fi
    echo sleeping
    sleep 3
    exit 0
}

# Avoid temporary files, e.g. diff <(wget -O - url1) <(wget -O - url2)

help_wanted() {
    [ "$#" -ge "1" ] && [ "$1" = '-h' ] || [ "$1" = '--help' ] || [ "$1" = "-?" ]
}

usage() {
    echo "Example usage."
}

# if help_wanted "$@"; then
#     usage
#     exit 0
# fi

finish() {
    result=$?
    echo "Cleaning up after myself"
    exit ${result}
}

ctrl_c() {
    echo "** Trapped CTRL-C"
    exit 1
}

trap finish EXIT ERR
trap ctrl_c INT

main "${@}"
