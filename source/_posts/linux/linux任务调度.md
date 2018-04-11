---
title: linux任务调度
date: 2018-04-11 21:59:48
tags: linux
---
## linux任务调度概念
任务调度：是指系统在某个时间执行的特定的命令或程序。

任务调度分类：

1.系统工作：有些重要的工作必须周而复始的执行，如病毒扫描等。

2.个别用户工作：个别用户可能希望执行某些程序，比如mysql数据库的备份。
<!-- more -->

## 基本语法
crontab [选项]

### 常用选项
```
-e  编辑crontab定时任务
-l  查询crontab任务
-r  删除当前用户所有的crontab任务
```

## 快速入门
### 任务的要求
设置任务调度文件: /etc/crontab

设置个人任务调度，执行 crontab -e 命令

接着输入任务到调度文件

如： */1 * * * * date >> /tmp/time.txt

意思说，每分钟把date时间 追加到 /tmp/time.txt 文件中。

### 步骤
    1. crontab -e
    2. 输入：*/1 * * * * date >> /tmp/time.txt
    3.当保存退出后就执行程序
    4.在每分钟都会自动的调用 date >> /tmp/time.txt
```
[root@localhost ~]# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

[root@localhost ~]# crontab -e
[root@localhost ~]# crontab -l
*/1 * * * * date >> /tmp/time.txt

[root@localhost ~]# cat /tmp/time.txt
2018年 04月 12日 星期四 06:29:01 CST
2018年 04月 12日 星期四 06:30:01 CST
2018年 04月 12日 星期四 06:31:01 CST
2018年 04月 12日 星期四 06:32:02 CST
2018年 04月 12日 星期四 06:33:01 CST
[root@localhost ~]#
```

### 参数细节说明(5个占位符的说明)
```
项目          含义                    范围
第1个*       一小时当中的第几分钟     0-59
第2个*       一天当中的第几小时       0-23
第3个*       一个月当中的第几天       1-31
第4个*       一年当中的第几个月       1-12
第5个*       一周当中的星期几         0-7
```

### 特殊符号说明
```
符号    含义
*       代表任何时间，比如第一个*就代表一小时每分钟都执行一次的意思
,       代表不连续的时间，比如"0 8,12,16 * * *",表示每天的8:00,12:00,16:00 都执行一次命令
-       代表连续的时间范围，比如"0 5 * * 1-6"命令，表示周一到周五的5:00执行命令
*/n     代表每隔多久执行一次，比如 "*/10 * * * * "命令，表示每隔10分钟执行一次命令
```

### 特定时间执行案例
```
时间           含义
45 22 * * *    在每天22点45分执行命令
0 17 * * 1     每周1的17点0分执行命令
0 5 1,15 * *   每月的1号和15号的5点0分执行命令
40 4 * * 1-5   每周1和周5的4点40分执行命令
*/10 4 * * *　 每天的4点，每隔10分钟执行一次命令
0 0 1,15 * 1   每月1号和15号，每周1的0点0分都会执行命令。注意：星期几和几号最好不要同时出现，因为他们定义的都是天。非常容易让管理员混乱。
```

## 任务调度的实例
### 每隔一分钟，就将当前的时间追加到 /tmp/mydate.txt文件中
    1. 先编写一个文件 /home/mytask1.sh
       date >> /tmp/mydate.txt
    2. 给mytask1.sh 一个可以执行的权限
       chmod 744 /home/mytask1.sh
    3. crontab -e
    4. */1 * * * * /home/mytask1.sh
    5. 成功 

命令：

```
[root@localhost ~]# vim /home/mytask1.sh
[root@localhost ~]# cat /home/mytask1.sh 
date >> /tmp/mydate.txt
[root@localhost ~]# cd /home/
[root@localhost home]# ll
总用量 4
drwx------. 2 docker docker 62 7月   8 2017 docker
-rw-r--r--  1 root   root   24 4月  12 06:59 mytask1.sh
[root@localhost home]# chomd 744 /home/mytask1.sh 
-bash: chomd: 未找到命令
[root@localhost home]# chmod 744 /home/mytask1.sh 
[root@localhost home]# ll
总用量 4
drwx------. 2 docker docker 62 7月   8 2017 docker
-rwxr--r--  1 root   root   24 4月  12 06:59 mytask1.sh
[root@localhost home]# crontab -e
crontab: installing new crontab
[root@localhost home]# crontab -l
*/1 * * * * date >> /tmp/time.txt
*/1 * * * * /home/mytask1.sh
[root@localhost home]# date
2018年 04月 12日 星期四 07:02:49 CST
[root@localhost home]# cat /tmp/mydate.txt 
2018年 04月 12日 星期四 07:03:01 CST
[root@localhost home]#
```

### 每天凌晨2:00 将mysql数据库 testdb , 备份到文件mydb.bak
     1. 先编写一个文件 /home/mytask2.sh 
         /usr/local/mysql/bin/mysqldump -u root -proot testdb > /tmp/mydb.bak
     2. 给mytask2.sh 一个可以执行的权限
        chmod 744 /home/mytask2.sh
     3. crontab -e
     4. 0 2 * * *  /home/mytask2.sh
     5. 成功
 
## crond 相关指令
 1. crontab -r ：终止任务调度
 2. crontab -l ：列出当前有哪些任务调度
 3. systemctl restart crond [重启任务调度] 

```
[root@localhost home]# systemctl restart crond
[root@localhost home]# systemctl status crond
● crond.service - Command Scheduler
   Loaded: loaded (/usr/lib/systemd/system/crond.service; enabled; vendor preset: enabled)
   Active: active (running) since 四 2018-04-12 07:21:02 CST; 12s ago
 Main PID: 8133 (crond)
   CGroup: /system.slice/crond.service
           └─8133 /usr/sbin/crond -n

4月 12 07:21:02 localhost.localdomain systemd[1]: Started Command Scheduler.
4月 12 07:21:02 localhost.localdomain systemd[1]: Starting Command Scheduler...
4月 12 07:21:02 localhost.localdomain crond[8133]: (CRON) INFO (RANDOM_DELAY will be scaled with factor 64% if used.)
4月 12 07:21:02 localhost.localdomain crond[8133]: (CRON) INFO (running with inotify support)
4月 12 07:21:02 localhost.localdomain crond[8133]: (CRON) INFO (@reboot jobs will be run at computer's startup.)
[root@localhost home]#
```
