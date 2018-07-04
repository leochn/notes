---
title: linux软件包管理
date: 2018-04-12 21:50:55
tags: linux
---
## 软件包分类
```
源码包：
优点：
开源，可以修改源代码；
可以自由选择所需要的供能；
软件是编译安装，所以更加适合自己的系统，更加稳定效率更高；卸载方便。

缺点：
安装过程步骤较多；编译时间较长，比二进制安装时间长；
因为是编译安装，安装过程中一旦报错新手很难解决。

二进制包（rpm包、系统默认包）
优点：
包管理系统简单，只通过几个命令就可以实现包的安装、升级、查询和卸载；
安装速度快。
缺点：
经过编译，不再可以看到源码；
功能选择不如源码分析宝宝灵活；
依赖性 (a->b->c)。
```

<!-- more -->
## rpm包管理 - rmp命令管理
### rpm包命名原则
```
    mysql80-community-release-el7-1.noarch.rpm
    httpd-2.2.15-60.el6.centos.4.i686.rpm
    httpd      软件包名
    2.2.15     软件版本
    60         软件发布的次数
    el6.centos 适合的Linux平台
    i686       适合的硬件平台
    rpm        rpm包扩展名
```
### rpm包依赖性

    树形依赖： a -> b -> c
    环形依赖： a -> b -> c -> a
    模块依赖： 查询网站： http://rpmfind.net/

### 包全名与包名
```
包全名：
操作的包没有安装的软件包时，使用包全名。而且要注意路径。
包名：
操作已经安装的软件包时，使用包名。是搜索/var/lib/rmp/中的数据库。
```

### 包全名与包名使用场景：
```
    在安装和升级时使用包全名，查询卸载时用包名。
    RPM包安装： 
        rmp -ivh 包全名
        选项： 
           -i (install)  安装
           -v (verbose)  显示详细信息
           -h (hash)     显示进度
           --nodeps      不检查依赖性
        上面的--nodeps只能在做实验时用！因为如果写上了的话，万一这个软件包真的依赖于其他包,即使安装完了此rpm包，也是不可用的!
    RPM包升级:
        rpm -Uvh 包全名
            选项:
                -U (upgrade)  升级(Linux中严格区分大小写)
    RMP包卸载:
        rmp -e 包名
            选项:
                -e (erase)  卸载
                --nodeps    不检查依赖
```

### rpm包命令管理(查询)
#### 查询是否安装
```
rpm -qa 包名
选项:
    -q (query) 查询
    -a (all)   所有
```
#### 查询软件包详细信息
```
rpm -qi 包名
选项:
    -i (information) 查询软件信息
    -p (package)     查询未安装包信息
```
#### 查询包中文件安装位置
```
rpm -ql 包名
选项:
    -l (list) 列表
    -p (package)     查询未安装包信息
```

#### 查询系统文件属于哪个rpm包
```
rpm -qf 系统文件名
选项:
    -f (file) 查询系统文件属于哪个软件包
```

#### 查询软件包的依赖性
```
rpm -qR 包名
选项:
    -R (requires) 查询软件包的依赖性
    -p (package)  查询未安装包信息
```

### rpm命令管理-校验和文件提取
#### rmp包校验
```
rpm -V 已经安装的包名
选项:
    -V (verify) 校验指定rpm包中的文件

[root@NG ~]# rpm -V nginx
missing   c /etc/nginx/conf.d/default.conf
S.5....T.  c /etc/nginx/nginx.conf
[root@NG ~]#

其中(S.5....T.),验证内容中的8个信息的具体含义：
    S :文件大小是否改变
    M :文件的类型或文件的权限(rwx)是否被改变
    5 :文件MD5校验和是否改变文件内容
    D :表示文件的major和minor号不一致
    L :文件路径是否改变
    U :文件的所有者是否改变
    G :文件的属组是否改变
    T :文件的修改时间是否改变

S.5....T.  c /etc/nginx/nginx.conf 中的c, 文件类型
    c 配置文件(config file)
    d 普通文档(documentation)
    g "鬼文件"(ghost file),很少见,就是该文件不应该被这个rpm包所包含.
    l 授权文件(license file)
    r 描述文件(read me)
```

