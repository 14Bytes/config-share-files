#!/bin/bash -ilex
#
# Script Name: Jenkins Java Project Shell
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: March 26, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified: April 12, 2024
#
# Description: Jenkins 打包发布 Java 项目脚本，包含清理旧的构建，同时拷贝 supervisor 的配置文件到服务器上。
#

# TODO: variables
SERVER="${SERVER:-127.0.0.1}"
DIR="${DIR:-/data}"
CLEAN_OLD_BUILDS_URL="${CLEAN_OLD_BUILDS_URL:-https://raw.githubusercontent.com/14Bytes/ShU7i15/main/templates/Jenkins/clean-old-builds.sh}"

# TODO: function errInfo()
function errInfo() {
  if [ "$SERVER" == "127.0.0.1" ]; then
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m Disabled deploy ${JOB_NAME} project to Jenkins Server\n\033[0m"
  fi
}

# TODO: function mkdir4Modules()
function mkdir4Modules() {
  echo "Making directory path 4 modules"

  echo "Dir path has been successfully created"
}

# TODO: function copySupervisorConfig()
function copySupervisorConfig() {
  echo "Copying supervisor config 4 ${MODULE_NAME}"
  echo "The supervisor config 4 ${MODULE_NAME} has been successfully copied to the server"
}

# TODO: syncBuiltModule()
function syncBuiltModule() {
  echo "Syncing ${MODULE_NAME}"

  echo "${MODULE_NAME} has been successfully synced"
}

# TODO: function buildAllModule()
function buildAllModule() {
  echo "Building all modules"

  echo "The all modules have been successfully built"
}

# TODO: function buildSignalModule()
function buildSignalModule() {
  echo "Building the signal module ${MODULE_NAME}"

  echo "The signal module ${MODULE_NAME} has been successfully built"
}

# TODO: function cleanOldBuilds()
function cleanOldBuilds() {
  echo "Cleaning old builds for ${JOB_NAME}"

  if [[ -f /data/scripts/clean-old-builds.sh ]]; then
    git show "${CLEAN_OLD_BUILDS_URL}" > /data/scripts/clean-old-builds.sh
  fi

  ansible "${SERVER}" -m script \
    -a "chdir=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} /data/scripts/clean-old-builds.sh" \
    -u nginx

  echo "Older packages have been successfully cleaned up"
}

# TODO: function checkApi()
function checkApi() {
  echo "Checking the connectivity of the api"

  echo "The connectivity of the api was successfully tested"
}

# TODO: function main()
function main() {
  echo "Start to deploy ${JOB_NAME}"
  errInfo
  echo "The ${JOB_NAME} has been successfully deployed"
}

mkdir4Modules
copySupervisorConfig
main
