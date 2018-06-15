---
title: linux磁盘挂载
date: 2018-06-14 09:46:30
tags: linux
---
## linux磁盘挂载
<!-- more -->

### 查看磁盘情况
fdisk -l 查看磁盘情况

```
[root@localhost ~]# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
vda                                                      
└─vda1 ext4         eb448abb-3012-4d8d-bcde-94434d586a31 /
vdb                                                      
[root@localhost ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        99G  1.7G   92G   2% /
devtmpfs        3.9G     0  3.9G   0% /dev
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           3.9G  340K  3.9G   1% /run
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
tmpfs           783M     0  783M   0% /run/user/0
[root@localhost ~]# fdisk -l   ### 查看硬盘信息

Disk /dev/vda: 107.4 GB, 107374182400 bytes, 209715200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0008d73a

   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048   209713151   104855552   83  Linux

Disk /dev/vdb: 429.5 GB, 429496729600 bytes, 838860800 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

[root@localhost ~]#
```

## 磁盘分区
```
[root@localhost ~]# fdisk /dev/vdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x15e80f17.

Command (m for help): m  ## m 获取帮助
Command action
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

Command (m for help): n   ## n 创建分区
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p    ## p 表示主分区
Partition number (1-4, default 1): 1
First sector (2048-838860799, default 2048):   ## 这里直接敲回车
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-838860799, default 838860799):   ## 这里直接敲回车
Using default value 838860799
Partition 1 of type Linux and of size 400 GiB is set

Command (m for help): w  ## w 退出并保存
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@localhost ~]#
```

### 查看磁盘情况
发现 vdb1 没有UUID号,也没有文件类型,因为现在只是分区,还没有格式化

```
[root@localhost ~]# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
vda                                                      
└─vda1 ext4         eb448abb-3012-4d8d-bcde-94434d586a31 /
vdb                                                      
└─vdb1                                                   
[root@localhost ~]
```

### 格式化磁盘
将 vdb 分区格式化为ext4格式

```
[root@localhost ~]# mkfs -t ext4 /dev/vdb
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
26214400 inodes, 104857600 blocks
5242880 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2252341248
3200 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
    4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
    102400000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done     

[root@localhost ~]#
```

### 新建文件夹
```
[root@localhost /]# mkdir /data
[root@localhost /]# ll
total 64
lrwxrwxrwx.   1 root root     7 Oct 15  2017 bin -> usr/bin
dr-xr-xr-x.   5 root root  4096 Jun 13 15:57 boot
drwxr-xr-x    2 root root  4096 Jun 14 09:16 data
drwxr-xr-x   19 root root  2980 Jun 14 09:15 dev
drwxr-xr-x.  80 root root  4096 Jun 13 15:56 etc
drwxr-xr-x.   2 root root  4096 Nov  5  2016 home
lrwxrwxrwx.   1 root root     7 Oct 15  2017 lib -> usr/lib
lrwxrwxrwx.   1 root root     9 Oct 15  2017 lib64 -> usr/lib64
drwx------.   2 root root 16384 Oct 15  2017 lost+found
drwxr-xr-x.   2 root root  4096 Nov  5  2016 media
drwxr-xr-x.   2 root root  4096 Nov  5  2016 mnt
drwxr-xr-x.   2 root root  4096 Nov  5  2016 opt
dr-xr-xr-x  125 root root     0 Jun 13 15:56 proc
dr-xr-x---.   6 root root  4096 Jun 14 05:34 root
drwxr-xr-x   22 root root   620 Jun 13 15:56 run
lrwxrwxrwx.   1 root root     8 Oct 15  2017 sbin -> usr/sbin
drwxr-xr-x.   2 root root  4096 Nov  5  2016 srv
dr-xr-xr-x   13 root root     0 Jun 13 23:56 sys
drwxrwxrwt.   9 root root  4096 Jun 14 03:30 tmp
drwxr-xr-x.  13 root root  4096 Oct 15  2017 usr
drwxr-xr-x.  19 root root  4096 Oct 15  2017 var
[root@localhost /]#
```

### 挂载
```
[root@localhost /]# mount /dev/vdb /data
[root@localhost /]# lsblk -f
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
vda                                                      
└─vda1 ext4         eb448abb-3012-4d8d-bcde-94434d586a31 /
vdb    ext4         4b85ec0c-240e-4059-98f9-a0899d9ca5d2 /data
[root@localhost /]#
```

### 查看/etc/fstab
```
[root@localhost /]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sun Oct 15 15:19:00 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=eb448abb-3012-4d8d-bcde-94434d586a31 /                       ext4    defaults        1 1

[root@localhost /]#
```

### 永久挂载 mount -a
blkid,查看vdb的UUID,写入fstab UUID 最稳定, /dev/vdb 也可以
```
[root@localhost ~]# blkid
/dev/vda1: UUID="eb448abb-3012-4d8d-bcde-94434d586a31" TYPE="ext4" 
/dev/vdb: UUID="4b85ec0c-240e-4059-98f9-a0899d9ca5d2" TYPE="ext4" 
[root@localhost /]# echo /dev/vdb /data ext4 defaults 0 0 >> /etc/fstab
[root@localhost /]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sun Oct 15 15:19:00 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=eb448abb-3012-4d8d-bcde-94434d586a31 /                       ext4    defaults        1 1
/dev/vdb /data ext4 defaults 0 0

[root@localhost /]# mount -a
[root@localhost /]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        99G  1.7G   92G   2% /
devtmpfs        3.9G     0  3.9G   0% /dev
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           3.9G  340K  3.9G   1% /run
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
tmpfs           783M     0  783M   0% /run/user/0
/dev/vdb        394G   73M  374G   1% /data
[root@localhost /]#
```
