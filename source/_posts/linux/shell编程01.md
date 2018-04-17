---
title: shell编程01
date: 2018-04-15 14:53:32
tags: [linux,shell]
---
shell是一个命令行解释器，它为用户提供了一个向linux内核发送请求以便运行程序的界面系统级程序，用户可以用shell来启动、挂起、停止甚至是编写一些程序。
<!-- more -->

## shell脚本的执行方式
### 脚本格式要求
    脚本以 #!/bin/bash开头
    脚本需要可执行权限

### 编写第一个shell脚本
需求:创建一个shell脚本，输出 hello world!

案例:

![Shell编程](/assets/images/linux/Shell编程001.png)

### 脚本的常用执行方式
    方式一:输入脚本的绝对路径 或 相对路径
    chmod 744 myShell.sh         -> 给所有者一个x权限
    ./myShell.sh                 -> 相对路径执行
    /root/shelltest/myShell.sh   -> 绝对路径执行

```bash
[root@localhost shelltest]# pwd
/root/shelltest
[root@localhost shelltest]# ll
total 0
[root@localhost shelltest]# vim myShell.sh
[root@localhost shelltest]# ll
total 4
-rw-r--r-- 1 root root 33 Apr 17 06:24 myShell.sh
[root@localhost shelltest]# chmod 744 myShell.sh
[root@localhost shelltest]# ll
total 4
-rwxr--r-- 1 root root 33 Apr 17 06:24 myShell.sh
[root@localhost shelltest]# ./myShell.sh 
hello world! 
[root@localhost shelltest]# /root/shelltest/myShell.sh 
hello world! 
[root@localhost shelltest]#
```

    方式二:sh + 脚本
    说明：不用赋予脚本 +x权限，直接执行即可
    chmod 744 myShell.sh         -> 给所有者一个x权限
    ./myShell.sh                 -> 相对路径执行
    /root/shelltest/myShell.sh   -> 绝对路径执行

```bash
[root@localhost shelltest]# vim myShell2.sh
[root@localhost shelltest]# ll
total 8
-rw-r--r-- 1 root root 32 Apr 17 06:33 myShell2.sh
-rwxr--r-- 1 root root 33 Apr 17 06:24 myShell.sh
[root@localhost shelltest]# sh myShell2.sh 
hello world!
[root@localhost shelltest]#
```
## shell脚本的变量
### shell变量的介绍
    shell变量分为:系统变量 和 用户自定义变量
    系统变量:$HOME , $PWD , $SHELL , $USER 等等

```
[root@localhost shelltest]# echo "$HOME"
/root
[root@localhost shelltest]# echo "$PATH"
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
[root@localhost shelltest]# echo "USER"
USER
[root@localhost shelltest]#
```

    显示当前shell中所有的变量: set
    [root@localhost shelltest]# set

### shell变量定义
    定义变量: 变量=值
    撤销变量: unset 变量
    声明静态变量: readonly 变量, 注意: 不能unset
    可以把变量提升为全局环境变量,可供其他shell程序使用.

#### 编写shell脚本
```bash
#!/bin/bash
# echo "hello world! "
A=100
echo "A=$A"
unset A
echo "A=$A"
readonly C=99
echo "C=$C"
unset C
echo "C=$C"
```

#### 执行shell脚本,报错,静态变量不能unset
```
[root@localhost shelltest]# ./myShell.sh 
A=100
A=
C=99
./myShell.sh: line 9: unset: C: cannot unset: readonly variable
C=99
[root@localhost shelltest]#
```

查看,发现是第9行出错了

![Shell编程](/assets/images/linux/Shell编程002.png)

#### shell定义变量规则
    1.变量名称可以由字母、数字和下划线组成，但是不能以数字开头。
    2.等号两侧不能有空格
    3.变量名称一般习惯为大写

#### 将命令的返回值赋给变量(重点)
    1.A=`ls`  反引号，运行里面的命令，并把结果返回给变量A
    2.A=$(ls) 等价于反引号

