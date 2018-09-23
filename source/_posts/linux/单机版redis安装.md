---
title: 单机版redis安装
date: 2018-09-23 19:37:53
tags: [redis,linux]
---
## 安装前提
需要安装gcc：yum install gcc-c++
```
[root@node-1 opt]# yum install gcc-c++
```
<!-- more -->

## 上传文件,解压源码
```
[root@node-1 opt]# pwd
/opt
[root@node-1 opt]# ll
总用量 1700
drwxr-xr-x. 10 root root     212 10月 11 2017 gitlab
-rw-r--r--   1 root root 1739656 9月  22 07:30 redis-4.0.11.tar.gz
drwxr-xr-x.  4 root root      80 7月  26 2017 tomcats
[root@node-1 opt]# 
[root@node-1 opt]# tar -zxvf redis-4.0.11.tar.gz
[root@node-1 opt]# ll
总用量 1700
drwxr-xr-x. 10 root root     212 10月 11 2017 gitlab
drwxrwxr-x   6 root root     309 8月   4 06:44 redis-4.0.11
-rw-r--r--   1 root root 1739656 9月  22 07:30 redis-4.0.11.tar.gz
drwxr-xr-x.  4 root root      80 7月  26 2017 tomcats
[root@node-1 opt]#
```

## make
```
[root@node-1 redis-4.0.11]# pwd
/opt/redis-4.0.11
[root@node-1 redis-4.0.11]# ll
总用量 304
-rw-rw-r--  1 root root 164219 8月   4 06:44 00-RELEASENOTES
-rw-rw-r--  1 root root     53 8月   4 06:44 BUGS
-rw-rw-r--  1 root root   1815 8月   4 06:44 CONTRIBUTING
-rw-rw-r--  1 root root   1487 8月   4 06:44 COPYING
drwxrwxr-x  6 root root    124 8月   4 06:44 deps
-rw-rw-r--  1 root root     11 8月   4 06:44 INSTALL
-rw-rw-r--  1 root root    151 8月   4 06:44 Makefile
-rw-rw-r--  1 root root   4223 8月   4 06:44 MANIFESTO
-rw-rw-r--  1 root root  20543 8月   4 06:44 README.md
-rw-rw-r--  1 root root  58766 8月   4 06:44 redis.conf
-rwxrwxr-x  1 root root    271 8月   4 06:44 runtest
-rwxrwxr-x  1 root root    280 8月   4 06:44 runtest-cluster
-rwxrwxr-x  1 root root    281 8月   4 06:44 runtest-sentinel
-rw-rw-r--  1 root root   7921 8月   4 06:44 sentinel.conf
drwxrwxr-x  3 root root   4096 8月   4 06:44 src
drwxrwxr-x 10 root root    167 8月   4 06:44 tests
drwxrwxr-x  8 root root   4096 8月   4 06:44 utils
[root@node-1 redis-4.0.11]# make
# make 过程 .............................
# make 过程 .............................
# make 过程 .............................
    CC expire.o
    CC geohash.o
    CC geohash_helper.o
    CC childinfo.o
    CC defrag.o
    CC siphash.o
    CC rax.o
    LINK redis-server
    INSTALL redis-sentinel
    CC redis-cli.o
    LINK redis-cli
    CC redis-benchmark.o
    LINK redis-benchmark
    INSTALL redis-check-rdb
    INSTALL redis-check-aof

Hint: It's a good idea to run 'make test' ;)

make[1]: 离开目录“/opt/redis-4.0.11/src”
[root@node-1 redis-4.0.11]#
```
## make install
```
[root@node-1 redis-4.0.11]# pwd
/opt/redis-4.0.11
[root@node-1 redis-4.0.11]# mkdir /data/redis
[root@node-1 redis-4.0.11]# ll /data/
总用量 0
drwxr-xr-x 3 root root 16 4月  19 21:37 backup
drwxr-xr-x 3 root root 20 6月  17 18:57 docker
drwxr-xr-x 2 root root  6 9月  22 08:28 redis
drwxr-xr-x 3 root root 61 9月  19 06:29 zk
[root@node-1 redis-4.0.11]# 
[root@node-1 redis-4.0.11]# make install PREFIX=/data/redis
cd src && make install
make[1]: 进入目录“/opt/redis-4.0.11/src”
    CC Makefile.dep
make[1]: 离开目录“/opt/redis-4.0.11/src”
make[1]: 进入目录“/opt/redis-4.0.11/src”

Hint: It's a good idea to run 'make test' ;)

    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
make[1]: 离开目录“/opt/redis-4.0.11/src”
[root@node-1 redis-4.0.11]#
[root@node-1 redis-4.0.11]# cd /data/redis/
[root@node-1 redis]# ll
总用量 0
drwxr-xr-x 2 root root 134 9月  22 08:29 bin
[root@node-1 redis]# cd bin/
[root@node-1 bin]# ll
总用量 21888
-rwxr-xr-x 1 root root 2451928 9月  22 08:29 redis-benchmark
-rwxr-xr-x 1 root root 5776216 9月  22 08:29 redis-check-aof
-rwxr-xr-x 1 root root 5776216 9月  22 08:29 redis-check-rdb
-rwxr-xr-x 1 root root 2618008 9月  22 08:29 redis-cli
lrwxrwxrwx 1 root root      12 9月  22 08:29 redis-sentinel -> redis-server
-rwxr-xr-x 1 root root 5776216 9月  22 08:29 redis-server
[root@node-1 bin]#
```

