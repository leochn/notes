---
title: linux进程管理
date: 2018-04-12 21:50:44
tags: linux
---
## 进程基本介绍
    1.在linux中，每个执行的程序都成为一个进程。每个进程都分配一个ID号。
    2.每一个进程，都会对应一个父进程，而这个父进程可以复制多个子进程。
    3.每个进程都可能以两种方式存在，前台与后台，所谓前台进程就是用户目前的屏幕上可以进行操作的，后台进程则是实际在操作，但由于屏幕上无法看到的进程，通常使用后台方式执行。
    4.后台进程允许多个进程一起同步执行，只需要在最后加上 & ,即表示为后台进程.
    5.一般系统的服务都是以后台进程的方式存在，而且都会常驻在系统中，直到关机才结束。
<!-- more -->

### 显示系统执行的进程,ps命令
    指令： ps ，一般使用的参数是 ps -aux 

    ps -a : 显示当前终端的所有进程信息
    ps -u : 以用户的格式显示进程信息
    ps -x : 显示后台进程运行的参数

#### ps指令
```
[root@wpg-ngxs01 ~]# ps
   PID TTY          TIME CMD
110204 pts/0    00:00:00 bash
110386 pts/0    00:00:00 ps
[root@wpg-ngxs01 ~]#
```

    PID: 运行着的命令(CMD)的进程编号
    TTY: 命令所运行的位置（终端）
    TIME: 运行着的该命令所占用的CPU处理时间
    CMD: 该进程所运行的命令


#### ps -aux
可以用 | 管道和 more 连接起来分页查看

```
[root@ngxs01 ~]# ps -aux | more
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          1  0.0  0.0 125496  3300 ?        Ss    2017   1:47 /usr/lib/systemd/systemd --system --deserialize 22
root          2  0.0  0.0      0     0 ?        S     2017   0:01 [kthreadd]
root          3  0.0  0.0      0     0 ?        S     2017   0:05 [ksoftirqd/0]
root          5  0.0  0.0      0     0 ?        S<    2017   0:00 [kworker/0:0H]
root          7  0.0  0.0      0     0 ?        S     2017   0:03 [migration/0]
root          8  0.0  0.0      0     0 ?        S     2017   0:00 [rcu_bh]
root          9  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/0]
root         10  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/1]
root         11  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/2]
root         12  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/3]
root         13  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/4]
root         14  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/5]
root         15  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/6]
root         16  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/7]
root         17  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/8]
root         18  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/9]
root         19  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/10]
root         20  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/11]
root         21  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/12]
root         22  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/13]
root         23  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/14]
root         24  0.0  0.0      0     0 ?        S     2017   0:00 [rcuob/15]
```

    USER 用户名
    UID 用户ID（User ID）
    PID 进程ID（Process ID）
    PPID 父进程的进程ID（Parent Process id）
    SID 会话ID（Session id）
    %CPU 进程的cpu占用率
    %MEM 进程的内存占用率
    VSZ 进程所使用的虚存的大小（Virtual Size）
    RSS 进程使用的驻留集大小或者是实际内存的大小，Kbytes字节。
    TTY 与进程关联的终端（tty）
    STAT 进程的状态：进程状态使用字符表示的（STAT的状态码）
        R 运行 Runnable (on run queue) 正在运行或在运行队列中等待。
        S 睡眠 Sleeping 休眠中, 受阻, 在等待某个条件的形成或接受到信号。
        I 空闲 Idle
        Z 僵死 Zombie（a defunct process) 进程已终止, 但进程描述符存在, 直到父进程调用wait4()系统调用后释放。
        D 不可中断 Uninterruptible sleep (ususally IO) 收到信号不唤醒和不可运行, 进程必须等待直到有中断发生。
        T 终止 Terminate 进程收到SIGSTOP, SIGSTP, SIGTIN, SIGTOU信号后停止运行运行。
        P 等待交换页
        W 无驻留页 has no resident pages 没有足够的记忆体分页可分配。
        X 死掉的进程
        < 高优先级进程 高优先序的进程
        N 低优先 级进程 低优先序的进程
        L 内存锁页 Lock 有记忆体分页分配并缩在记忆体内
        s 进程的领导者（在它之下有子进程）；
        l 多进程的（使用 CLONE_THREAD, 类似 NPTL pthreads）
        + 位于后台的进程组

    START 进程启动时间和日期
    TIME 进程使用的总cpu时间
    COMMAND 正在执行的命令行命令
    NI 优先级(Nice)
    PRI 进程优先级编号(Priority)
    WCHAN 进程正在睡眠的内核函数名称；该函数的名称是从/root/system.map文件中获得的。
    FLAGS 与进程相关的数字标识

