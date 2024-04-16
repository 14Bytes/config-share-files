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


SERVER="${TARGET_IP:-127.0.0.1}"  # 由于生产环境需要轮询此变量梯次重启服务，故此变量不能写ansible hosts分组名。
DIR="${DIR:-/data}"

function main() {
  initServer
  if [[ "${METHOD}" == "deploy" ]]; then
    echo "开始部署应用到服务器上"

    case "${MODULE_NAME}" in
      "all")
        mvn clean package -Dmaven.test.skip=true
        # TODO: 遍历构建所有的模块并copy到指定目录
        syncAndLink
        ;;
      "*")
        mvn clean package -Dmaven.test.skip=true -am -pl "${MODULE_NAME}"
        /bin/cp -rf ./"${MODULE_NAME}"/target/*.jar ../deploy_tmp/"${JOB_NAME}"/"${MODULE_NAME}".jar
        syncAndLink
        ;;
    esac

    echo "部署应用到服务器上完成"
  else
    rollback
  fi
}

function initServer() {
  echo "初始化 Jenkins 服务器和 Web 服务器"
  [[ -f ../deploy_tmp/"${JOB_NAME}" ]] && echo "已经初始化过了" && exit 1

  ansible "${SERVER}" -m file -a "path=${DIR}/releases/${JOB_NAME}/${MODULE_NAME} state=directory" -u nginx
  ansible "${SERVER}" -m file -a "path=${DIR}/content/${JOB_NAME} state=directory" -u nginx

  mkdir -p ../deploy_tmp/"${JOB_NAME}"
  echo "初始化 Jenkins 服务器和 Web 服务器完成"
}

function syncAndLink() {
  echo "同步打包的博客并创建软链"
}

function checkApi() {
  echo "检查 API 是否正常"
}

main
