#!/usr/bin/env bash

# Logging Script
#
# ifor@cors.tech

# shellcheck source=/dev/null
source "${DOTFILES}/scripts/colors.sh"

declare -A _log_color
# These are the python numeric log levels, with the addition
# of RFC 5424 levels. The RFC 5424 levels have been given
# numbers to sequence them with the python levels.
_log_color[TRACE]="$(dim +)"
_log_color[DEBUG]="$(dim +)"
_log_color[INFO]="$(white)"
_log_color[NOTICE]="$(green +)" # RFC 5424 specific
_log_color[MARK]="$(yellow +)$(inverse +)"
_log_color[WARN]="$(yellow +)"
_log_color[WARNING]="$(yellow +)"
_log_color[HEADING]="$(cyan +)$(inverse +)"
_log_color[ERR]="$(red +)"
_log_color[ERROR]="$(red +)"
_log_color[CRIT]="$(red +)$(bold +)"
_log_color[CRITICAL]="$(red +)$(bold +)"
_log_color[ALERT]="$(red +)$(bold +)$(inverse +)" # RFC 5424 specific
_log_color[EMERG]="$(bg_red +)$(bold +)$(white +)" # RFC 5424 specific
_log_color[EMERGENCY]="$(bg_red +)$(bold +)$(white +)" # RFC 5424 specific
declare -r _log_color

log() {
    local self_name
    local line_no
    local now

    local line="$1"
    local log_dir="${HOME}/logs"

    self_name="$(basename "$0")"
    # line_no="${BASH_LINENO[0]}"

    local message_level="INFO"
    if [[ -n $2 ]]; then
        message_level="$2"
    fi

    now="$(date '+%Y-%m-%d %H:%M:%S')"

    mkdir -p "${log_dir}" 2>/dev/null
    touch "${log_dir}/${self_name}.log"

    printf -v output "${_log_color[$message_level]}%s [%s] %s: %s\n" "${now}" "${self_name}" "${message_level}" "${line}$(reset)"

    echo -n "${output}" >&2

    # shellcheck disable=2005 # Decolor is search and replace
    echo "$(decolor "${output}")" >> "${HOME}/logs/${self_name}.log"
}

log_n() {
    log "$1" "NOTICE"
}

log_d() {
    log "$1" "DEBUG"
}

log_w() {
    log "$1" "WARNING"
}

log_e() {
    log "$1" "EMERG"
}

