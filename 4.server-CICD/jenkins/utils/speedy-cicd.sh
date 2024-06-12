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
CONTENTS_PATH="/data/contents/${MODULE_NAME}/${CURRENT_DATE}"
SPEEDY_PATH="/usr/local/src/speedy-cicd"

if [ $# -ne 2 ]; then
  echo "使用方法: $0 <JOB_NAME> <MODULE_NAME>"
  exit 1
fi

function mk_contents_dir() {
  echo "为 ${MODULE_NAME} 创建新的 contents 目录"
  mkdir -p "${CONTENTS_PATH}"
  echo "目录创建成功"
}

function mv_jar_package() {
  echo "将 jar 包从临时目录移动到指定发布目录中"
  mv /usr/local/src/speedy-cicd/"${MODULE_NAME}".jar "${CONTENTS_PATH}"/
  ls -alFh "${CONTENTS_PATH}"
  echo "jar 包移动成功"
}

function mk_link() {
  echo "创建发布链接"
  ln -sfn "${CONTENTS_PATH}"/ /data/releases/"${MODULE_NAME}"
  ls -s /data/releases/"${MODULE_NAME}"
  echo "软链创建成功"
}

function restart_supervisord() {
  sleep 10
  supervisorctl restart "${JOB_NAME}-${MODULE_NAME}"
  supervisorctl status "${JOB_NAME}-${MODULE_NAME}"
}

function clean_old_java_package() {
  echo "${MODULE_NAME}.jar 将会被删除"
  /bin/rm -rf /usr/local/src/speedy-cicd/"${MODULE_NAME}".jar
  echo "${MODULE_NAME}.jar 删除成功"
}

function main() {
  echo "执行脚本之前请确保目录：/usr/local/src/speedy-cicd/ 存在，同时 jar 包已成功上传"
  if [ -f "${SPEEDY_PATH}"/"${MODULE_NAME}".jar ]; then
    mk_contents_dir
    mv_jar_package
    mk_link
    restart_supervisord
    clean_old_java_package
  else
    echo "文件或目录不存在"
    exit 1
  fi
}

main "$@"
