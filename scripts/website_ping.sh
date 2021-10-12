#!/bin/bash

WEBSITES=(
  dominochinese.com
  booking.indier.net
  kimtaichichina.com
  yangshuotaichi.com
  yibuparks.com
  expednet.cn
  iforwms.com
  thyme.cors.tech
  cors.tech
)
MESSAGE=""

function checkHost()
{
  # nc -z -w 3 $1 80
  nmap $1 -PN -p 80 | grep -iq open && echo "OK" || echo "FAIL"
}

for SITE in "${WEBSITES[@]}"; do
  STATUS=$(checkHost $SITE)
  MESSAGE="${MESSAGE}${SITE}: ${STATUS}\n"
done

if [[ $(uname -a|grep "Darwin") ]]; then
  #osascript -e "display notification \"${MESSAGE}\" with title \"Websites down!\""
  osascript -e "display alert \"Website Status\" message \"${MESSAGE}\""
fi