```
[root@localhost shellTest]# pwd
/root/shellTest
[root@localhost shellTest]# ll
总用量 8
-rw-r--r-- 1 root root   8 4月  17 19:05 app.log
-rwxr--r-- 1 root root 101 4月  17 19:13 myShell.sh
[root@localhost shellTest]# cat myShell.sh 
#!/bin/bash
MY_FILE=`ls`
echo "$MY_FILE"

echo "-------------------"
MY_DATE=$(date)
echo "$MY_DATE"
[root@localhost shellTest]# ./myShell.sh 
app.log
myShell.sh
-------------------
2018年 04月 17日 星期二 19:14:14 CST
[root@localhost shellTest]#
```

## 设置环境变量
### 基本语法
    1.export 变量名=变量值  (功能描述:将shell变量输出为环境变量)
    2.source 配置文件       (功能描述:让修改后的配置信息立即生效)
    3.echo $变量名          (功能描述:查询环境变量的值)

    为了让 /ect/profile 的环境变量生效,需要使用source /ect/profile 重启系统或注销用户.

#### 小案例
    1.在 /etc/profile 文件中定义 TOMCAT_HOME 环境变量.
    2.查看环境变量: echo $TOMCAT_HOME
    3.在另外一个shell程序中使用 TOMCAT_HOME 变量.

定义自己的环境变量TOMCAT_HOME

![Shell编程](/assets/images/linux/Shell编程-定义自己的环境变量003.png)

```
[root@localhost ~]# vim /etc/profile
[root@localhost ~]# echo $TOMCAT_HOME

[root@localhost ~]# source /etc/profile
[root@localhost ~]# echo $TOMCAT_HOME
/opt/tomcat
[root@localhost ~]#
```

使用自己定义的环境变量TOMCAT_HOME

![Shell编程](/assets/images/linux/Shell编程-定义自己的环境变量004.png)
```
[root@localhost shellTest]# vim myShell.sh 
[root@localhost shellTest]# ./myShell.sh 
2018年 04月 17日 星期二 21:21:49 CST
tomcathome=/opt/tomcat
[root@localhost shellTest]#
```

## 位置参数变量
### 介绍
当我们在执行一个shell脚本时，如果希望获取到命令行的参数信息，就可以使用到位置参数变量，如： /myshell.sh 100 200 ,这个就是一个执行shell的命令，可以在myshell 脚本中获取到参数信息。

### 基本语法
    $n: n为数字,$0代表命令行本身,$1-$9代表第一到第九个参数,十以上的参数需要用大括号包含,如${10}
    $*: 代表命令行中的所有参数,$*把所有的参数看成一个整体
    $@: 代表命令行中的所有参数,不过$@把每个参数区分对待
    $#: 代表命令行中所有参数的个数

### 案例
编写 positionPara.sh , 在脚本中获取到命令行中的各个参数的细信息

![Shell编程](/assets/images/linux/Shell编程005.png)

```
[root@localhost shellTest]# vim positionPara.sh
[root@localhost shellTest]# ll
总用量 12
-rw-r--r-- 1 root root   8 4月  17 19:05 app.log
-rwxr--r-- 1 root root 226 4月  17 21:21 myShell.sh
-rw-r--r-- 1 root root 143 4月  17 21:55 positionPara.sh
[root@localhost shellTest]# chmod 544 positionPara.sh 
[root@localhost shellTest]# ll
总用量 12
-rw-r--r-- 1 root root   8 4月  17 19:05 app.log
-rwxr--r-- 1 root root 226 4月  17 21:21 myShell.sh
-r-xr--r-- 1 root root 143 4月  17 21:55 positionPara.sh
[root@localhost shellTest]# ./positionPara.sh 
./positionPara.sh  
--------

--------

========
参数的个数=0
[root@localhost shellTest]# ./positionPara.sh 20 99
./positionPara.sh 20 99
--------
20 99
--------
20 99
========
参数的个数=2
[root@localhost shellTest]#
```

## 预定义变量
就是shell设计者事先已经定义好的变量,可以直接在shell脚本中使用
### 基本语法
    $$: 当前进程的进程号PID
    $!: 后台运行的最后一个进程的进程号PID
    $?: 最后一次执行的命令返回的状态,如果这个变量的值为0,证明上一个命令正确执行;如果这个变量的值非0(具体哪个数,有命令自己决定),则证明上一个命令执行错误.
### 实例
在一个preVar.sh 脚本中简单使用预定义变量

![Shell编程](/assets/images/linux/Shell编程006.png)