## 启动redis
### 前端启动(./redis-server)
前端模式启动的缺点是ssh命令窗口关闭则redis-server程序结束

```
[root@node-1 bin]# pwd
/data/redis/bin
[root@node-1 bin]# ll
总用量 21888
-rwxr-xr-x. 1 root root 2451928 9月  22 11:30 redis-benchmark
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-aof
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-rdb
-rwxr-xr-x. 1 root root 2618008 9月  22 11:30 redis-cli
lrwxrwxrwx. 1 root root      12 9月  22 11:30 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-server
[root@node-1 bin]# ./redis-server
4296:C 22 Sep 11:30:38.843 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
4296:C 22 Sep 11:30:38.843 # Redis version=4.0.11, bits=64, commit=00000000, modified=0, pid=4296, just started
4296:C 22 Sep 11:30:38.844 # Warning: no config file specified, using the default config. In order to specify a config file use ./redis-server /path/to/redis.conf
4296:M 22 Sep 11:30:38.844 * Increased maximum number of open files to 10032 (it was originally set to 1024).
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 4.0.11 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 4296
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

4296:M 22 Sep 11:30:38.846 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
4296:M 22 Sep 11:30:38.846 # Server initialized
4296:M 22 Sep 11:30:38.847 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
4296:M 22 Sep 11:30:38.847 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
4296:M 22 Sep 11:30:38.847 * Ready to accept connections
```

### 测试是否启动成功(./redis-cli):
```bash
[root@node-1 bin]# pwd
/data/redis/bin
[root@node-1 bin]# ll
总用量 21888
-rwxr-xr-x. 1 root root 2451928 9月  22 11:30 redis-benchmark
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-aof
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-rdb
-rwxr-xr-x. 1 root root 2618008 9月  22 11:30 redis-cli
lrwxrwxrwx. 1 root root      12 9月  22 11:30 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-server
[root@node-1 bin]# ./redis-cli 
127.0.0.1:6379> set a "hello"
OK
127.0.0.1:6379> get a
"hello"
127.0.0.1:6379>
```

### redis配置
1.把源码中的redis.conf复制到bin目录下
```bash
[root@node-1 redis]# pwd
/data/redis
[root@node-1 redis]# ll
总用量 0
drwxr-xr-x. 2 root root 168 9月  22 14:56 bin
[root@node-1 redis]# mkdir logs
[root@node-1 redis]# ll
总用量 0
drwxr-xr-x. 2 root root 191 9月  22 14:32 bin
drwxr-xr-x. 2 root root   6 9月  22 14:34 logs
[root@node-1 redis]# cd bin/
[root@node-1 bin]# ll
总用量 21952
-rw-r--r--. 1 root root     107 9月  22 14:45 dump.rdb
-rwxr-xr-x. 1 root root 2451928 9月  22 11:30 redis-benchmark
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-aof
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-check-rdb
-rwxr-xr-x. 1 root root 2618008 9月  22 11:30 redis-cli
lrwxrwxrwx. 1 root root      12 9月  22 11:30 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 5776216 9月  22 11:30 redis-server
[root@node-1 bin]# cp /opt/redis-4.0.11/redis.conf /data/redis/bin/
[root@node-1 bin]# ll
总用量 16304
-rwxr-xr-x 1 root root 2451928 9月  22 08:29 redis-benchmark
-rwxr-xr-x 1 root root 5776216 9月  22 08:29 redis-check-aof
-rwxr-xr-x 1 root root 5776216 9月  22 08:29 redis-check-rdb
-rwxr-xr-x 1 root root 2618008 9月  22 08:29 redis-cli
-rw-r--r-- 1 root root   58766 9月  22 10:57 redis.conf
lrwxrwxrwx 1 root root      12 9月  22 08:29 redis-sentinel -> redis-server
-rwxr-xr-x 1 root root       0 9月  22 08:30 redis-server
[root@node-1 bin]# vim redis.conf
```

2.配置说明
```
1.注掉本地ip,允许远程连接
bind 127.0.0.1      -->  # bind 127.0.0.1    
protected-mode yes  -->  protected-mode no 
2.配置后端启动
daemonize no        -->  daemonize yes
3.配置日志文件
logfile "../logs/redis.log"    
```

