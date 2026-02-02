#!/bin/bash
#  <<< acts as the stdin i.e. user input

# $0 är kommandot själv $1 är första argumentet osv upp till $9
location=$1
#om jag är hemma
if [[ $location == "h" ]]; then
  sftp amalsthai@192.168.1.41:/home/amalsthai/mjukvara <<< $'put -r ./'
# eller om jag kopplar direkt via ethernet
elif [[ $location == "e" ]]; then
  sftp amalsthai@192.168.1.100:/home/amalsthai/mjukvara <<< $'put -r ./'
else
  echo "lägg till argumentet 'h' om du är hemma eller 'e' om du kopplar direkt via ethernet/local-dhcp"
fi
