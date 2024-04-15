#!/bin/bash -ilex
#
# Script Name: Jenkins Java Project Shell
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: March 26, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified: April 15, 2024
#
# Description: Jenkins 打包发布 Java 项目脚本，包含清理旧的构建，同时拷贝 supervisor 的配置文件到服务器上。
#

# TODO: variables
SERVER="${SERVER:-127.0.0.1}"
DIR="${DIR:-/data}"

# Enable JMX monitor 4 all project, not only 4 signal module
ENABLE_JMX="${ENABLE_JMX:-false}"

function errInfo() {
  if [ "$SERVER" == "127.0.0.1" ]; then
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m Disabled deploy ${JOB_NAME} project to Jenkins Server\n\033[0m"
  fi
}

function mkdir4Modules() {
  echo "Making directory path 4 modules"

  ansible "${SERVER}" -m file \
    -a "path=${DIR}/releases/${JOB_NAME} state=directory" -u nginx
  ansible "${SERVER}" -m file \
    -a "path=${DIR}/content/${JOB_NAME} state=directory" -u nginx

  echo "Dir path has been successfully created"
}

# TODO: function findNotUsingPort()
function findNotUsingPort() {
  echo "Find port which is not in using 4 module"

  echo "The port 4 ${MODULE_NAME} is "
}

# TODO: function copySupervisorConfig()
function copySupervisorConfig() {
  case ${ENABLE_JMX} in
    "false")
      echo "Copying supervisor config 4 ${MODULE_NAME} without JMX monitor"
    ;;
    "true")
      echo "Copying supervisor config 4 ${MODULE_NAME} with JMX monitor"
    ;;
  esac

  echo "The supervisor config 4 ${MODULE_NAME} has been successfully copied to the server"
}

function syncAndLinkBuiltModule() {
  echo "Syncing built module to web server"
  ansible "${SERVER}" -m synchronize \
    -a "src=../deploy_tmp/${JOB_NAME} dest=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME}/ compress=yes delete=yes recursive=yes dir = yes archive=no" -u nginx
  echo "${MODULE_NAME} has been successfully synced"

  echo "Linking built module"
  ansible "${SERVER}" -m file \
    -a "src=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME} dest=${DIR}/content/${JOB_NAME} state=link" -u nginx
  echo "${JOB_NAME} has been successfully linked"
}

function buildAllModule() {
  echo "Building all modules"
  mvn clean package -Dmaven.test.skip=true
  echo "The all modules have been successfully built"
}

function buildSignalModule() {
  echo "Building the signal module ${MODULE_NAME}"
  mvn clean package -Dmaven.test.skip=true -am -pl "$1"
  echo "The signal module ${MODULE_NAME} has been successfully built"
}

# TODO: function cleanOldBuilds()
function cleanOldBuilds() {
  echo "Cleaning old builds for ${JOB_NAME}"

  if [[ -f /data/scripts/clean-old-builds.sh ]]; then
    # TODO: git clone Jenkins/Utils 目录下的所有文件
    echo "Git clone Jenkins/Utils 目录下的所有文件"
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

# TODO: function deploy()
function deploy() {
  echo "Deploying ${JOB_NAME} to ${SERVER}"
}

# TODO: function rollback()
function rollback() {
  echo "Rolling back ${JOB_NAME} in ${SERVER} to ${ROLLBACK_VERSION}"
}

# TODO: function main()
function main() {
  case "${METHOD}" in
    "deploy")
      deploy
    ;;
    "rollback")
      rollback
    ;;
  esac

  echo "The ${JOB_NAME} has been successfully deployed"
}

main