#### ps其他命令
    1. 把所有进程显示出来，并输出到ps001.txt文件
    命令：ps -aux > ps001.txt

    2. 输出指定的字段
    命令：ps -o pid,ppid,pgrp,session,tpgid,comm

    3.根据 CPU 使用来升序排序

    $ ps -aux --sort -pcpu | less

    4.根据 内存使用 来升序排序
    $ ps -aux --sort -pmem | less

    5.树形显示进程

    $ pstree

    6.查看特定用户进程

    在需要查看特定用户进程的情况下，我们可以使用 -u 参数。比如我们要查看用户'pungki'的进程，可以通过下面的命令：

    $ ps -u pungki

    7.通过进程名和PID过滤
    使用 -C 参数，后面跟你要找的进程的名字。比如想显示一个名为getty的进程的信息，就可以使用下面的命令：

    $ ps -C getty

    8.显示所有进程信息，连同命令行
    命令：ps -ef

```
[root@wpg-ngxs01 ~]# ps -ef | more
UID         PID   PPID  C STIME TTY          TIME CMD
root          1      0  0  2017 ?        00:01:48 /usr/lib/systemd/systemd --system --deserialize 22
root          2      0  0  2017 ?        00:00:01 [kthreadd]
root          3      2  0  2017 ?        00:00:05 [ksoftirqd/0]
root          5      2  0  2017 ?        00:00:00 [kworker/0:0H]
root          7      2  0  2017 ?        00:00:03 [migration/0]
root          8      2  0  2017 ?        00:00:00 [rcu_bh]
root          9      2  0  2017 ?        00:00:00 [rcuob/0]
root         10      2  0  2017 ?        00:00:00 [rcuob/1]
root         11      2  0  2017 ?        00:00:00 [rcuob/2]
root         12      2  0  2017 ?        00:00:00 [rcuob/3]
root         13      2  0  2017 ?        00:00:00 [rcuob/4]
root         14      2  0  2017 ?        00:00:00 [rcuob/5]
root         15      2  0  2017 ?        00:00:00 [rcuob/6]
root         16      2  0  2017 ?        00:00:00 [rcuob/7]
root         17      2  0  2017 ?        00:00:00 [rcuob/8]
root         18      2  0  2017 ?        00:00:00 [rcuob/9]
root         19      2  0  2017 ?        00:00:00 [rcuob/10]
root         20      2  0  2017 ?        00:00:00 [rcuob/11]
root         21      2  0  2017 ?        00:00:00 [rcuob/12]
root         22      2  0  2017 ?        00:00:00 [rcuob/13]
root         23      2  0  2017 ?        00:00:00 [rcuob/14]
root         24      2  0  2017 ?        00:00:00 [rcuob/15]
root         25      2  0  2017 ?        00:00:00 [rcuob/16]
root         26      2  0  2017 ?        00:00:00 [rcuob/17]
root         27      2  0  2017 ?        00:00:00 [rcuob/18]
--More--
```

    UID    ：程序被该 UID 所拥有
    PID    ：就是这个程序的 ID 
    PPID   ：则是其上级父程序的ID
    C      ：CPU使用的资源百分比
    STIME  ：系统启动时间
    TTY    ：登入者的终端机位置
    TIME   ：使用掉的CPU时间
    CMD    ：所下达的是什么指令

### 动态监控进程top
top与ps指令很相似，它们都是用来显示正在执行的进程，top和ps的最大不同之处，在于top在执行一段时间可以更新正在运行的进程。

#### 语法
    top [选项]

    选项
    -b：以批处理模式操作；
    -c：显示完整的治命令；
    -d：屏幕刷新间隔时间；
    -I：忽略失效过程；
    -s：保密模式；
    -S：累积模式；
    -i<时间>：设置间隔时间；
    -u<用户名>：指定用户名；
    -p<进程号>：指定进程；
    -n<次数>：循环显示的次数。

