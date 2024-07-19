# 新建 lvm 虚拟磁盘

```bash
# 查看多余磁盘
lsblk

# 使用 fdisk 初始化磁盘
fdisk /dev/vdb

# 按下
n
<enter>
<enter>
<enter>

t
8e

w

# 创建 pv
pvcreate /dev/vdb1

# 添加到 vg 里面
# 查看组名
vgdisplay

vgextend klas /dev/vdb1

# 新建虚拟磁盘
lvcreate -n data -l +100%FREE klas

# 初始化磁盘
mkfs.xfs /dev/mapper/klas-data
# or
mkfs.ext4 /dev/mapper/klas-data

# 挂载目录
mount /dev/mapper/klas-data /data

# 修改 fstab
vim /etc/fstab
```

# 扩大 lvm 磁盘空间

```bash
pvcreate /dev/vdb

vgextend klas /dev/vdb

lvextend -l +100%FREE /dev/mapper/klas-data

# 调节文件系统
xfs_growfs /dev/mapper/klas-data
# or
resize2fs /dev/mapper/klas-data
```
