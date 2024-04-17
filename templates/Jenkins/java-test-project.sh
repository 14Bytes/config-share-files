#!/bin/bash
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

# TODO： 常量部分
SERVER="${SERVER:-127.0.0.1}"
DIR="${DIR:-/data}"

function initServer() {
  echo "准备执行初始化服务器"
  if [[ -f ."${JOB_NAME}".env ]]; then
    echo "服务器已经初始化过了"
    return
  else
    ansible "${SERVER}" -m file -a "path=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} state=directory" -u nginx
    ansible "${SERVER}" -m file -a "path=${DIR}/content/${JOB_NAME} state=directory" -u nginx
    mkdir -p ../deploy_tmp/"${JOB_NAME}"
    touch ."${JOB_NAME}".env
    wget https://raw.githubusercontent.com/14Bytes/ShU7i15/main/templates/Jenkins/utils/clean-old-builds.sh -O /data/scripts/clean-old-builds.sh
    chmod +x /data/scripts/clean-old-builds.sh
    echo "初始化服务器完成"
  fi
}

function buildModules() {
  echo "开始打包 ${MODULE_NAME} 模块"
  mvn clean package -pl "${MODULE_NAME}" -am -Dmaven.test.skip=true
  echo "${MODULE_NAME} 模块打包成功，等待拷贝到临时目录中"
  /bin/cp -rf ./"${MODULE_NAME}"/target/*.jar ../deploy_tmp/"${JOB_NAME}"/"${MODULE_NAME}".jar
  echo "拷贝成功，等待同步至应用服务器"
}

function synchronize() {
  echo "同步 ${MODULE_NAME} 至应用服务器 ${SERVER}"
  ansible "${SERVER}" -m synchronize -a "src=../deploy_tmp/${JOB_NAME}/${MODULE_NAME}.jar dest=${DIR}/releases/${JOB_NAME}/${MODULE_NAME}/${MODULE_NAME}_${BUILD_DISPLAY_NAME}.jar delete=yes archive=no recursive=yes" -u nginx
  echo "同步完成，创建软链中"
}

function mkLink() {
  echo "从 /data/releases/${JOB_NAME}/${MODULE_NAME} 下创建软链到 /data/content/${JOB_NAME}/${MODULE_NAME} 中"
  ansible "${SERVER}" -m file -a "src=${DIR}/releases/${JOB_NAME}/${MODULE_NAME}/${MODULE_NAME}_${BUILD_DISPLAY_NAME}.jar dest=${DIR}/content/${JOB_NAME}/${MODULE_NAME}.jar state=link" -u nginx
  echo "软链创建完成，等待 supervisor 服务"
}

function javaMonitor() {
  echo "使用 supervisor 管理 ${JOB_NAME}-${MODULE_NAME} 包"
  ansible "${SERVER}" -m shell -a "sudo supervisorctl restart ${JOB_NAME}-${MODULE_NAME}" -u nginx
  echo "应用启动成功"
}

function checkErr() {
  if [[ "${SERVER}" == "127.0.0.1" ]]; then
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m不允许发布至 Jenkins 服务器\033[0m"
    exit 1
  elif [[ -f /data/scripts/clean-old-builds.sh ]]; then
    echo "未拉取清理 Jenkins 脚本"
    rm -rf ."${JOB_NAME}".env
    initServer
    return
  else
    return
  fi
}

function cleanOldBuild() {
  echo "执行清理旧构建脚本"
  ansible "${SERVER}" -m script -a "chdir=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} /data/scripts/clean-old-builds.sh" -u nginx
  echo "脚本执行结束，继续执行 deploy 操作"
}


# TODO: function checkApi()
# TODO: 生产环境需要部署
function checkApi() {
  echo "检查 ${JOB_NAME}-${MODULE_NAME} 模块的运行情况"
}

function deploy() {
  buildModules
  synchronize
  mkLink
  javaMonitor
  echo "${BUILD_DISPLAY_NAME}\ ${SERVER}\ ${MODULE_NAME}" >> ."${JOB_NAME}".env
}

# TODO: function rollback()
function rollback() {
  echo "准备回滚服务"
}

function main() {
  checkErr
  initServer

  if [[ "${METHOD}" == "deploy" ]]; then
    cleanOldBuild
    deploy
  else
    rollback
  fi
}

main
