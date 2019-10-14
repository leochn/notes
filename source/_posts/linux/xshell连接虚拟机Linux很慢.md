---
title: xshell连接虚拟机Linux很慢
date: 2019-06-17 08:42:31
tags: linux
---
## xshell连接虚拟机Linux很慢

今天发现用xshell 去连接虚拟机Linux 特别的慢，查了资料发现ssh的服务端在连接时会自动检测dns环境是否一致导致的。
<!-- more -->

## 解决办法
```
去掉DNS检测的环节
使用命令：vim /etc/ssh/sshd_config
 打开下面的注释,并把yes改为no
# UseNDS yes -----> UseNDS no

修改完毕后，使用命令：service sshd restart（systemctl restart sshd）
再用xshell连虚拟机，会比以前快很多。
```