### 后端启动
​```
[root@node-1 bin]# netstat -ano | grep 6379
[root@node-1 bin]# ./redis-server redis.conf 
[root@node-1 bin]# netstat -ano | grep 6379
tcp        0      0 0.0.0.0:6379            0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp6       0      0 :::6379                 :::*                    LISTEN      off (0.00/0/0)
[root@node-1 bin]#
[root@node-2 bin]# ./redis-cli 
127.0.0.1:6379> get a
"hello"
127.0.0.1:6379> set c "abc"
OK
127.0.0.1:6379> get c
"abc"
127.0.0.1:6379>
```

## 停止redis服务
使用客户端工具关闭: ./redis-cli shutdown, -p 可以指定端口
```
[root@node-2 bin]# pwd
/data/redis/bin
[root@node-2 bin]# ./redis-cli -p 6379 shutdown
[root@node-2 bin]# ./redis-cli 
Could not connect to Redis at 127.0.0.1:6379: Connection refused
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected> get a
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected>
```

## 设置redis密码(永久方式)
### 设置密码
```
需要永久配置密码的话就去redis.conf的配置文件中找到requirepass这个参数，如下配置：
修改redis.conf配置文件　　
# requirepass foobared
requirepass redisadmin   指定密码redisadmin
保存后重启redis就可以了
```

### 连接测试
```bash
[root@node-2 bin]# vim redis.conf 
[root@node-2 bin]# ./redis-server redis.conf 
[root@node-2 bin]# netstat -ano | grep 6379
tcp        0      0 0.0.0.0:6379            0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp6       0      0 :::6379                 :::*                    LISTEN      off (0.00/0/0)
[root@node-2 bin]# ./redis-cli
127.0.0.1:6379> get a
(error) NOAUTH Authentication required.
127.0.0.1:6379> 
```

### 停止redis
redis-cli连接host,port,password,database

redis-cli -h xxxx -p 6379 -a password  -n 0(指定几号数据库,默认0号数据库)
```bash
[root@node-2 bin]# ./redis-cli -a redisadmin shutdown
Warning: Using a password with '-a' option on the command line interface may not be safe.
[root@node-2 bin]# ./redis-cli
Could not connect to Redis at 127.0.0.1:6379: Connection refused
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected> 
```

## Redis配置为Service系统服务并开机自启动
将程序配置为服务后，就可以使用service命令对系统服务进行管理，如：start（启动）、stop（停止）、restart（重启）等。Redis安装后默认不会配置为系统服务。

### 复制redis_init_script文件
1.将utils/redis_init_script文件复制/etc/rc.d/init.d/目录，并重命名为redis：

cp utils/redis_init_script /etc/rc.d/init.d/redis

注意：

以上命令需要在Redis源代码的根目录执行。redis_init_script文件是Redis提供的初始化脚本。

init.d目录---在系统启动的时候某些指定脚本将被执行。

```bash
[root@node-2 utils]# pwd
/opt/redis-4.0.11/utils
[root@node-2 utils]# ll
总用量 52
-rw-rw-r--. 1 root root  593 8月   4 06:44 build-static-symbols.tcl
-rw-rw-r--. 1 root root 1303 8月   4 06:44 cluster_fail_time.tcl
-rw-rw-r--. 1 root root 1070 8月   4 06:44 corrupt_rdb.c
drwxrwxr-x. 2 root root   60 8月   4 06:44 create-cluster
-rwxrwxr-x. 1 root root 2137 8月   4 06:44 generate-command-help.rb
drwxrwxr-x. 3 root root   31 8月   4 06:44 graphs
drwxrwxr-x. 2 root root   39 8月   4 06:44 hashtable
drwxrwxr-x. 2 root root   70 8月   4 06:44 hyperloglog
-rwxrwxr-x. 1 root root 9567 8月   4 06:44 install_server.sh
drwxrwxr-x. 2 root root   63 8月   4 06:44 lru
-rw-rw-r--. 1 root root 1277 8月   4 06:44 redis-copy.rb
-rwxrwxr-x. 1 root root 1352 8月   4 06:44 redis_init_script
-rwxrwxr-x. 1 root root 1047 8月   4 06:44 redis_init_script.tpl
-rw-rw-r--. 1 root root 1762 8月   4 06:44 redis-sha1.rb
drwxrwxr-x. 2 root root  135 8月   4 06:44 releasetools
-rwxrwxr-x. 1 root root 3787 8月   4 06:44 speed-regression.tcl
-rwxrwxr-x. 1 root root  693 8月   4 06:44 whatisdoing.sh
[root@node-2 utils]# cp redis_init_script /etc/init.d/redis
[root@node-2 utils]#
```

