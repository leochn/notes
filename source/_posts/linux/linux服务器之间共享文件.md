---
title: linux服务器之间共享文件
date: 2017-11-20 19:57:50
tags: [linux,nfs]
---
目前的项目开发过程中都是采用分布式，在上传文件的时候，文件不一定会在同一台机器中，因此就需要跨机器共享文件，在这里就简单的采用nfs实现跨机器的文件共享。
<!-- more -->
https://www.cnblogs.com/jager/p/6066719.html
1、安装nfs和rpcbind（在centOS6之前是portmap）
    检查自己的电脑是否已经默认安装了nfs和rpcbind：
```
[root@leo-node1 ~]# rpm -aq | grep nfs
libnfsidmap-0.25-17.el7.x86_64
nfs-utils-1.3.0-0.48.el7_4.x86_64
[root@leo-node1 ~]# rpm -aq | grep rpcbind
rpcbind-0.2.0-42.el7.x86_64
[root@leo-node1 ~]#
```

这表示系统已经默认安装。如果没有安装也没事，可以采用下面的命令安装
```
[root@leo-node1 ~]# yum install nfs-utils rpcbind
```

2.需要共享文件的服务器,启动nfs服务
```
[root@leo-node1 ~]# systemctl status nfs
● nfs-server.service - NFS Server
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
   Active: active (exited) since Mon 2017-11-20 17:34:36 CST; 1min 19s ago
  Process: 48608 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS $RPCNFSDCOUNT (code=exited, status=0/SUCCESS)
  Process: 48604 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
  Process: 48602 ExecStartPre=/usr/libexec/nfs-utils/scripts/nfs-server.preconfig (code=exited, status=0/SUCCESS)
 Main PID: 48608 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/nfs-server.service

Nov 20 17:34:36 leo-node1.novalocal systemd[1]: Starting NFS Server...
Nov 20 17:34:36 leo-node1.novalocal systemd[1]: Started NFS Server.
[root@leo-node1 ~]#
```
3.需要共享文件的服务器,在 /etc/exports文件中配置如下:
```
[root@leo-node1 ~]# cat /etc/exports
/fileslocation 10.0.0.111(rw,sync)    
[root@leo-node1 ~]#
```
其中
/fileslocation：表示的是服务器需要共享的目录
10.0.0.111：表示共享给哪台服务器ip
(rw)：表示10.0.0.111对共享的文件具有读写权限
ro:读访问
sync:所有数据在请求时写入共享

4.查看nfs服务器信息
```
[root@leo-node1 ~]# showmount -e 10.0.0.10
Export list for 10.0.0.10:
/fileslocation 10.0.0.111
[root@leo-node1 ~]# 
```

5.在需要用共享数据的服务器(客户端)
共享盘挂载到客户端(10.0.0.111)
```
[root@leo-node2 /]# mkdir filelocation
[root@leo-node2 /]# mount -t nfs 10.0.0.10:/fileslocation  /fileslocation
[root@leo-node2 /]# mount -a
[root@leo-node2 /]# cd /fileslocation/
```

6.查看共享效果(10.0.0.111)
```
[root@leo-node2 /]# cd fileslocation/
[root@leo-node2 fileslocation]# ll
total 0
drwxr-xr-x 3 root root 19 Nov 21 09:15 upload
[root@leo-node2 fileslocation]# 
```