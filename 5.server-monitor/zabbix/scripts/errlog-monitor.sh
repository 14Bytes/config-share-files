#!/bin/bash
#
# 检查 Java 或 Php 日志中的 error 错误

# Globals:
# Arguments:
#  None

LAST_POSITION_FILE='/tmp/.posFile'
SERVERNAME="$1"
LOGFILE="$2"

function getErrorMessage {
  local CUR_POS
  local LAST_POS

  local out_cache
  local harvest_is
  local error_message

  CUR_POS=$(wc -l "${LOGFILE}"|awk '{print $1}')
  LAST_POS=$(cat ${LAST_POSITION_FILE}/"${SERVERNAME}")

  echo "CUR_POS = ${CUR_POS} & LAST_POS = ${LAST_POS}"

  if (( "${LAST_POS}" == 0 ));then
    LAST_POS=1
  fi

  # 如果当前行小于上一次文件行号，文件已轮转（不一定，出现删除也会）
  if (( "${CUR_POS}" <= "${LAST_POS}" ));then
    LAST_POS=1
  else
    # 读取区间为左开又闭
    (( LAST_POS++ ))
  fi

  # 从上次位置开始打印至最后一行
  out_cache=$(awk -v start_pos="$LAST_POS" -v end_pos="$CUR_POS" 'NR >= start_pos && NR <= end_pos {print $0}' "${LOGFILE}")

  # 输出保存当前行号
  echo "${CUR_POS}" > ${LAST_POSITION_FILE}/"${SERVERNAME}"

  harvest_is=1
  error_message=""

  IFS=$'\n'
  for line in $out_cache
  do
    if [  $harvest_is -eq 1 ];then
      # 匹配开始头
      if [ $(echo "${line}" | grep -E '^.ERROR'| wc -l) -eq 1 ];then
        harvest_is=0
      else
        continue
      fi
    else
      # 匹配结尾
      if [ $(echo $line |egrep  '^【DEBUG】|^【INFO】|^【WARN】' | wc -l) -eq 1 ];then
        harvest_is=1
        continue
      fi
    fi
    error_message+="$line"$'\n'
  done

  if [ -n "$error_message" ];then
    echo "$error_message"
  fi
}

# 判断位置文件是否存在
if [ ! -f $LAST_POSITION_FILE/$SEVERNAME ]  || [ ! -s $LAST_POSITION_FILE/$SEVERNAME ];then
  echo 1 > $LAST_POSITION_FILE/$SEVERNAME
fi

# 判断日志文件时候存在
if [ ! -e "${LOGFILE}" ];then
  echo "${LOGFILE} 不存在，请联系管理员"
  exit 1
fi


function main() {
  getErrorMessage
}

main "$@"
