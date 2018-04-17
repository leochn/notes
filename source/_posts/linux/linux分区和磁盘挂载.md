---
title: linux分区和磁盘挂载
date: 2018-04-11 22:01:01
tags: linux
---
## 分区的方式
### mbr分区
1.最多支持四个主分区
2.系统只能安装在主分区
3.扩展分区要占一个主分区
4.MBR最大只支持2TB，但拥有最好的兼容性
### gtp分区
1.支持无限多个主分区(但操作系统可能限制,比如windows下最多128个分区)
2.最大执行18EB的大容量(1EB=1024PB,1PB=1024TB)
3.windows4 64位以后支持gtp
<!-- more -->

## linux分区
linux来说无论有几个分区，分给哪个目录使用，它归根结底就只是一个根目录，一个独立且唯一的文件结构，linux中每个分区都是用来组成整个文件系统的一部分。

linux采用了一种叫"载入"的处理方式，它的整个文件系统中包含了一整套的文件和目录。且将一个分区和一个目录联系起来。这时要载入的一个分区将使它的存储空间在一个目录下获得。

## 磁盘说明
linux分区不同于windows，linux下硬盘设备名为（IDE硬盘为hdx（x为从a—d）因为IDE硬盘最多四个，SCSI，SATA，USB硬盘为sdx（x为a—z）），硬盘主分区最多为4个，不用说大家也知道…..所以主分区从sdb1开始到sdb4，逻辑分区从sdb5开始，（逻辑分区永远从sdb5开始…）设备名可以使用fdisk –l查看。

### 使用lsblk指令查看当前系统的分区情况
```bash
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]# lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda            8:0    0   20G  0 disk 
├─sda1         8:1    0    1G  0 part /boot
└─sda2         8:2    0   19G  0 part 
  ├─cl_-root 253:0    0   17G  0 lvm  /
  └─cl_-swap 253:1    0    2G  0 lvm  [SWAP]
sr0           11:0    1  680M  0 rom  
[root@localhost ~]#
```

![linux分区和磁盘挂载](/assets/images/linux/01-linux分区和磁盘挂载001.jpg)

## 磁盘挂载案例
需求：给linux系统增加一个新的硬盘，并且挂载到 /home/newdisk

### 如何增加一块硬盘
    1.虚拟机添加硬盘
    2.分区 fdisk /dev/sdb
    3.格式化 mkfs -t ext4 /dev/sdb1
    4.挂载  先创建一个 /home/newdisk
    5.设置可以自动挂载(永久挂载，当重启系统，仍然可以挂载到 /home/newdisk )
       vim /etc/fstab
       输入如下信息：
       /dev/sdb1   /home/newdisk  ext4  defaults  0 0
       或者输入如下信息(xxxxxxxxx用真实的UUID替换)：
       UUID=xxxxxxxxx   /home/newdisk  ext4  defaults  0 0

### 虚拟机增加一块硬盘具体步骤
#### 步骤1,查看原来虚拟机的磁盘情况
```
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]#
```

#### 步骤2,给虚拟机分配硬盘

![linux分区和磁盘挂载](/assets/images/linux/01-linux分区和磁盘挂载002.jpg)

![linux分区和磁盘挂载](/assets/images/linux/01-linux分区和磁盘挂载003.jpg)

![linux分区和磁盘挂载](/assets/images/linux/01-linux分区和磁盘挂载004.jpg)

##### 增加硬盘后，查看并没有看到新加的硬盘

```bash
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]#
```

##### reboot之后再次查看,发现多了sdb盘
```bash
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sdb                                                                             
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]#
```

#### 步骤3,分区

    1.分区命令 fdisk /dev/sdb
    2.开始对 /sdb 分区
        *m  显示命令列表
        *p  显示磁盘分区 同fdisk -l
        *n  新增分区
        *d  删除分区
        *w  写入并退出
    说明:开始分区后输入n，新增分区，然后选择p，分区类型为主分区，两次回车默认剩余全部空间。最后输入w写入分区并退出。

##### 具体步骤

