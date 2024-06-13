#!/bin/bash
#
# 半自动 CI&CD Java 项目发布脚本
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

JOB_NAME=$1
MODULE_NAME=$2
CURRENT_DATE=$(date +"%Y%m%d%H%M%S")
CONTENTS_PATH="/data/contents/${JOB_NAME}/${MODULE_NAME}/${CURRENT_DATE}"
SPEEDY_PATH="/usr/local/src/speedy-cicd"

# Information Function
function echo_info() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFO]\033[0m - \033[1;32m$1\033[0m"
}

function echo_alert() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

function echo_error_basic() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

# 判断传递的参数个数
if [ $# -ne 2 ]; then
  echo_error_basic "使用方法: $0 <JOB_NAME> <MODULE_NAME>"
  exit 1
fi

function mk_contents_dir() {
  echo_alert "为 ${MODULE_NAME} 创建新的 contents 目录"
  mkdir -p "${CONTENTS_PATH}"
  echo_info "目录创建成功"
}

function mv_jar_package() {
  echo_alert "将 jar 包从临时目录移动到指定发布目录中"
  mv /usr/local/src/speedy-cicd/"${MODULE_NAME}".jar "${CONTENTS_PATH}"/
  ls -alFh "${CONTENTS_PATH}"
  echo_info "jar 包移动成功"
}

function mk_link() {
  echo_alert "创建发布链接"
  ln -sfn "${CONTENTS_PATH}"/ /data/releases/"${JOB_NAME}"/"${MODULE_NAME}"
  ls -s /data/releases/"${JOB_NAME}"/"${MODULE_NAME}"
  echo_info "软链创建成功"
}

function restart_supervisord() {
  sleep 6
  supervisorctl restart "${JOB_NAME}-${MODULE_NAME}"
  supervisorctl status "${JOB_NAME}-${MODULE_NAME}"
}

function clean_old_package() {
  local total
  local delAppNum
  local delAppList

  total=$( ls | wc -l)

  if [ ${total} -gt 5 ]; then
    delAppNum=$(( total - 5 ))
    delAppList=$(ls -tr | head -"${delAppNum}")
    echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[WARNING]\033[0m - \033[1;31m以下发布将被删除：\n\033[0m${delAppList}"
    sudo rm -rf "${delAppList}"
  fi
}

function main() {
  echo_alert "执行脚本之前请确保目录：/usr/local/src/speedy-cicd/ 存在，同时 jar 包已成功上传"
  if [ -f "${SPEEDY_PATH}"/"${MODULE_NAME}".jar ]; then
    mk_contents_dir
    mv_jar_package
    mk_link
    restart_supervisord
    /bin/cd /data/contents/"${JOB_NAME}"/"${MODULE_NAME}"
    clean_old_package
  else
    echo_error_basic "文件或目录不存在"
    exit 1
  fi
}

function test() {
  :
}

# test "$@"

main "$@"
