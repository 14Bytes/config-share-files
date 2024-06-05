#!/bin/bash
#
# 自动拷贝上传文件至发布目录，并进行半自动化部署
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

PROJECT_NAME=$1
MODULE_NAME=$2
RELEASE_DATE=$(date + "%Y%m%d+%H%M%S")

if [ $# -ne 2 ]; then
  echo "使用方法: $0 <project_name> <module_name>"
  exit 1
fi

function create_dir() {
  echo "创建部署目录"
  mkdir -p /data/contents/"${PROJECT_NAME}"/"${MODULE_NAME}"/"${RELEASE_DATE}"
}

function copy_files() {
  echo "拷贝文件至部署目录"
}

function make_link() {
  echo "创建软链至发布目录"
}

function clean_old() {
  echo "清理旧的构建目录"
}

function main() {
  create_dir
  copy_files
  make_link
  clean_old
}

main "$@"