## rpm包管理(yum在线管理)
### 网络yum源
```
[root@localhost yum.repos.d]# cat /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base
failovermethod=priority
baseurl=http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.cloud.aliyuncs.com/centos/RPM-GPG-KEY-CentOS-7
 
#released updates 
[updates]
name=CentOS-$releasever - Updates
failovermethod=priority
baseurl=http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.cloud.aliyuncs.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
failovermethod=priority
baseurl=http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.cloud.aliyuncs.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
failovermethod=priority
baseurl=http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.cloud.aliyuncs.com/centos/RPM-GPG-KEY-CentOS-7
 
#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib
failovermethod=priority
baseurl=http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.cloud.aliyuncs.com/centos/RPM-GPG-KEY-CentOS-7
[root@localhost yum.repos.d]#

## 说明:
[base]     容器名称，一定要放在[]中
name       容器说明，可以自己随便写
mirrorlist 镜像站点，这个可以注释掉
baseurl    我们的yum源服务器的地址，默认是Centos官方的yum源服务器，是可以使用的，如果觉得慢可以修改yum源地址
enabled    此容器是否生效，如果不写或写成enable=1都是指生效，写成enable=0就是不生效
gpgcheck   如果是1只rpm的数字证书生效，如果是0则不生效
gpgkey     数字证书的公钥文件保存位置，不用修改

```

### 常用yum命令
```
yum list : 查询所有可用软件包列表
yum search 关键字： 搜索服务器上所有和关键字相关的包
yum -y install 包名： -y 表示自动回答yes
yum -y update ： 升级所有的软件包
yum -y update 包名： 升级指定的软件包
yum -y remove 包名： 卸载指定的软件包
```

## 源码包管理
### 源码包和rpm包的区别
安装之前的区别：概念上的区别

安装之后的区别：安装位置的不同

### rpm包安装位置
```
rpm包默认安装位置：
/ect/           配置文件安装目录
/usr/bin/       可执行的命令安装目录
/usr/lib/       程序所使用的函数库保存位置
/usr/share/doc/ 基本的软件使用手册保存位置
/usr/share/man/ 帮助文件保存位置
```

### 源码包安装位置
```
安装在指定的位置当中，一般是：
/usr/local/软件名/
```

### 安装位置不同带来的影响
```
rpm包安装的服务可以使用系统服务管理命令(service)来管理，例如rpm包安装的apache的启动方式是：
/ect/rc.d/init.d/htpd start
service httpd start

而源码包安装的服务则不能被服务管理命令管理，因为没有安装到默认的路径中。所以只能用绝对路径进行服务的管理，如：
/usr/local/apach2/bin/apachectl start
```

### 源码包安装过程
#### 安装准备
```
1.
安装C语言编译器
下载源码包：http://mirror.bit.edu.cn/apache/httpd/

2.
源代码保存位置： /usr/local/src
软件安装位置： /usr/local
如何确定安装过程报错: 安装过程停止、并出现error,warning,no的提示

3.
./configure软件配置与检查
   定义需要的功能选项
   监测系统环境是否符合安装要求
   把定义好的功能选项和检测系统环境的信息都写入Makefile文件,用于后续的编辑.
   ./configure -- help

4.
make 编译
   make clean 清空编译产生的临时文件
make install 编译安装

5.源码包的卸载
不需要卸载命令，直接删除安装目录即可。不会遗留任何垃圾文件.
```

## 服务简介与分类
### 检查已安装的服务
```
rpm包安装的服务:
chkconfig --list   # 查看服务自启动状态,可以看到所有rpm包安装的服务

源码包安装的服务:
查看服务安装的位置,一般是 /usr/local/ 下

rpm包安装的默认位置：
/etc/init.d        启动脚本位置
/etc/sysconfig     初始化环境配置文件位置
/etc/              配置文件位置
/etc/xinetd.conf   xinetd配置文件
/etc/xinetd.d      基于xinetd服务的启动脚本
/var/lib           服务产生的数据放在这里
/var/log           日志
```
## rpm包安装服务的管理
### 独立服务管理
#### 独立服务的启动
```
/etc/init.d 独立服务名 start|stop|status|restart|
service 独立服务名 start|stop|status|restart|
```


