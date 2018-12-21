---
title: jar在windows环境设置为开机自启动
date: 2018-12-17 14:10:10
tags: [java,tool]
---

## jar包在windows环境设置为开机自启动
在生产环境中，会遇到服务器重启的问题，要保证java程序能实现开机自启动
<!-- more -->

## 配置过程
### 创建bat文件

![bat开机自启](/assets/images/java/jar开机自启001.png)

创建.bat 文件

```
java -jar D:\startup\simulation-1.0-SNAPSHOT.jar --server.port=9091  --spring.profiles.active=dev > D:\startup\simulation.log
```

### bat文件放至Startup下
把simulation.bat文件放入C:\Users\root\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup目录 下，如下图所示：其中AppData为隐藏目录，就能够开机时自动执行脚本里的内容了

![bat开机自启](/assets/images/java/jar开机自启002.png)