#### top指令
```
[root@135 ~]# top
top - 06:07:07 up 215 days, 14:15,  1 user,  load average: 2.64, 2.56, 2.58
Tasks: 122 total,   1 running, 121 sleeping,   0 stopped,   0 zombie
%Cpu(s): 58.8 us,  4.8 sy,  0.0 ni, 36.2 id,  0.1 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem : 16267956 total,  7139284 free,  3883616 used,  5245056 buff/cache
KiB Swap:        0 total,        0 free,        0 used. 11930096 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 1852 root      20   0 7828712 441696  14060 S 221.9  2.7  92146:54 java 
19442 root      20   0 7917604 1.273g  13956 S   5.3  8.2 370:48.99 java
18849 root      20   0 4642200 389456  17100 S   1.3  2.4 302:14.54 java 
18901 systemd+  20   0   72356  30028   1604 S   1.0  0.2 269:38.27 redis-server     
 3199 root      20   0  130988  14500   9096 S   0.3  0.1  82:34.38 AliYunDun
 5531 root      20   0    1540    512    340 S   0.3  0.0  74:09.63 aliyun-service     
15232 root      20   0  157700   2168   1512 R   0.3  0.0   0:00.08 top 
    1 root      20   0   43344   3596   2308 S   0.0  0.0   1:52.24 systemd
    2 root      20   0       0      0      0 S   0.0  0.0   0:03.26 kthreadd
    3 root      20   0       0      0      0 S   0.0  0.0   0:14.37 ksoftirqd/0
    5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H
    7 root      rt   0       0      0      0 S   0.0  0.0   0:04.41 migration/0
    8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh 
    9 root      20   0       0      0      0 S   0.0  0.0  55:32.37 rcu_sched
   10 root      rt   0       0      0      0 S   0.0  0.0   0:49.62 watchdog/0
   11 root      rt   0       0      0      0 S   0.0  0.0   0:37.31 watchdog/1 
   12 root      rt   0       0      0      0 S   0.0  0.0   0:04.18 migration/1
```

#### top命令的结果分为两个部分
    统计信息：前五行是系统整体的统计信息；
    进程信息：统计信息下方类似表格区域显示的是各个进程的详细信息，默认5秒刷新一次。

#### 统计信息说明：
    第1行：Top 任务队列信息(系统运行状态及平均负载)，与uptime命令结果相同。 
        第1段：系统当前时间，例如： 06:07:07
        第2段：系统运行时间，未重启的时间，时间越长系统越稳定。 
            格式：up xx days, HH:MM
            例如：215 days, 14:15, 表示连续运行了215天14小时15分钟
        第3段：当前登录用户数，例如：1 user，表示当前1个用户登录
        第4段：系统负载，即任务队列的平均长度，3个数值分别统计最近1，5，15分钟的系统平均负载 
            系统平均负载：单核CPU情况下，0.00 表示没有任何负荷，1.00表示刚好满负荷，超过1侧表示超负荷，理想值是0.7；
            多核CPU负载：CPU核数 * 理想值0.7 = 理想负荷，例如：4核CPU负载不超过2.8何表示没有出现高负载。

    第2行：Tasks 进程相关信息 
        第1段：进程总数，例如：Tasks: 122 total, 表示总共运行389个进程
        第2段：正在运行的进程数，例如：1 running,
        第3段：睡眠的进程数，例如：121 sleeping,
        第4段：停止的进程数，例如：0 stopped,
        第5段：僵尸进程数，例如：0 zombie

    第3行：Cpus CPU相关信息，如果是多核CPU，按数字1可显示各核CPU信息，此时1行将转为Cpu核数行，数字1可以来回切换。 
        第1段：us 用户空间占用CPU百分比，例如：Cpu(s): 58.8%us,
        第2段：sy 内核空间占用CPU百分比，例如：4.8%sy,
        第3段：ni 用户进程空间内改变过优先级的进程占用CPU百分比，例如：0.0%ni,
        第4段：id 空闲CPU百分比，例如：36.2%id,
        第5段：wa 等待输入输出的CPU时间百分比，例如：0.0%wa,
        第6段：hi CPU服务于硬件中断所耗费的时间总额，例如：0.0%hi,
        第7段：si CPU服务软中断所耗费的时间总额，例如：0.1%si,
        第8段：st Steal time 虚拟机被hypervisor偷去的CPU时间（如果当前处于一个hypervisor下的vm，实际上hypervisor也是要消耗一部分CPU处理时间的）

        按数字1可显示各核CPU信息,显示如下：
        %Cpu(s): 58.8 us,  4.8 sy,  0.0 ni, 36.2 id,  0.1 wa,  0.0 hi,  0.1 si,  0.0 st

        %Cpu0  : 83.7 us,  5.3 sy,  0.0 ni, 11.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
        %Cpu1  : 49.5 us,  3.3 sy,  0.0 ni, 46.8 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st
        %Cpu2  : 39.3 us,  3.4 sy,  0.0 ni, 56.6 id,  0.3 wa,  0.0 hi,  0.3 si,  0.0 st
        %Cpu3  : 38.2 us,  4.1 sy,  0.0 ni, 57.4 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st

    第4行：Mem 内存相关信息（Mem: 16267956 total, 7139284 free, 3883616 used, 5245056 buffers） 
        第1段：物理内存总量，例如：Mem: 16267956 total,
        第2段：空闲内存总量，例如：Mem: 7139284 free,
        第3段：使用的物理内存总量，例如：3883616 used,
        第4段：用作内核缓存的内存量，例如：5245056 buffers

    第5行：Swap 交换分区相关信息（Swap: 0 total, 0 used, 0 free, 11930096 cached） 
        第1段：交换区总量，例如：Swap: 0 total,
        第2段：空闲交换区总量，例如：0 free,
        第3段：使用的交换区总量，例如：0 used,
        第4段：缓冲的交换区总量，11930096 cached