```
[root@localhost ~]# fdisk /dev/sdb
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

Device does not contain a recognized partition table
使用磁盘标识符 0x2fac99ca 创建新的 DOS 磁盘标签。

命令(输入 m 获取帮助)：m
命令操作
   a   toggle a bootable flag
   b   edit bsd disklabel
   c   toggle the dos compatibility flag
   d   delete a partition
   g   create a new empty GPT partition table
   G   create an IRIX (SGI) partition table
   l   list known partition types
   m   print this menu
   n   add a new partition
   o   create a new empty DOS partition table
   p   print the partition table
   q   quit without saving changes
   s   create a new empty Sun disklabel
   t   change a partition's system id
   u   change display/entry units
   v   verify the partition table
   w   write table to disk and exit
   x   extra functionality (experts only)

命令(输入 m 获取帮助)：n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
分区号 (1-4，默认 1)：1
起始 扇区 (2048-4194303，默认为 2048)：2048
Last 扇区, +扇区 or +size{K,M,G} (2048-4194303，默认为 4194303)：4194303
分区 1 已设置为 Linux 类型，大小设为 2 GiB

命令(输入 m 获取帮助)：w
The partition table has been altered!

Calling ioctl() to re-read partition table.
正在同步磁盘。
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sdb                                                                             
└─sdb1                                                                          
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]#
```

发现sdb1没有UUID号，也没有文件类型，因为现在只是分区，还没有格式化

#### 步骤4,格式化磁盘
    分区命令：mkfs -l ext4 /dev/sdb1
    其中 ext4 是分区类型

```
[root@localhost ~]# mkfs -t ext4 /dev/sdb1
mke2fs 1.42.9 (28-Dec-2013)
文件系统标签=
OS type: Linux
块大小=4096 (log=2)
分块大小=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072 inodes, 524032 blocks
26201 blocks (5.00%) reserved for the super user
第一个数据块=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
    32768, 98304, 163840, 229376, 294912

Allocating group tables: 完成                            
正在写入inode表: 完成                            
Creating journal (8192 blocks): 完成
Writing superblocks and filesystem accounting information: 完成 

[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sdb                                                                             
└─sdb1       ext4                        06ea6d83-392e-4a5e-9798-87306d5acfac   
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]#
```

#### 步骤5,挂载
    挂载：将一个分区与一个目录联系起来
    先创建一个文件 mkdir /home/newdisk
    *mount 设备名称  挂载目录
     例如： mount /dev/sdb1  /newdisk

     *umount 设备名称 或者 挂载目录
     例如： umount /dev/sdb1    或者： umount /newdisk

```
[root@localhost ~]# mkdir /home/newdisk
[root@localhost ~]# cd /home/
[root@localhost home]# ll
总用量 4
drwx------. 2 docker docker 62 7月   8 2017 docker
-rwxr--r--  1 root   root   24 4月  12 06:59 mytask1.sh
drwxr-xr-x  2 root   root    6 4月  12 20:31 newdisk
[root@localhost home]# mount /dev/sdb1 /home/newdisk
[root@localhost home]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sdb                                                                             
└─sdb1       ext4                        06ea6d83-392e-4a5e-9798-87306d5acfac   /home/newdisk
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost home]# cd newdisk/
[root@localhost newdisk]# ll
总用量 16
drwx------ 2 root root 16384 4月  12 20:23 lost+found
[root@localhost newdisk]#
```

#### 步骤6,永久挂载
    第5步骤完成后，只是临时挂载，系统重启后，设备和文件之间的挂载挂载关系就会没有。
    永久挂载：通过修改 /etc/fstab 实现挂载
    /dev/sdb1               /home/newdisk           ext4    defaults        0 0
    设置挂载自动生效： mount -a

```
[root@localhost newdisk]# cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Mon May  1 15:26:44 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/cl_-root    /                       xfs     defaults        0 0
UUID=45f575e1-ef6b-4e63-95f9-c7b6ca719506 /boot                   xfs     defaults        0 0
/dev/mapper/cl_-swap    swap                    swap    defaults        0 0
[root@localhost newdisk]# vim /etc/fstab 
[root@localhost newdisk]# vim /etc/fstab 
[root@localhost newdisk]# cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Mon May  1 15:26:44 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/cl_-root    /                       xfs     defaults        0 0
UUID=45f575e1-ef6b-4e63-95f9-c7b6ca719506 /boot                   xfs     defaults        0 0
/dev/mapper/cl_-swap    swap                    swap    defaults        0 0
/dev/sdb1               /home/newdisk           ext4    defaults        0 0
[root@localhost newdisk]# mount -a
```

## 磁盘情况查询
### 查询系统整体磁盘使用情况
    基本语法： df -h
    umount /home/newdisk/  umount之后,发现就少了一块硬盘

