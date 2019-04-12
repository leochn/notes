---
title: linux下执行shell脚本出现No such file or directory错误
date: 2019-04-12 10:42:16
tags: linux
---

## linux下执行shell脚本出现No such file or directory错误

一些人喜欢用vim来写shell脚本, 有的人喜欢在Windows下用一些方便的编辑器(比如鼎鼎大名的Notepad++)写好， 然后拷贝文件到linux下，结果呢，在执行脚本a.sh的时候，会出现问题
<!-- more -->

### 具体报错信息如下
```
[root@localhost test]# ./test.sh   
-bash: ./test.sh: /bin/sh^M: bad interpreter: No such file or directory 
```

### 出错原因
主要原因是test.sh是我在windows下编辑然后上传到linux系统里执行的。.sh文件的格式为dos格式。而linux只能执行格式为unix格式的脚本。

### 解决办法

我们可以通过vi编辑器来查看文件的format格式。步骤如下：

vim test.sh进入test.sh后， 

在底部模式下， 执行:set fileformat=unix

后执行:x或者:wq保存修改。 

然后就可以执行./test.sh运行脚本了。
