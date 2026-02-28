#!/bin/bash
#  <<< acts as the stdin i.e. user input
GLOBIGNORE=".git"
# $0 är kommandot själv $1 är första argumentet osv upp till $9
destination=$1
#om jag är hemma
if [[ $location == "h" ]]; then
  destination=192.168.1.41
# eller om jag kopplar direkt via ethernet
elif [[ $location == "e" ]]; then
  destination=192.168.3.10
else
  echo "lägg till argumentet 'h' om du är hemma eller 'e' om du kopplar direkt via ethernet/local-dhcp"
fi
rsync -rvaPhu src/ amalsthai@$destination:/home/amalsthai/mjukvara
