---
title: springboot远程debug
date: 2018-06-03 06:02:31
tags: [springboot,debug]
---
所谓的远程调试就是服务端程序运行在一台远程服务器上，我们可以在本地服务端的代码（前提是本地的代码必须和远程服务器运行的代码一致）中设置断点，每当有请求到远程服务器时时能够在本地知道远程服务端的此时的内部状态。下面介绍一下Intellij IDEA下对Springboot类型的项目的远程调试功能。
<!-- more -->

## IDEA配置
首先，打开Edit configurations，点击+号，创建一个RemoteDebug应用。经过以下配置，就可以获得启动远程服务器的参数。

IDEA配置:

![IDEA配置](/assets/images/java/springboot远程debug-001.png)

## 远程服务器启动java应用
```
java -jar -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005 .\springboot-watermis-0.0.1-SNAPSHOT.jar
Listening for transport dt_socket at address: 5005
```

运行后可以看到在监听5005端口：

![远程服务器监听端口](/assets/images/java/springboot远程debug-003.png)

这样服务端就监听在5005端口了。可以通过以下命令来检查是否监听成功：
```
netstat -anp | grep 5005          # linux系统
netstat -ano | findstr 5005       # windows系统
```

## IDEA中启动刚才配置的RemoteDebug服务
在启动时候我们会发现此项启动程序只有debug启动模式。

启动RemoteDebug:

![启动RemoteDebug](/assets/images/java/springboot远程debug-002.png)

启动完成，对需要debug的代码打上断点，剩下的操作步骤就是访问远程服务器对应的业务请求，本地就会同步debug。其余的操作与本地debug相同。

图1:

![本地调试](/assets/images/java/springboot远程debug-004.png)

图2：

![本地调试](/assets/images/java/springboot远程debug-005.png)

