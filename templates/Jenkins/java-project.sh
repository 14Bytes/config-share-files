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

# TODO： 常量部分

# TODO： function initServer()
function initServer() {
  echo "初始化服务器"
}

# TODO： function deploy()

# TODO: function rollback()

# TODO: function buildModules()

# TODO: function synchronize()

# TODO: function mkLink()

# TODO: function checkErr()
# TODO: Err1: Server = 127.0.0.1
# TODO: Err2: Util Function exist

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