#### 进程信息：
    在top命令中按f按可以查看显示的列信息，按对应字母来开启/关闭列，大写字母表示开启，小写字母表示关闭。带*号的是默认列。

    *A: PID = (Process Id) 进程Id；
    *E: USER = (User Name) 进程所有者的用户名；
    *H: PR = (Priority) 优先级
    *I: NI = (Nice value) nice值。负值表示高优先级，正值表示低优先级
    *O: VIRT = (Virtual Image (kb)) 进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
    *Q: RES = (Resident size (kb)) 进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
    *T: SHR = (Shared Mem size (kb)) 共享内存大小，单位kb
    *W: S = (Process Status) 进程状态。D=不可中断的睡眠状态,R=运行,S=睡眠,T=跟踪/停止,Z=僵尸进程
    *K: %CPU = (CPU usage) 上次更新到现在的CPU时间占用百分比
    *N: %MEM = (Memory usage (RES)) 进程使用的物理内存百分比
    *M: TIME+ = (CPU Time, hundredths) 进程使用的CPU时间总计，单位1/100秒 

    b: PPID = (Parent Process Pid) 父进程Id 
    c: RUSER = (Real user name) 
    d: UID = (User Id) 进程所有者的用户id 
    f: GROUP = (Group Name) 进程所有者的组名 
    g: TTY = (Controlling Tty) 启动进程的终端名。不是从终端启动的进程则显示为 ? 
    j: P = (Last used cpu (SMP)) 最后使用的CPU，仅在多CPU环境下有意义 
    p: SWAP = (Swapped size (kb)) 进程使用的虚拟内存中，被换出的大小，单位kb 
    l: TIME = (CPU Time) 进程使用的CPU时间总计，单位秒 
    r: CODE = (Code size (kb)) 可执行代码占用的物理内存大小，单位kb 
    s: DATA = (Data+Stack size (kb)) 可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb 
    u: nFLT = (Page Fault count) 页面错误次数 
    v: nDRT = (Dirty Pages count) 最后一次写入到现在，被修改过的页面数 
    y: WCHAN = (Sleeping in Function) 若该进程在睡眠，则显示睡眠中的系统函数名 
    z: Flags = (Task Flags <sched.h>) 任务标志，参考 sched.h

    *X: COMMAND = (Command name/line) 命令名/命令行

#### top命令交互
    常用交互操作 
        基础操作 
            1：显示CPU详细信息，每核显示一行
            d / s ：修改刷新频率，单位为秒
            h：可显示帮助界面
            n：指定进程列表显示行数，默认为满屏行数
            q：退出top
        面板隐藏显示 
            l：隐藏/显示第1行负载信息；
            t：隐藏/显示第2~3行CPU信息；
            m：隐藏/显示第4~5行内存信息；
        进程列表排序 
            M：根据驻留内存大小进行排序；
            P：根据CPU使用百分比大小进行排序；
            T：根据时间/累计时间进行排序；
    详细交互指令：h / ? 可显示帮助界面，原始为英文版，简单翻译如下：


