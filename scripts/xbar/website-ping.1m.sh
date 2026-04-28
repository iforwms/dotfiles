#!/usr/bin/env bash

websites=(
  bikeasia.com
  booking.indier.net
  cindra.se
  cors.tech
  dominochinese.com
  expednet.cn
  felixweddings.com
  husfokus.com
  iforwms.com
  indier.net
  indier.org
  karstclimber.com
  kimtaichichina.com
  plan.cindra.se
  portal.karstclimber.com
  theindier.org
  thyme.cors.tech
  wildmed.asia
  wmai.wildmed.asia
  yangshuotaichi.com
)

failures=()
output=""

for site in "${websites[@]}"; do
  echo "Checking ${site}..."
  status_code=$(curl -sL --head -w "%{http_code}" "$site" -o /dev/null)

  if [[ "$status_code" != "200" ]]; then
    failures+=("$site ($status_code)")
    output+="❌ $site — $status_code\n"
  else
    output+="✅ $site — OK\n"
  fi
done

# Menu bar icon
if [[ ${#failures[@]} -eq 0 ]]; then
  echo "✅"
else
  echo "❗"
fi

echo "---"

# Dropdown content
if [[ ${#failures[@]} -eq 0 ]]; then
  echo "All sites OK"
else
  printf "%b" "$output"
fi

echo "---"
echo "Refresh | refresh=true"
