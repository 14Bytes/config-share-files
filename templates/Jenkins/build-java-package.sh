#!/bin/bash -ilex
#
# Script Name: Jenkins Java Project Shell
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: March 26, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified: April 09, 2024
#
# Description: Jenkins 打包发布 Java 项目脚本，包含清理旧的构建，
#              同时拷贝新的构建的 supervisor 的配置文件到服务器上。
#

# TODO: variables
DIR="${DIR:-/data}"

# TODO: function mkdir4Module()

# TODO: function copySupervisorConfig()
function copySupervisorConfig() {
  echo "The supervisor config 4 ${MODULE_NAME} has been successfully copied to the server"
}

# TODO: syncBuiltModule()

# TODO: function buildAllModule()
function buildAllModule() {
  echo "The all modules have been successfully built"
}

# TODO: function buildSignalModule()
function buildSignalModule() {
  echo "The signal module ${MODULE_NAME} has been successfully built"
}

# TODO: function cleanOldBuilds()
function cleanOldBuilds() {
  echo "Older packages have been successfully cleaned up"
}

# TODO: function checkApi()
function checkApi() {
  echo "The connectivity of the api was successfully tested"
}

# TODO: function main()
function main() {
  case "${MODULE_NAME}" in
    "all")
      cleanOldBuilds
      BuildAllModule
      syncBuiltModule
    ;;
    "*")
      cleanOldBuilds
      buildSignalModule
      syncBuiltModule
    ;;
  esac
}

mkdir4Moduler
copySupervisorConfig
main
