---
title: windows下强制杀死进程
date: 2018-11-30 15:45:05
tags: windows
---
## windows下强制杀死进程
```
window下当使用某个端口时，发现这个端口被占用，但是正规的关闭这个进程又关闭不了，可以使用强制杀死。
```

<!-- more -->

比如想查看8088端口被哪个进程占用了，cmd下输入这个命令：netstat   -ano|findstr 8088

如下图:

![windows](/assets/images/tools/windows-001.png)


找到这个端口的占用PID后，就可以杀死这个进程，用下面的命令：

查找哪个程序的进程PID是13828:

tasklist | findstr 13828

杀死PID进程:

taskkill /pid 13828 -t -f

![windows](/assets/images/tools/windows-002.png)
