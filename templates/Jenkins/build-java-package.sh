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

SERVER="${SERVER:-127.0.0.1}"
DIR="${DIR:-/data}"

#function errInfo() {
#  if [ "$SERVER" == "127.0.0.1" ]; then
#    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m Disabled deploy ${JOB_NAME} project to Jenkins Server\n\033[0m"
#  fi
#}

function mkdir4Module() {
  echo "mkdir 4 module"
  ansible "${SERVER}" -m file -a "path=${DIR}/releases/${JOB_NAME} state=directory" -u nginx
  mkdir -p ../deploy_tmp/"${JOB_NAME}"
}

function deploy() {
  echo "Start deploy ${JOB_NAME} project to  ${SERVER}"
  mkdir4Module
  case "${MODULE_NAME}" in
  "all")
    echo "Building all modules in ${JOB_NAME} project"
    mvn clean package -Dmaven.test.skip=true
    echo "syncing Module and linking path"
    ansible "${SERVER}" -m synchronize \
      -a "src=../deploy_tmp/${JOB_NAME} dest=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME}/ \
      compress=yes delete=yes recursive=yes dirs=yes archive=no" \
      -u nginx
    ansible "${SERVER}" -m file \
      -a "src=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME}/${JOB_NAME} \
      dest=${DIR}/content/${JOB_NAME} state=link" -u nginx
    ansible "${SERVER}" -m shell \
      -a "sudo supervisorctl restart ${JOB_NAME}-{${MODULE_NAME}}" \
      -u nginx
    ;;
  "*")
    echo "Building ${MODULE_NAME} module in ${JOB_NAME} project"
    mvn clean package -Dmaven.test.skip=true -pl -am "${MODULE_NAME}"
    echo "syncing Module and linking path"
    ansible "${SERVER}" -m synchronize \
      -a "src=../deploy_tmp/${JOB_NAME} dest=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME}/ \
      compress=yes delete=yes recursive=yes dirs=yes archive=no" \
      -u nginx
    ansible "${SERVER}" -m file \
      -a "src=${DIR}/releases/${JOB_NAME}/${BUILD_DISPLAY_NAME}/${JOB_NAME} \
      dest=${DIR}/content/${JOB_NAME} state=link" -u nginx
    ansible "${SERVER}" -m shell \
      -a "sudo supervisorctl restart ${JOB_NAME}-${MODULE_NAME}" \
      -u nginx
    ;;
  esac
}

# TODO: function rollback()
function rollback() {
  echo "Rolling back ${JOB_NAME} project in ${SERVER} to ${ROLLBACK_VERSION}"
}

function main() {
  case "${METHOD}" in
    "deploy")
      deploy
    ;;
    "rollback")
      rollback
    ;;
  esac
}

main