### 系统网络情况netstat
 netstat命令用来打印Linux中网络系统的状态信息，可让你得知整个Linux系统的网络情况.

 如果你的计算机有时候接收到的数据报导致出错数据或故障，你不必感到奇怪，TCP/IP可以容许这些类型的错误，并能够自动重发数据报。但如果累计的出错情况数目占到所接收的IP数据报相当大的百分比，或者它的数目正迅速增加，那么你就应该使用netstat查一查为什么会出现这些情况了。

#### 选项参数:
    1) -a或–all 　　　　 显示所有连线中的Socket。 
    2) -n或–numeric     直接使用IP地址，而不通过域名服务器。
    3) -t或–tcp 　　　　显示TCP传输协议的连线状况。
    4) -u或–udp 　　    显示UDP传输协议的连线状况。
    5) -v或–verbose     显示指令执行过程。
    6) -p或–programs  显示正在使用Socket的程序识别码和程序名称。
    7) -s或–statistice   显示网络工作信息统计表。

#### 实例:
1)[root@localhost ~]# netstat　　　无参数的使用

```
[root@localhost ~]# netstat
Active Internet connections (w/o servers)      //有源TCP连接
Proto Recv-Q Send-Q Local Address               Foreign Address             State      
tcp        0    268 192.168.120.204:ssh         10.2.0.68:62420             ESTABLISHED 
udp        0      0 192.168.120.204:4371        10.58.119.119:domain        ESTABLISHED 
Active UNIX domain sockets (w/o servers)       //有源Unix域套接口（和网络套接字一样，但是只能用于本机通信，性能可以提高一倍）
Proto RefCnt Flags       Type       State         I-Node Path
unix  2      [ ]         DGRAM                    1491   @/org/kernel/udev/udevd
unix  4      [ ]         DGRAM                    7337   /dev/log
unix  2      [ ]         DGRAM                    708823 
unix  2      [ ]         DGRAM                    7539   
unix  3      [ ]         STREAM     CONNECTED     7287   
unix  3      [ ]         STREAM     CONNECTED     7286   
[root@localhost ~]#
```

#### 说明:
    1."Recv-Q"和"Send-Q"指的是接收队列和发送队列.

    2.Proto显示连接使用的协议:
    RefCnt表示连接到本套接口上的进程号；Types显示套接口的类型；State显示套接口当前的状态；Path表示连接到套接口的其它进程使用的路径名。

    3.套接口类型：
        -t ：TCP
        -u ：UDP
        -raw ：RAW类型
        --unix ：UNIX域类型
        --ax25 ：AX25类型
        --ipx ：ipx类型
        --netrom ：netrom类型

    4.状态说明：
        LISTEN： 侦听来自远方的TCP端口的连接请求
        SYN-SENT：再发送连接请求后等待匹配的连接请求（如果有大量这样的状态包，检查是否中招了）
        SYN-RECEIVED: 再收到和发送一个连接请求后等待对方对连接请求的确认（如有大量此状态，估计被flood攻击了）
        ESTABLISHED：意思是建立连接。表示两台机器正在通信。
        FIN-WAIT-1：等待远程TCP连接中断请求，或先前的连接中断请求的确认
        FIN-WAIT-2：从远程TCP等待连接中断请求
        CLOSE-WAIT：等待从本地用户发来的连接中断请求,对方主动关闭连接或者网络异常导致连接中断，这时我方的状态会变成CLOSE_WAIT 此时我方要调用close()来使得连接正确关闭
        CLOSING：等待远程TCP对连接中断的确认
        LAST-ACK：等待原来的发向远程TCP的连接中断请求的确认（不是什么好东西，此项出现，检查是否被攻击）
        TIME-WAIT：等待足够的时间以确保远程TCP接收到连接中断请求的确认.
            我方主动调用close()断开连接，收到对方确认后状态变为TIME_WAIT。TCP协议规定TIME_WAIT状态会一直持续2MSL(即两倍的分段最大生存期)，以此来确保旧的连接状态不会对新连接产生影响。处于TIME_WAIT状态的连接占用的资源不会被内核释放，所以作为服务器，在可能的情况下，尽量不要主动断开连接，以减少TIME_WAIT状态造成的资源浪费。
            目前有一种避免TIME_WAIT资源浪费的方法，就是关闭socket的LINGER选项。但这种做法是TCP协议不推荐使用的，在某些情况下这个操作可能会带来错误。
        CLOSED：没有任何连接状态

### nohup
语法：nohup program &
描述：使进程在用户退出登陆后仍旧继续执行