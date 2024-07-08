#! /bin/bash -e 

# 获取CPU使用情况函数(返回值为百分比数值)
function GetCpuMetrics() {
    # 使用"sar -u"命令获取CPU空闲均值
    local CPU_IDLE
    CPU_IDLE=$(sar -u |tail -1 |awk '{print $NF}')
    # 计算计算CPU使用百分比，使用printf在小数点前补0
    local CPU_USE
    CPU_USE=$(printf "%.2f" $(echo "100-${CPU_IDLE}" |bc))

    # 输出结果
    echo "${CPU_USE}"
}

# 获取内存使用情况函数(返回值为百分比数值)
function GetMemoryMetrics() {
    # 使用free -h命令获取内存使用情况
    local MEM_GET
    MEM_GET=($(free |grep Mem |awk '{print $2,$NF}'))
    # 计算内存使用率(1-available/total)
    local MEM_DECI
    MEM_DECI=$(echo "scale=4;1-${MEM_GET[1]}/${MEM_GET[0]}" |bc)
    # 转换为百分比
    local MEM_PERC
    MEM_PERC=$(echo "scale=2;${MEM_DECI}*100" |bc)

    # 输出结果
    echo "${MEM_PERC%00}"
}

# 获取DISK使用情况函数(返回值为"磁盘名,百分比")
function GetDiskMetrics() {
    # 使用lsblk命令获取当前服务器磁盘目录
    for disk in $(lsblk |grep / |awk '{print $NF}' |uniq)
    do
        # 使用df命令获取磁盘使用情况
        echo "$disk,$(df |grep $disk$ |awk '{print $(NF-1)}')"
    done
}

# 使用zabbix_get命令获取zabbix监控指标
function GetMetricsZabbix() {
    # 获取并输出CPU指标
    printf "%.2f\n" $(/usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k "system.cpu.util")

    # 获取并输出内存指标
    printf "%.2f\n" $(echo "100-`/usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k "vm.memory.size[pavailable]"`" |bc)

    # 获取并输出DISK指标
    for disk in $(lsblk |grep / |awk '{print $NF}' |uniq)
    do   
        printf "$disk,%.2f\n" $(/usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k "vfs.fs.size[$disk,pused]")
    done
}


# 主函数
function main() {
    # 打印CPU及内存信息

    
    echo "- **基础项**"
    echo -e "  - [x] CPU：$(GetCpuMetrics)%"
    echo -e "  - [x] 内存(1-available/total)：$(GetMemoryMetrics)%"

    # 打印磁盘信息
    for disk_result in $(GetDiskMetrics)
    do
        echo -e "  - [x] 硬盘(${disk_result%,*})：${disk_result#*,}"
    done

    # 调用GetMetricsZabbix函数获取指标并赋值给数组,数组前两个值为CPU及内存指标，其他值为磁盘指标
    METRICS_ZABBIX=($(GetMetricsZabbix))

    # 打印Zabbix监控指标
    echo "- **Zabbix监控**"
    echo "  - [x] 网卡"
    echo "  - [x] CPU：${METRICS_ZABBIX[0]}%"
    echo "  - [x] 内存：${METRICS_ZABBIX[1]}%"
    for ((i=2; i<${#METRICS_ZABBIX[*]}; i++))
    do
        echo "  - [x] 硬盘(${METRICS_ZABBIX[$i]%,*})：${METRICS_ZABBIX[$i]#*,}%"
    done
}

main "$@"
