#!/bin/bash

LAST_POSITION_FILE='/tmp/.posFile'
SEVERNAME="$1"
LOGFILE="$2"
exclu_words='/szdApp/queryRegistrationTrans|xzhf.ybj.suzhou.com.cn:19003/mi/mi-business/app/getToken|If you are the system administrator of this resource then you should check|Internal Server Error\?+'

function getErrorMessage()
{
    CUR_POS=$(wc -l ${LOGFILE}|awk '{print $1}')
    LAST_POS=$(cat ${LAST_POSITION_FILE}/$SEVERNAME)


    # 如果当前行小于上一次文件行号，文件已轮转（不一定，出现删除也会）
    if [ $CUR_POS -lt ${LAST_POS} ];then
        LAST_POS=0
    else
        # 读取区间为左开右闭
        let LAST_POS++
    fi

    # 从上次位置开始打印至当前行
    out_cach=$(awk -v start_pos="$LAST_POS" -v end_pos="$CUR_POS" 'NR >= start_pos && NR <= end_pos {print $0}' ${LOGFILE})
    # 输出保存当前行号
    echo "${CUR_POS}" > ${LAST_POSITION_FILE}/$SEVERNAME

    is_harvest=1
    all_error_msg=""
    block_msg=""
    IFS=$'\n'

    for line in $out_cach
    do
        line_num=$(echo $line | awk '{print $1}')
        line_content=$(echo $line | awk '{$1=""; print $0}')

        # 匹配错误日志开头，开启采集
        if [ $is_harvest -eq 1 ];then
            if [ "$(echo $line_content | egrep '^【ERROR】'| wc -l)" -eq 1 ];then
                if [ "$(echo $line_content | egrep "$exclu_words"|wc -l)" -eq 0 ];then
                    is_harvest=0
                    # 往前追溯 5 - 10 行
                    start_trace_back=$((line_num > 10 ? line_num - 10 : 1))
                    end_trace_back=$((line_num - 5))
                    trace_back_lines=$(awk -v start="$start_trace_back" -v end="$end_trace_back" 'NR >= start && NR <= end {print $0}' ${LOGFILE})
                    block_msg+="$trace_back_lines"$'\n'
                    block_msg+="$line_content"$'\n'
                fi
            fi
        # 匹配错误日志结尾_1，关闭采集
        elif [ "$(echo $line_content | egrep '^【DEBUG】|^【INFO】|^【WARN】' | wc -l)" -eq 1 ];then
            all_error_msg+="$block_msg"
            block_msg=""
            is_harvest=1
        # 匹配错误日志结尾_2，不关闭采集
        elif [ "$(echo $line_content | egrep '^【ERROR】'| wc -l)" -eq 1 ];then
            all_error_msg+="$block_msg"
            block_msg=""
            if [ "$(echo $line_content | egrep "$exclu_words"|wc -l)" -eq 0 ];then
                block_msg+="$line_content"$'\n'
            else
                is_harvest=1
            fi
        # 匹配错误日志体
        elif [ "$(echo $line_content | egrep "$exclu_words"|wc -l)" -eq 0 ];then
            block_msg+="$line_content"$'\n'
        else
            is_harvest=1
            block_msg=""
        fi
    done

    if [ ! -z "$block_msg" ];then
        all_error_msg+=$block_msg
    fi

    [[ ! -z $all_error_msg ]] && echo "$all_error_msg"
}



# 判断位置文件是否存在
if [ ! -f $LAST_POSITION_FILE/$SEVERNAME ]  || [ ! -s $LAST_POSITION_FILE/$SEVERNAME ];then
    echo 0 > $LAST_POSITION_FILE/$SEVERNAME
fi

# 判断日志文件是否存在
if [ ! -e ${LOGFILE} ];then
    echo "${LOGFILE} 不存在，请联系管理员"
    exit 127
fi

# 执行函数
getErrorMessage
