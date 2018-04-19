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

## 运算符
### 语法
```
"$((运算式))" 或 "$[运算式]"
expr m + n  ,注意expr运算符间要有空格
expr m -n 
expr \*,/,%  乘,除,余
```

### 实例
```
# $((运算式))
RESULE1=$(((2+3)*5))
echo "result1=$RESULE1"
# $[运算式]
RESULE2=$[(2+3)*5]
echo "result2=$RESULE2"
# expr
TEMP=`expr 2 + 3`
RESULT3=`expr $TEMP \* 4`
echo "result3=$RESULE3"
# 求出命令行中的两个参数[整数]的和
SUM=$[$1+$2]
echo "SUM=$SUM"
```

## 条件判断
### 基本语法
```
[condition] (注意condition前后要有空格)
#非空返回true,可使用$?验证 (0为true,>1为false)
```

### 实例
```
[helloShell]   返回true
[]             返回false
[condition] && echo OK || echo notok  条件满足,执行后面的语句
```

### 常用判断条件
    1.两个整数的比较
    = 字符串比较
    -lt 小于
    -le 小于等于
    -eq 等于
    -gt 大于
    -ge 大于等于
    -ne 不等于
    2.按照文件权限进行判断
    -r 有读的权限[-r 文件]
    -w 有写的权限
    -x 有执行的权限
    3.按照文件类型进行判断
    -f 文件存在并且是一个常规的文件
    -e 文件存在
    -d 文件存在并是一个目录

### 实例
```
# "ok"是否等于"ok"
if [ "ok100" = "ok" ]
then 
    echo "equal"
fi

# 23 是否大于等于 22
if [ 23 -gt 22 ]
then 
    echo "23大于22"
fi

# /root/aaa.log 目录中的文件是否存在
if [ -e /root/aaa.log ]
then 
    echo "存在文件"
fi
```

## IO流程控制
### if判断
```
语法:
if [ 条件判断 ]
then 
    程序
fi

语法:
if [ 条件判断 ]
then 
    程序
elif [ 条件判断 ]
then 
    程序
fi

实例:
# 如果输入的参数大于等于60,则输出"及格了",如果小于60,则输出"不及格"
if [ $1 -ge 60 ]
then 
    echo "及格了"
elif [ $1 -lt 60 ]
then 
    echo "不及格"
fi

```

### case语句
```
case $变量名 in
"值1")
如果变量的值等于1,则执行程序1
;;
"值2")
如果变量的值等于2,则执行程序2
;;
*)
如果变量的值都不是以上的值,则执行此程序
;;
esac

# 当命令行参数是1时,输出"周一",是2时,就输出"周二",其他情况输出"other"
case $1 in
"1")
echo "周一"
;;
"2")
echo "周二"
;;
*)
echo "其他"
;;
esac
```

### for循环
```
## 语法一:
for 变量 in 值1 值2 值3 ...
do
    程序
done
# 打印命令行输入的参数(会使用到 $* $@)
for i in "$*"
do 
    echo "the num is $i"
done 
echo "使用$@---------"
for j in "$@"
do 
    echo "the num is $j"
done

## 语法二:
for ((初始值;循环控制条件;变量变化))
do 
    程序
done

# 从1加到100的值输出显示
SUM=0
for((i=1;i<=100;i++))
do 
    SUM=$[$SUM+$i]
done
echo "sum=$SUM"
```

### while循环
```
while [调价你判断式]
do
    程序
done

# 从命令行中输入一个数n,统计从1+...+n 的值
SUM=0
while [$i -le $1]
do
    SUM=$[$SUM+$i]
done
echo "sum=$SUM"
```

## 函数
shell编程和其他编程语言一样,有系统函数,也有自定义函数.
### 系统函数
    basename [pathname] [suffix] ,功能：返回完整的路径最后 / 的部分,常用于获取文件名.

    dirname, 功能：返回完整路径最后 /的前面的部分，常用于返回路径部分

```
[root@localhost shellTest]# basename /shellTest/app.log 
app.log
[root@localhost shellTest]# dirname /shellTest/app.log 
/shellTest
[root@localhost shellTest]# basename /shellTest/app.log .log
app
[root@localhost shellTest]# basename /123/456/789/aa.log
aa.log
[root@localhost shellTest]#
```

### 自定义函数
    定义函数
    [function] funname[()]
    {
        Action;
        [return int;]
    }

    调用函数：funname [值]

#### 案例
```
#!/bin/bash
function getSum(){
   SUM=$[$1+$2]
   echo "和是=$SUM"
}

read -p "请输入第一个参数n1=" n1
read -p "请输入第二个参数n2=" n2

# 调用getSum
getSum $n1 $n2
```

```
[root@localhost shellTest]# vim testFun.sh
[root@localhost shellTest]# chmod 744 testFun.sh 
[root@localhost shellTest]# ./testFun.sh 
请输入第一个参数n1=23
请输入第二个参数n2=45
和是=68
[root@localhost shellTest]#
```

## shell编程综合案例
### 需求
    1.每天凌晨2:10备份 数据库 flow 到 /data/backup/mysqldb
    2.备份开始和备份结束能够给出相应的提示信息
    3.备份后的文件要求以备份时间为文件名,并打包成 .tar.gz 的形式,如: 2018-03-01_021030.tar.gz
    4.在备份的同时,检查是否有10天前备份的数据库文件,如果有就将其删除

### 实例
#### 检查mysql数据库的数据文件位置.
```
查看mysql的配置信息: cat /etc/my.cnf
数据文件位置为: datadir=/var/lib/mysql
```

#### 编写shell文件
```bash
#!/bin/bash
# 完成数据库的定时备份
# 备份的路径
BACKUP=/data/backup/db
# 当前的时间作为文件名
DATETIME=$(date +%Y_%m_%d_%H%M%S)
# 可以输出变量调试
echo $DATETIME
echo ${DATETIME}
echo "------------开始备份数据------------------------------------"
echo "------------备份的路径为 $BADKUP/DATETIME.tar.gz------------"
# 主机
HOST=localhost
# 用户名
DB_USER=root
# 密码
DB_PWD=123QWEasd!@#
# 备份数据库名
DATABASE=flow
# 创建备份路径
# 如果备份的路径文件夹存在,就使用,否则就创建
[ ! -d "$BACKUP/$DATETIME" ] && mkdir -p "${BACKUP}/$DATETIME"

# 执行mysql的备份数据库指令
mysqldump -u${DB_USER} -p${DB_PWD} --host=$HOST $DATABASE | gzip > $BACKUP/$DATETIME/$DATETIME.sql.gz
# 打包备份文件
cd $BACKUP
tar -zcvf $DATETIME.tar.gz $DATETIME
# 删除临时目录
rm -rf $BACKUP/$DATETIME

# 删除10天前的备份文件, {} \ 表示 find 找到的文件
find $BACKUP -mtime +10 -name "*.tar.gz" -exec rm -rf {} \;
echo "===============备份文件成功==================="
```

#### 编写 crontab
```
[root@localhost shellTest]# crontab -e
crontab: installing new crontab
[root@localhost shellTest]# crontab -l
*/1 * * * * date >> /tmp/time.txt
*/1 * * * * /home/mytask1.sh
10 2 * * * /root/shellTest/mysql_db_backup.sh
[root@localhost shellTest]#
```





