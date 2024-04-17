#!/bin/bash
#
# Jenkins 打包发布 Java 项目脚本
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: March 26, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified: April 17, 2024

# Globals:
#  SERVER
#  DIR
#  C08_URL
# Arguments:
#  None

SERVER="${SERVER:-127.0.0.1}"
DIR="${DIR:-/data}"
C08_URL="${C08_URL:-https://raw.githubusercontent.com/14Bytes/ShU7i15/main/templates/Jenkins/utils/clean-old-builds.sh}"

function echoInfo() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFO]\033[0m - \033[1;32m$1\033[0m"
}

function echoErrBasic() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

function initServer() {
  echoInfo "准备初始化 Jenkins 服务器和 Web 服务器"
  if [[ -f /data/scripts/C08.sh ]]; then
    echo "服务器已经执行过初始化了"
    return
  else
    echoInfo "下载 C08.sh 文件"
    wget "${C08_URL}" -O /data/scripts/C08.sh
    chmod +x /data/scripts/C08.sh

    echoInfo "创建 Web 服务器发布目录"
    ansible "${SERVER}" -m file -a "path=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} state=directory" -u nginx
    ansible "${SERVER}" -m file -a "path=${DIR}/contents/${JOB_NAME}/${MODULE_NAME} state=directory" -u nginx

    echoInfo "创建 Jenkins 拷贝目录"
    mkdir -p ../deploy_tmp/"${JOB_NAME}"
    echoInfo "创建项目回滚 .env 文件"
    touch ../deploy_tmp/."${JOB_NAME}".env
    return
  fi
}

function checkErr() {
  if [[ "${SERVER}" == "127.0.0.1" ]]; then
    echoErrBasic "项目不允许部署在 Jenkins 服务器上，如果需要请联系管理猿"
    exit 1
  elif [[ ! -f /data/scripts/C08.sh ]]; then
    echoErrBasic "C08.sh 脚本文件不存在，正在重新执行服务器初始化"
    initServer
    return
  else
    echoInfo "服务器不存在任何错误，执行清理任务"
    return
  fi
}

function cleanOldBuilds() {
  ansible "${SERVER}" -m script -a "chdir=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} /data/scripts/C08.sh" -u nginx
  echoInfo "清理任务执行完成，即将执行 ${METHOD} 指令"
}

# Deploy Method functions
function buildModules() {
  echoInfo "开始打包 ${MODULE_NAME} 模块"
  mvn clean package -pl -am "${MODULE_NAME}" -Dmaven.skip.test=true
  echoInfo "${MODULE_NAME} 模块打包成功，等待拷贝到同步目录"
  /bin/cp -rf ./"${MODULE_NAME}"/target/*.jar ../deploy_tmp/"${JOB_NAME}"/"${MODULE_NAME}".jar
  echoInfo "拷贝成功，准备执行同步命令"
}

function syncModules() {
  echoInfo "开始同步文件至应用服务器"
  ansible "${SERVER}" -m synchronize -a "src=../deploy_tmp/${JOB_NAME}/${MODULE_NAME}.jar dest=${DIR}/releases/${JOB_NAME}/${MODULE_NAME}/${MODULE_NAME}_${BUILD_DISPLAY_NAME}.jar delete=yes archive=no recursive=yes" -u nginx
  echoInfo "同步完成，准备创建软链"
}

function linkModules() {
  echoInfo "执行创建软链任务"
  ansible "${SERVER}" -m file -a "src=${DIR}/releases/${JOB_NAME}/${MODULE_NAME}/${MODULE_NAME}_${BUILD_DISPLAY_NAME}.jar dest=${DIR}/content/${JOB_NAME}/${MODULE_NAME}.jar state=link" -u nginx
  echoInfo "创建软链成功，准备使用 supervisor 进行 jar 包管理"
}

function monitorModules() {
  echoInfo "使用 supervisor 管理 ${JOB_NAME}-${MODULE_NAME} 包"
  ansible "${SERVER}" -m shell -a "sudo supervisorctl restart ${JOB_NAME}-${MODULE_NAME}" -u nginx
  echoInfo "supervisor 启动完成，等待执行 api 检查任务"
}

# Check Api functions
function findPort4Modules() {
  port=9901
}

function checkApi() {
  findPort4Modules

  echoInfo "${MODULE_NAME} 运行所在的端口为：${port}"

  case "${MODULE_NAME}" in
    *"admin"*)
      curl http://"${SERVER}":"${port}"/admin/api/prod
      ;;
    *"app"*)
      ;;
  esac
}


function main() {
  initServer
  checkErr
  cleanOldBuilds
  case "${METHOD}" in
    "deploy")
      buildModules
      syncModules
      linkModules
      monitorModules
      checkApi
      ;;
    "rollback")
      rollbackLink
      checkApi
      ;;
  esac
}

main "$@"
