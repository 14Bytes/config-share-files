# Linux 文件系统

## Linux 文件系统

在 Linux 操作系统中，所有被操作系统管理的资源，如网络接口卡、磁盘驱动器、打印机、输入输出设备、普通文件或是目录都被看作一个文件，也就是说在 Linux 中，一切皆文件。

Linux 支持 5 种文件类型：

- 普通文件：用来在辅助存储设备上存储信息和数据
- 目录文件：用于表示和管理系统中的文件，目录文件中包含一些文件名和子目录名
- 链接文件：用于不太目录下文件的共享
- 设备文件：用来访问硬件设备
- 命名管道：是一种特殊类型的文件，Linux 系统下，进程之间通信可以通过该文件完成

## Linux 常见目录说明

- `/bin`：存放二进制可执行文件，常用命令一般在这里
- `/etc`：存放系统管理和配置文件
- `/home`：存放所有用户文件的根目录，是用户主目录的基点
- `/usr`：用于存放系统应用程序
- `/opt`：额外安装的可选应用程序包所放置的位置
- `/proc`：虚拟文件系统目录，是系统内存的映射，可以直接访问这个目录来获取系统信息
- `/root`：超级用户（系统管理员）的主目录
- `/sbin`：存放二进制可执行文件，只有root才能访问，这里存放的是系统管理员使用的系统级别的管理命令和程序
- `/dev`：用于存放设备文件
- `/mnt`：系统管理员安装临时文件系统的安装点，系统提供这个目录是让用户临时挂载其他的文件系统
- `/boot`：存放用于系统引导时使用的各种文件
- `/lib`：存放着和系统运行相关的库文件
- `/tmp`：用于存放各种临时文件，是公用的临时文件存储点
- `/var`：用于存放运行时需要改变数据的文件，也是某些大文件的溢出区，比如说各种服务的日志文件、系统启动日志等
- `/lost+found`：这个目录是空的，系统非正常关机而留下的“无家可归”的文件就在这里，类似于`windows`下的`.chk`文件

## `inode`说明

`inode`是理解`Unix\Linux`文件系统和硬盘存储的基础

了解`inode`需要理解文件存储的过程：

1. 文件存储在硬盘上，硬盘的最小的存储单位叫做`扇区`（Sector），每个扇区存储 512 个字节（相当于 0.5 KB）
2. 操作系统在读取硬盘时，不会一个一个扇区的进行读取，而是会一次性连续读取多个扇区，即一次性读取一个`块`（Block）。这种由多个扇区组成的块，是文件存取的最小单位，“块”的大小，最常见是是 4KB，即连续的八个扇区组成一个块
3. 文件数据都存储在“块”中，所以还需要找到一个地方存储文件的元信息，比如文件的创建者、文件的创建日期、文件的大小等等。这种存储文件元信息的区域就叫做`inode`，中文译名叫做`索引节点`
4. 每一个文件都有对应的`inode`，里面包含了与该文件有关的一些信息

Linux 通过`inode`节点表将文件的逻辑结构和物理结构进行转换的工作过程：

1. `inode`节点是一个 64 字节长的表，表中包含了文件的相关信息，其中有文件的大小，文件的所有者，文件的存取许可方式以及文件的类型等重要信息。在`inode`节点表中最重要的内容是磁盘地址表，在磁盘地址表中有 13 个块号，文件将以块号在磁盘地址中出现的顺序依次读取相应的块。
2. Linux 文件系统通过把`inode`节点和文件名进行连接，当需要读取该文件时，文件系统在当前目录表中查找该文件名对应的项，由此可以得到该文件相对应的`inode`节点号，通过该`inode`节点的磁盘地址表把分散存储的文件物理块连接成文件的逻辑结构。

## 硬链接和软连接区别

- 硬链接：由于 Linux 下文件时通过索引节点（inode）来识别文件，硬链接可以认为是一个指针，指向文件索引节点指针，系统并不为它重新分配inode，每添加一个硬链接，文件的链接数就加一
  - 不足：
    - 不可以在不同文件系统的文件间建立链接
    - 只有超级用户才可以为目录创建硬链接
- 软链接：软连接没有任何文件系统的限制，任何用户可以创建指向目录的符合链接，有强大的灵活性，甚至可以跨越不同机器，不同网络对文件进行链接
  - 不足：
    - 因为链接文件中包含原文件的路径信息，所以当原文件从一个目录下移到其他目录中，再访问链接文件，系统就找不到了，而硬链接就没有缺陷了

总结：

- 硬链接不可以跨区，软链接可以
- 硬链接指向一个 inode，软链接则是创建一个新的 inode 节点