```
[root@localhost ~]# df -h
文件系统              容量  已用  可用 已用% 挂载点
/dev/mapper/cl_-root   17G  7.9G  9.2G   47% /
devtmpfs              901M     0  901M    0% /dev
tmpfs                 912M  4.0K  912M    1% /dev/shm
tmpfs                 912M  8.6M  904M    1% /run
tmpfs                 912M     0  912M    0% /sys/fs/cgroup
/dev/sdb1             2.0G  6.0M  1.9G    1% /home/newdisk
/dev/sda1            1014M  231M  784M   23% /boot
tmpfs                 183M     0  183M    0% /run/user/0
[root@localhost ~]# umount /home/newdisk/
[root@localhost ~]# df -h
文件系统              容量  已用  可用 已用% 挂载点
/dev/mapper/cl_-root   17G  7.9G  9.2G   47% /
devtmpfs              901M     0  901M    0% /dev
tmpfs                 912M  4.0K  912M    1% /dev/shm
tmpfs                 912M  8.6M  904M    1% /run
tmpfs                 912M     0  912M    0% /sys/fs/cgroup
/dev/sda1            1014M  231M  784M   23% /boot
tmpfs                 183M     0  183M    0% /run/user/0
[root@localhost ~]# lsblk -f
NAME         FSTYPE      LABEL           UUID                                   MOUNTPOINT
sda                                                                             
├─sda1       xfs                         45f575e1-ef6b-4e63-95f9-c7b6ca719506   /boot
└─sda2       LVM2_member                 QSZDEe-KD6Z-1WMP-BxU1-btWb-1iuW-DqAVzT 
  ├─cl_-root xfs                         f24bed68-170a-4e85-a90c-6a716804d883   /
  └─cl_-swap swap                        014c378d-21eb-4512-a12a-6b381c7e1d0a   [SWAP]
sdb                                                                             
└─sdb1       ext4                        06ea6d83-392e-4a5e-9798-87306d5acfac   
sr0          iso9660     CentOS 7 x86_64 2016-12-05-23-44-06-00                 
[root@localhost ~]# 
```

### 查询指定目录的磁盘占用情况
    基本语法： du -h /目录
    -s 指定目录占用大小汇总
    -h 带计量单位
    -a 含文件
    -- max-depth=1 子目录深度
    -c 列出明细的同时，增加汇总值

查询 /opt 目录的磁盘占用情况,深度为1
```
[root@localhost ~]# du -ach --max-depth=1 /opt
50M /opt/tomcats
1.3G    /opt/gitlab
1.4G    /opt
1.4G    总用量
[root@localhost ~]#
```

### 磁盘占用情况,常用指令
    统计/home 文件夹下文件的个数
    ls -l /home | grep "^-" | wc -l
    统计/home 文件夹下目录的个数
    ls -l /home | grep "^d" | wc -l
    统计/home 文件夹下文件的个数,包括子文件夹里面的
    ls -lR /home | grep "^-" | wc -l
    统计/home 文件夹下目录的个数,包括子文件夹里面的
    ls -lR /home | grep "^d" | wc -l

```
[root@localhost ~]# cd /home/
[root@localhost home]# ll
总用量 8
drwx------. 2 docker docker   62 7月   8 2017 docker
-rwxr--r--  1 root   root     24 4月  12 06:59 mytask1.sh
drwxr-xr-x  3 root   root   4096 4月  12 20:23 newdisk
[root@localhost home]# cd docker/
[root@localhost docker]# ll
总用量 0
[root@localhost docker]# cd ..
[root@localhost home]# cd newdisk/
[root@localhost newdisk]# ll
总用量 16
drwx------ 2 root root 16384 4月  12 20:23 lost+found
[root@localhost newdisk]# cd lost+found/
[root@localhost lost+found]# ll
总用量 0

[root@localhost home]# ls -l /home | grep "^-" | wc -l
1
[root@localhost home]# ls -l /home | grep "^d" | wc -l
2
[root@localhost home]# ls -lR /home | grep "^-" | wc -l
1
[root@localhost home]# ls -lR /home | grep "^d" | wc -l
3
[root@localhost home]# yum install tree
[root@localhost home]# tree
.
├── docker
├── mytask1.sh
└── newdisk
    └── lost+found

3 directories, 1 file
[root@localhost home]#
```


