# Linux 路由配置

## 网络拓扑

有两个子网段，分别是路由器 1 组成了网段 0，路由器 2 从路由器 1 中分成了网段 2

要在不同网段直接通信，需要添加路由，添加路由的命令如下：

```bash
route [add|del] [-net|-host] target [netmask Nm] [gw GW] [[dev] If]
```

- `add`: 添加一条路由规则
- `del`: 删除一条路由规则
- `-net`: 目的地址是一个网络
- `-host`: 目的地址是一个主机
- `target`: 目的地址
- `netmask`: 目的地址的网络掩码
- `gw`: 路由数据包通过的网关
- `dev`: 为路由添加指定的网络接口

## 添加主机路由

主机 192.168.2.10 主机与 192.168.0.10 的主机，需要经过路由器 2：192.168.2.1，在主机 192.168.2.10 上添加到 192.168.0.10 的路由

```bash
route add -host 192.168.0.10 gw 192.168.2.1 dev eth0
```

执行完成后使用`route`进行查看

```bash
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 ens192
10.1.0.0        0.0.0.0         255.255.255.0   U     100    0        0 ens192
```

- `Destination`: 目标网络或目标主机，为`default`时，表示这个是默认网关，所有的数据都发到这个网关
- `Gateway`: 网关地址，0.0.0.0 表示当前记录对应的`Destination`跟本机在同一个网段，通信时不需要经过网关
- `Genmask`: `Destination`字段的网络掩码，`Destination`是主机时设置为 255.255.255.255，是默认路由时设置为 0.0.0.0
- `Flags`: 标志
  - `U`: Up 表示有效
  - `G`: Gateway 表示连接路由，如果没有表示直连目的地址
  - `H`: Host 表示目标是具体主机，而不是网段
  - `R`: 恢复动态路由产生的表项
  - `D`: 由路由的后台程序动态的安装
  - `M`: 由路由的后台程序修改
  - `!`: 拒绝路由
- `Metric`: 路由距离，到达指定网络所需的中转数，是大型局域网和广域网设置所必须的（不在 Linux 内核中使用）
- `Ref`: 路由项引用次数（不在 Linux 内核中使用）
- `Use`: 此路由项被路由软件查找的次数
- `Iface`: 网卡名称

所使用的命令信息是访问主机 192.168.0.10 的信息都从 192.168.2.1 网关转发

删除路由命令：

```bash
route del 192.168.0.10
```

## 添加网络路由

如果 192.168.2.10 要访问网段 0 的所有主机的话，需要在主机 192.168.0.10 主机上添加一条到网段 0 的网络路由

```bash
route add -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.2.1 dev eth0
```

删除

```bash
route del -net 192.168.0.0/24 gw 192.168.2.1
```

## 添加默认路由

如果网段 2 的主机想访问其他所有网段的主机，只需要添加默认路由即可：

```bash
route add default gw 192.168.2.1 dev eth0
```

删除路由

```bash
route del default
```