#!/bin/bash -ilex
#
# Script Name: Jenkins Java Project Shell
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: April 16, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified: April 16, 2024
#
# Description: Jenkins 打包发布 Vue 项目脚本，包含清理旧的构建。
#

# TODO： 常量部分
ENV="${ENV:-test}"

# TODO： function initServer()
function initServer() {
  echo "初始化服务器"
}

# TODO： function deploy.sh()

# TODO: function rollback()

# TODO: function buildModules()

function buildModules() {
  echo "构建模块"
  case "${ENV}" in
    "test")
      ;;
    "prod")
      ;;
    "*")
      echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m未指定正确的部署环境\033[0m"
      ;;
  esac
}

# TODO: function synchronize()

# TODO: function mkLink()

function checkErr() {
  echo "前置错误检查"
  if [[ "${SERVER}"  == "127.0.0.1" ]]; then
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m不允许部署到 Jenkins 服务器上\033[0m"
    exit 1
  else
    return
  fi
}

# TODO: function cleanOldBuild()

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
