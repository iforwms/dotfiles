#!/usr/bin/env bash

# Description of the Script
# Version 2021110300
# Copyright 2021 Ifor Waldo Williams <ifor@cors.tech>

# Optionally add default arguments here.

dependencies=()

main() {
    echo "Hi, I'm the main function!"
    exit 0
}

usage() {
  cat <<MSG

  Download the latest file in an S3 folder.

  Usage: ./$(basename "${BASH_SOURCE[0]}") [options]

  Options:
    -b, --bucket <name>         Name of your S3 bucket.
    -r, --remote-folder <path>  The full path to your rbackup directory.
    -l, --local-folder <path>   Full path to your local download directory.
    -p, --profile <name>        S3 profile if not using your default profile.
    -h, --help                  Display this usage information.

  Environmental Options:
    DEBUG=true                  Enable debug mode.
    VERBOSE=true                Enable verbose mode.

  Example:
    ./$(basename "${BASH_SOURCE[0]}") -b bucket_name --profile prod

MSG
    exit 1
}

check_dependencies() {
    for dependency in "${dependencies[@]}"; do
        command -v "${dependency}" \
            || >&2 echo "Missing required dependency: '${dependency}'"; \
            exit 1
    done
}

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    echo "Cleaning up..."
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            # -b|--bucket)
            #     bucket="${2%/}"
            #     ;;
            -h|--help)
                usage
                ;;
        esac
        shift
    done
}

if [[ ${VERBOSE-} =~ ^1|yes|true$ ]]; then
    set -o verbose
    echo "Verbose mode enabled."
fi

if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace
    echo "Debug mode enabled."
fi

# Enable error detection if script is not being sourced.
if ! (return 0 2> /dev/null); then
    set -o errexit -o nounset -o pipefail
fi

set -o errtrace # Ensure the error trap handler is inherited

trap cleanup SIGINT SIGTERM ERR EXIT # Run `cleanup` on exit

parse_args "$@"
check_dependencies
main
