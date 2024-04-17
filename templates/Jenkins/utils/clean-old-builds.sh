#!/bin/bash
#
# Script Name: clean-old-builds.sh
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: April 17, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified:  April 17, 2024
#
# Description: Clean old Jenkins build stage
#

function cleanOldBuildStage(){
  local total
  local delAppNum
  local delAppList

  total=$( ls | wc -l)

  if [ ${total} -gt 5 ]; then
    delAppNum=$(( total - 5 ))
    delAppList=$(ls -tr | head -"${delAppNum}")
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[WARNING]\033[0m - \033[1;31m以下发布将被删除：\n\033[0m${delAppList}"
    sudo rm -rf "${delAppList}"
  fi
}

function main() {
  cleanOldBuildStage
}

main