### 编辑redis文件
```bash
[root@node-2 utils]# cd /etc/init.d/
[root@node-2 init.d]# ll
总用量 44
lrwxrwxrwx. 1 root root    27 7月  21 2017 app -> /usr/local/src/apps/app.jar
-rw-r--r--. 1 root root 17500 5月   3 2017 functions
-rwxr-xr-x. 1 root root  4334 5月   3 2017 netconsole
-rwxr-xr-x. 1 root root  7293 5月   3 2017 network
-rw-r--r--. 1 root root  1160 9月   7 2017 README
-rwxr-xr-x. 1 root root  1352 9月  22 17:07 redis
[root@node-2 init.d]#
```
### 配置说明

1.在脚本的第二行添加 # chkconfig 2345 90 10
```
上面的注释的意思是，redis服务必须在运行级2，3，4，5下被启动或关闭，启动的优先级是90，关闭的优先级是10。
90是启动优先级，10是停止优先级，优先级范围是0－100，数字越大，优先级越低。

# 缺省的运行级，RHS用到的级别如下：
0：关机
1：单用户模式
2：无网络支持的多用户模式
3：有网络支持的多用户模式
4：保留，未使用
5：有网络支持有X-Window支持的多用户模式
6：重新引导系统，即重启

#chkconfig用法
chkconfig命令可以用来检查、设置系统的各种服务

使用语法：
chkconfig [--add][--del][--list][系统服务] 或 chkconfig [--level <等级代号>][系统服务][on/off/reset]

参数用法：
–add 　增加所指定的系统服务，让chkconfig指令得以管理它，并同时在系统启动的叙述文件内增加相关数据。
–del 　删除所指定的系统服务，不再由chkconfig指令管理，并同时在系统启动的叙述文件内删除相关数据。
–level<等级代号> 　指定读系统服务要在哪一个执行等级中开启或关毕。

使用范例：
chkconfig –list                     列出所有的系统服务
chkconfig –add redis                增加redis服务
chkconfig –del redis                删除redis 服务
chkconfig –level redis 2345 on      把redis在运行级别为2、3、4、5的情况下都是on（开启）的状态。
```

2.Redis 服务端口，这里要以 Redis 的配置文件(redis.conf)中的端口为准
```
REDISPORT=6397
```

3.redis安装位置配置
```
EXEC=/data/redis/bin/redis-server
CLIEXEC=/data/redis/bin/redis-cli
```

4.redis配置文件
```
CONF="/data/redis/bin/redis.conf"
```

### 详细配置
(前边部分,后边的不变)
```bash
#!/bin/sh
# chkconfig: 2345 90 10
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

### BEGIN INIT INFO
# Provides:     redis_6379
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Redis data structure server
# Description:          Redis data structure server. See https://redis.io
### END INIT INFO

REDISPORT=6379
EXEC=/data/redis/bin/redis-server
CLIEXEC=/data/redis/bin/redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="/data/redis/bin/redis.conf"
```

### 注册系统服务
#### chkconfig --add redis
```bash
[root@node-2 init.d]# chkconfig --add redis
[root@node-2 init.d]# 
[root@node-2 init.d]# service redis start
Starting Redis server...

*** FATAL CONFIG FILE ERROR ***
Reading the configuration file, at line 171
>>> 'logfile "../logs/redis.log"'
Can't open the log file: No such file or directory
[root@node-2 init.d]#
```

#### 重新配置redis的日志文件位置
```
logfile "/data/redis/logs/redis.log"
```

#### 重新启动
```bash
[root@node-2 init.d]# service redis start
Starting Redis server...
[root@node-2 init.d]# netstat -ano | grep redis
[root@node-2 init.d]# netstat -ano | grep 6379
tcp        0      0 0.0.0.0:6379            0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp6       0      0 :::6379                 :::*                    LISTEN      off (0.00/0/0)
[root@node-2 init.d]#
```

#### 停止服务
service redis stop 并不能停止服务,因为设定的密码,只能进入到安装目录执行命令

```bash
[root@node-2 init.d]# service redis stop
Stopping ...
(error) NOAUTH Authentication required.
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
Waiting for Redis to shutdown ...
^C
[root@node-2 init.d]#
[root@node-2 init.d]# netstat -ano | grep 6379
tcp        0      0 0.0.0.0:6379            0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 127.0.0.1:52622         127.0.0.1:6379          TIME_WAIT   timewait (36.25/0/0)
tcp6       0      0 :::6379                 :::*                    LISTEN      off (0.00/0/0)
[root@node-2 init.d]#
[root@node-2 init.d]# cd /data/redis/bin/
[root@node-2 bin]# ./redis-cli -a redisadmin shutdown
Warning: Using a password with '-a' option on the command line interface may not be safe.
[root@node-2 bin]# netstat -ano | grep 6379
[root@node-2 bin]#
```
