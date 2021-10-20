#!/bin/bash

USERNAME=iforwms
PASSWORD=@Pa555C0TT5
COURSE_URL=$1
COOKIE=/tmp/sbl_cookie
# TEMP_FILE=/tmp/sbl_page_source

curl 'https://scottsbasslessons.com/academy-login' \
-c $COOKIE \
-X POST \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
-H 'Accept-Language: en-US,en;q=0.5' \
--compressed \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Origin: https://scottsbasslessons.com' \
-H 'Connection: keep-alive' \
-H 'Referer: https://scottsbasslessons.com/academy-login' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'Sec-Fetch-Dest: document' \
-H 'Sec-Fetch-Mode: navigate' \
-H 'Sec-Fetch-Site: same-origin' \
-H 'Sec-Fetch-User: ?1' \
-H 'Pragma: no-cache' \
-H 'Cache-Control: no-cache' \
--data-raw "action=membership%2Fusers%2Flogin&redirect=${COURSE_URL}&loginName=${USERNAME}&password=${PASSWORD}&rememberMe=1"

jq -crRs 'split("\n")[4:-1] | map([split("\t")[]] | { "domain":.[0], "httpOnly": .[3], "flag": .[1], "path": .[2], "secure": .[3], "expiration": .[4], "name": .[5], "value": .[6] })' "$COOKIE" | \
sed 's/"false"/false/gi;s/"true"/true/gi;s/#HttpOnly_//g' > "${COOKIE}.json"

# cat "$COOKIE"
# jq . "${COOKIE}.json"
# curl -b "$COOKIE" "$COURSE_URL" > "$TEMP_FILE"
# $DOTFILES/scripts/sbl_lesson_list.sh
