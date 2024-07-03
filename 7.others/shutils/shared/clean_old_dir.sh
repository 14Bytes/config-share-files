#!/bin/bash
#
# 删除旧的文件夹
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

source ../core/inwaer_logs.sh

function judge_dir_can_delete() {
  # local BASIC_DIR
  # local DIR_CAN_DELETE_LIST

  local CURREN_TIMESTAMP
  local SEVEN_DAYS_AGO
  local DIR_LIST
  local DIR_CAN_DELETE_NAME
  local DIR_TIMESTAMP

  BASIC_DIR=$1
  DIR_CAN_DELETE_LIST=()
  CURREN_TIMESTAMP=$(date +%s)
  SEVEN_DAYS_AGO=$((CURREN_TIMESTAMP - 7*24*60*60))

  if [ ! -d "${BASIC_DIR}" ]; then
    echo_error_basic "Directory ${BASIC_DIR} does not exist."
    # echo_error_logs "$0" "查找需要删除的目录，${BASIC_DIR}不存在"
    exit 1
  fi

  for DIR_LIST in "${BASIC_DIR}"/*; do
    if [ -d "${DIR_LIST}" ]; then
      # 获取目录名
      DIR_CAN_DELETE_NAME=$(basename "${DIR_LIST}")

      # 检查目录是否为 14 位数字
      if [[ "${DIR_CAN_DELETE_NAME}" =~ ^[0-9]{14}$ ]]; then
        # 将目录名转换为时间戳
        DIR_TIMESTAMP=$(date -d "${DIR_CAN_DELETE_NAME:0:8} ${DIR_CAN_DELETE_NAME:8:2}:${DIR_CAN_DELETE_NAME:10:2}:${DIR_CAN_DELETE_NAME:12:2}" +%s)

        # 判断时间戳
        if [ "${DIR_TIMESTAMP}" -lt "${SEVEN_DAYS_AGO}" ]; then
          echo_info "${DIR_CAN_DELETE_NAME} 将会被删除"
          DIR_CAN_DELETE_LIST+=("${DIR_CAN_DELETE_NAME}")
        fi
      fi
    fi
  done

  if [ ${#DIR_CAN_DELETE_LIST[@]} -eq 0 ]; then
    echo_info "No directories older than 7 days found."
    exit 0
  fi
}

function 2_confirm() {
  local CONFIRMATION

  if [ "$1" == "yes|y" ]; then
    CONFIRMATION="y"
  else
    read -rp "Do you want to delete these directories? (y/n): " CONFIRMATION
  fi


  if [ "${CONFIRMATION}" == "y" ]; then
    for DIR_CAN_DELETE_NAME in "${DIR_CAN_DELETE_LIST[@]}"; do
      echo_alert "Deleting directory: ${DIR_CAN_DELETE_NAME}"
      rm -rf "${BASIC_DIR:?}/${DIR_CAN_DELETE_NAME}"
      echo_info "${DIR_CAN_DELETE_NAME} Deletion complete"
    done
  else
    echo_info "Deletion cancelled"
  fi
}

function clean_old_dir_test() {
  :
}

function clean_old_dir_main() {
  judge_dir_can_delete "$1"
  2_confirm "$2"
}

# clean_old_dir_test "$@"
clean_old_dir_main "$@"
