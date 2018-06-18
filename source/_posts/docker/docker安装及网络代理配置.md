---
title: docker安装及网络代理配置
date: 2017-09-29 07:09:15
tags: [docker,squid]
---
## 背景
在一些实验室环境，服务器没有直接连接外网的权限，即便安装好了docker之后，还需要通过网络代理。

内网服务器如何上网,可以通过squid进行代理.
<!-- more -->
## 安装docker-ce(通过库安装)
### 配置库
1.安装所需的软件包, yum-utils、device-mapper-persistent-data和 lvm2

```
[root@wpg-jens01 system]# yum install -y yum-uitls device-mapper-persistent-data lvm2
Loaded plugins: fastestmirror, langpacks
base                                                                                                                                         | 3.6 kB  00:00:00     
extras                                                                                                                                       | 3.4 kB  00:00:00     
updates                                                                                                                                      | 3.4 kB  00:00:00     
Determining fastest mirrors
 * base: centos.ustc.edu.cn
 * extras: centos.ustc.edu.cn
 * updates: centos.ustc.edu.cn
No package yum-uitls available.
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.3.2-1.el7 will be updated
---> Package device-mapper-persistent-data.x86_64 0:0.7.0-0.1.rc6.el7_4.1 will be an update
---> Package lvm2.x86_64 7:2.02.105-14.el7 will be updated
---> Package lvm2.x86_64 7:2.02.171-8.el7 will be an update
--> Processing Dependency: lvm2-libs = 7:2.02.171-8.el7 for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_97)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_138)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_135)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_133)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_128)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_113)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_110)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_107)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_104)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_103)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_101)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_100)(64bit) for package: 7:lvm2-2.02.171-8.el7.x86_64
--> Running transaction check
---> Package device-mapper-libs.x86_64 7:1.02.84-14.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.84-14.el7 for package: 7:device-mapper-1.02.84-14.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be an update
---> Package lvm2-libs.x86_64 7:2.02.105-14.el7 will be updated
---> Package lvm2-libs.x86_64 7:2.02.171-8.el7 will be an update
--> Processing Dependency: device-mapper-event = 7:1.02.140-8.el7 for package: 7:lvm2-libs-2.02.171-8.el7.x86_64
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.84-14.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.84-14.el7 will be updated
---> Package device-mapper-event.x86_64 7:1.02.140-8.el7 will be an update
--> Processing Dependency: device-mapper-event-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-event-1.02.140-8.el7.x86_64
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.84-14.el7 will be updated
---> Package device-mapper-event-libs.x86_64 7:1.02.140-8.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================================
 Package                                             Arch                         Version                                       Repository                     Size
====================================================================================================================================================================
Updating:
 device-mapper-persistent-data                       x86_64                       0.7.0-0.1.rc6.el7_4.1                         updates                       400 k
 lvm2                                                x86_64                       7:2.02.171-8.el7                              base                          1.3 M
Updating for dependencies:
 device-mapper                                       x86_64                       7:1.02.140-8.el7                              base                          280 k
 device-mapper-event                                 x86_64                       7:1.02.140-8.el7                              base                          180 k
 device-mapper-event-libs                            x86_64                       7:1.02.140-8.el7                              base                          179 k
 device-mapper-libs                                  x86_64                       7:1.02.140-8.el7                              base                          312 k
 lvm2-libs                                           x86_64                       7:2.02.171-8.el7                              base                          1.0 M

Transaction Summary
====================================================================================================================================================================
Upgrade  2 Packages (+5 Dependent packages)

Total download size: 3.6 M
Downloading packages:
No Presto metadata available for base
Not downloading deltainfo for updates, MD is 960 k and rpms are 400 k
(1/7): device-mapper-event-libs-1.02.140-8.el7.x86_64.rpm                                                                                    | 179 kB  00:00:00     
(2/7): device-mapper-event-1.02.140-8.el7.x86_64.rpm                                                                                         | 180 kB  00:00:00     
(3/7): device-mapper-1.02.140-8.el7.x86_64.rpm                                                                                               | 280 kB  00:00:00     
(4/7): lvm2-2.02.171-8.el7.x86_64.rpm                                                                                                        | 1.3 MB  00:00:00     
(5/7): device-mapper-persistent-data-0.7.0-0.1.rc6.el7_4.1.x86_64.rpm                                                                        | 400 kB  00:00:01     
(6/7): device-mapper-libs-1.02.140-8.el7.x86_64.rpm                                                                                          | 312 kB  00:00:01     
(7/7): lvm2-libs-2.02.171-8.el7.x86_64.rpm                                                                                                   | 1.0 MB  00:00:01     
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                               1.3 MB/s | 3.6 MB  00:00:02     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                                                                      1/14 
  Updating   : 7:device-mapper-1.02.140-8.el7.x86_64                                                                                                           2/14 
  Updating   : 7:device-mapper-event-libs-1.02.140-8.el7.x86_64                                                                                                3/14 
  Updating   : 7:device-mapper-event-1.02.140-8.el7.x86_64                                                                                                     4/14 
  Updating   : 7:lvm2-libs-2.02.171-8.el7.x86_64                                                                                                               5/14 
  Updating   : device-mapper-persistent-data-0.7.0-0.1.rc6.el7_4.1.x86_64                                                                                      6/14 
  Updating   : 7:lvm2-2.02.171-8.el7.x86_64                                                                                                                    7/14 
ln -s '/usr/lib/systemd/system/lvm2-lvmetad.socket' '/etc/systemd/system/sysinit.target.wants/lvm2-lvmetad.socket'
ln -s '/usr/lib/systemd/system/lvm2-lvmpolld.socket' '/etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket'
  Cleanup    : 7:lvm2-2.02.105-14.el7.x86_64                                                                                                                   8/14 
  Cleanup    : 7:lvm2-libs-2.02.105-14.el7.x86_64                                                                                                              9/14 
  Cleanup    : 7:device-mapper-event-1.02.84-14.el7.x86_64                                                                                                    10/14 
  Cleanup    : 7:device-mapper-event-libs-1.02.84-14.el7.x86_64                                                                                               11/14 
  Cleanup    : 7:device-mapper-1.02.84-14.el7.x86_64                                                                                                          12/14 
  Cleanup    : 7:device-mapper-libs-1.02.84-14.el7.x86_64                                                                                                     13/14 
  Cleanup    : device-mapper-persistent-data-0.3.2-1.el7.x86_64                                                                                               14/14 
  Verifying  : 7:lvm2-libs-2.02.171-8.el7.x86_64                                                                                                               1/14 
  Verifying  : device-mapper-persistent-data-0.7.0-0.1.rc6.el7_4.1.x86_64                                                                                      2/14 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                                                                                                           3/14 
  Verifying  : 7:device-mapper-event-libs-1.02.140-8.el7.x86_64                                                                                                4/14 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                                                                      5/14 
  Verifying  : 7:lvm2-2.02.171-8.el7.x86_64                                                                                                                    6/14 
  Verifying  : 7:device-mapper-event-1.02.140-8.el7.x86_64                                                                                                     7/14 
  Verifying  : 7:lvm2-2.02.105-14.el7.x86_64                                                                                                                   8/14 
  Verifying  : device-mapper-persistent-data-0.3.2-1.el7.x86_64                                                                                                9/14 
  Verifying  : 7:device-mapper-event-1.02.84-14.el7.x86_64                                                                                                    10/14 
  Verifying  : 7:lvm2-libs-2.02.105-14.el7.x86_64                                                                                                             11/14 
  Verifying  : 7:device-mapper-event-libs-1.02.84-14.el7.x86_64                                                                                               12/14 
  Verifying  : 7:device-mapper-libs-1.02.84-14.el7.x86_64                                                                                                     13/14 
  Verifying  : 7:device-mapper-1.02.84-14.el7.x86_64                                                                                                          14/14 

Updated:
  device-mapper-persistent-data.x86_64 0:0.7.0-0.1.rc6.el7_4.1                                     lvm2.x86_64 7:2.02.171-8.el7                                    

Dependency Updated:
  device-mapper.x86_64 7:1.02.140-8.el7               device-mapper-event.x86_64 7:1.02.140-8.el7          device-mapper-event-libs.x86_64 7:1.02.140-8.el7         
  device-mapper-libs.x86_64 7:1.02.140-8.el7          lvm2-libs.x86_64 7:2.02.171-8.el7                   

Complete!
[root@wpg-jens01 system]#
```

2.设置稳定的库
```
[root@wpg-jens01 system]# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
Loaded plugins: fastestmirror, langpacks
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
docker-ce.repo                                                                                                                               | 2.4 kB  00:00:00     
repo saved to /etc/yum.repos.d/docker-ce.repo
[root@wpg-jens01 system]#
```

### 通过yum安装Docker CE 
```
[root@wpg-jens01 system]# yum install docker-ce
Loaded plugins: fastestmirror, langpacks
docker-ce-stable                                                                                                                             | 2.9 kB  00:00:00     
docker-ce-stable/x86_64/primary_db                                                                                                           |  12 kB  00:00:03     
Loading mirror speeds from cached hostfile
 * base: centos.ustc.edu.cn
 * extras: centos.ustc.edu.cn
 * updates: centos.ustc.edu.cn
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.03.0.ce-1.el7.centos will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.03.0.ce-1.el7.centos.x86_64
--> Processing Dependency: libseccomp >= 2.3 for package: docker-ce-18.03.0.ce-1.el7.centos.x86_64
--> Processing Dependency: libsystemd.so.0(LIBSYSTEMD_209)(64bit) for package: docker-ce-18.03.0.ce-1.el7.centos.x86_64
--> Processing Dependency: pigz for package: docker-ce-18.03.0.ce-1.el7.centos.x86_64
--> Processing Dependency: libsystemd.so.0()(64bit) for package: docker-ce-18.03.0.ce-1.el7.centos.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.42-1.gitad8f0f7.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-39 for package: 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-39 for package: 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-39 for package: 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch
--> Processing Dependency: policycoreutils >= 2.5-11 for package: 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch
---> Package libseccomp.x86_64 0:2.1.1-2.el7 will be updated
---> Package libseccomp.x86_64 0:2.3.1-3.el7 will be an update
---> Package pigz.x86_64 0:2.3.3-1.el7.centos will be installed
---> Package systemd-libs.x86_64 0:208-11.el7 will be updated
--> Processing Dependency: systemd-libs = 208-11.el7 for package: systemd-208-11.el7.x86_64
---> Package systemd-libs.x86_64 0:219-42.el7_4.10 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.2.5-11.el7 will be updated
--> Processing Dependency: policycoreutils = 2.2.5-11.el7 for package: policycoreutils-python-2.2.5-11.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-6 for package: policycoreutils-2.5-17.1.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-6 for package: policycoreutils-2.5-17.1.el7.x86_64
--> Processing Dependency: libsepol.so.1(LIBSEPOL_1.1)(64bit) for package: policycoreutils-2.5-17.1.el7.x86_64
--> Processing Dependency: libsepol.so.1(LIBSEPOL_1.0)(64bit) for package: policycoreutils-2.5-17.1.el7.x86_64
--> Processing Dependency: libsemanage.so.1(LIBSEMANAGE_1.1)(64bit) for package: policycoreutils-2.5-17.1.el7.x86_64
---> Package selinux-policy.noarch 0:3.12.1-153.el7 will be updated
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be an update
---> Package selinux-policy-targeted.noarch 0:3.12.1-153.el7 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be an update
---> Package systemd.x86_64 0:208-11.el7 will be updated
--> Processing Dependency: systemd = 208-11.el7 for package: systemd-python-208-11.el7.x86_64
--> Processing Dependency: systemd = 208-11.el7 for package: libgudev1-208-11.el7.x86_64
--> Processing Dependency: systemd = 208-11.el7 for package: systemd-sysv-208-11.el7.x86_64
---> Package systemd.x86_64 0:219-42.el7_4.10 will be an update
--> Processing Dependency: kmod >= 18-4 for package: systemd-219-42.el7_4.10.x86_64
--> Running transaction check
---> Package kmod.x86_64 0:14-9.el7 will be updated
---> Package kmod.x86_64 0:20-15.el7_4.7 will be an update
---> Package libgudev1.x86_64 0:208-11.el7 will be updated
---> Package libgudev1.x86_64 0:219-42.el7_4.10 will be an update
--> Processing Dependency: glib2 >= 2.42 for package: libgudev1-219-42.el7_4.10.x86_64
---> Package libselinux-utils.x86_64 0:2.2.2-6.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-utils-2.5-11.el7.x86_64
---> Package libsemanage.x86_64 0:2.1.10-16.el7 will be updated
--> Processing Dependency: libsemanage = 2.1.10-16.el7 for package: libsemanage-python-2.1.10-16.el7.x86_64
---> Package libsemanage.x86_64 0:2.5-8.el7 will be an update
---> Package libsepol.x86_64 0:2.1.9-3.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.2.5-11.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-1 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package systemd-python.x86_64 0:208-11.el7 will be updated
---> Package systemd-python.x86_64 0:219-42.el7_4.10 will be an update
---> Package systemd-sysv.x86_64 0:208-11.el7 will be updated
---> Package systemd-sysv.x86_64 0:219-42.el7_4.10 will be an update
--> Running transaction check
---> Package glib2.x86_64 0:2.36.3-5.el7 will be updated
---> Package glib2.x86_64 0:2.50.3-3.el7 will be an update
---> Package libselinux.x86_64 0:2.2.2-6.el7 will be updated
--> Processing Dependency: libselinux = 2.2.2-6.el7 for package: libselinux-python-2.2.2-6.el7.x86_64
---> Package libselinux.x86_64 0:2.5-11.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.1.10-16.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be an update
---> Package setools-libs.x86_64 0:3.3.7-46.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.2.2-6.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Conflict: systemd-219-42.el7_4.10.x86_64 conflicts initscripts < 9.49.28-1
--> Restarting Dependency Resolution with new changes.
--> Running transaction check
---> Package initscripts.x86_64 0:9.49.17-1.el7 will be updated
---> Package initscripts.x86_64 0:9.49.39-1.el7_4.1 will be an update
--> Processing Conflict: systemd-219-42.el7_4.10.x86_64 conflicts dracut < 033-499
--> Restarting Dependency Resolution with new changes.
--> Running transaction check
---> Package dracut.x86_64 0:033-161.el7 will be updated
--> Processing Dependency: dracut = 033-161.el7 for package: dracut-config-rescue-033-161.el7.x86_64
--> Processing Dependency: dracut = 033-161.el7 for package: dracut-network-033-161.el7.x86_64
---> Package dracut.x86_64 0:033-502.el7_4.1 will be an update
--> Running transaction check
---> Package dracut-config-rescue.x86_64 0:033-161.el7 will be updated
---> Package dracut-config-rescue.x86_64 0:033-502.el7_4.1 will be an update
---> Package dracut-network.x86_64 0:033-161.el7 will be updated
---> Package dracut-network.x86_64 0:033-502.el7_4.1 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================================
 Package                                      Arch                        Version                                       Repository                             Size
====================================================================================================================================================================
Installing:
 docker-ce                                    x86_64                      18.03.0.ce-1.el7.centos                       docker-ce-stable                       35 M
Updating:
 dracut                                       x86_64                      033-502.el7_4.1                               updates                               321 k
 initscripts                                  x86_64                      9.49.39-1.el7_4.1                             updates                               435 k
Installing for dependencies:
 container-selinux                            noarch                      2:2.42-1.gitad8f0f7.el7                       extras                                 32 k
 pigz                                         x86_64                      2.3.3-1.el7.centos                            extras                                 68 k
Updating for dependencies:
 dracut-config-rescue                         x86_64                      033-502.el7_4.1                               updates                                56 k
 dracut-network                               x86_64                      033-502.el7_4.1                               updates                                98 k
 glib2                                        x86_64                      2.50.3-3.el7                                  base                                  2.3 M
 kmod                                         x86_64                      20-15.el7_4.7                                 updates                               121 k
 libgudev1                                    x86_64                      219-42.el7_4.10                               updates                                85 k
 libseccomp                                   x86_64                      2.3.1-3.el7                                   base                                   56 k
 libselinux                                   x86_64                      2.5-11.el7                                    base                                  162 k
 libselinux-python                            x86_64                      2.5-11.el7                                    base                                  234 k
 libselinux-utils                             x86_64                      2.5-11.el7                                    base                                  151 k
 libsemanage                                  x86_64                      2.5-8.el7                                     base                                  145 k
 libsemanage-python                           x86_64                      2.5-8.el7                                     base                                  104 k
 libsepol                                     x86_64                      2.5-6.el7                                     base                                  288 k
 policycoreutils                              x86_64                      2.5-17.1.el7                                  base                                  858 k
 policycoreutils-python                       x86_64                      2.5-17.1.el7                                  base                                  446 k
 selinux-policy                               noarch                      3.13.1-166.el7_4.9                            updates                               437 k
 selinux-policy-targeted                      noarch                      3.13.1-166.el7_4.9                            updates                               6.5 M
 setools-libs                                 x86_64                      3.3.8-1.1.el7                                 base                                  612 k
 systemd                                      x86_64                      219-42.el7_4.10                               updates                               5.2 M
 systemd-libs                                 x86_64                      219-42.el7_4.10                               updates                               378 k
 systemd-python                               x86_64                      219-42.el7_4.10                               updates                               118 k
 systemd-sysv                                 x86_64                      219-42.el7_4.10                               updates                                72 k

Transaction Summary
====================================================================================================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade  2 Packages (+21 Dependent packages)

Total download size: 54 M
Is this ok [y/d/N]: y
Downloading packages:
No Presto metadata available for base
updates/7/x86_64/prestodelta                                                                                                                 | 960 kB  00:00:00     
(1/26): container-selinux-2.42-1.gitad8f0f7.el7.noarch.rpm                                                                                   |  32 kB  00:00:00     
(2/26): dracut-config-rescue-033-502.el7_4.1.x86_64.rpm                                                                                      |  56 kB  00:00:00     
(3/26): dracut-network-033-502.el7_4.1.x86_64.rpm                                                                                            |  98 kB  00:00:00     
(4/26): dracut-033-502.el7_4.1.x86_64.rpm                                                                                                    | 321 kB  00:00:00     
(5/26): glib2-2.50.3-3.el7.x86_64.rpm                                                                                                        | 2.3 MB  00:00:00     
(6/26): initscripts-9.49.39-1.el7_4.1.x86_64.rpm                                                                                             | 435 kB  00:00:00     
(7/26): libseccomp-2.3.1-3.el7.x86_64.rpm                                                                                                    |  56 kB  00:00:00     
(8/26): libgudev1-219-42.el7_4.10.x86_64.rpm                                                                                                 |  85 kB  00:00:00     
(9/26): kmod-20-15.el7_4.7.x86_64.rpm                                                                                                        | 121 kB  00:00:01     
(10/26): libselinux-2.5-11.el7.x86_64.rpm                                                                                                    | 162 kB  00:00:00     
(11/26): libselinux-utils-2.5-11.el7.x86_64.rpm                                                                                              | 151 kB  00:00:00     
(12/26): libselinux-python-2.5-11.el7.x86_64.rpm                                                                                             | 234 kB  00:00:00     
(13/26): libsemanage-2.5-8.el7.x86_64.rpm                                                                                                    | 145 kB  00:00:00     
(14/26): libsemanage-python-2.5-8.el7.x86_64.rpm                                                                                             | 104 kB  00:00:00     
(15/26): libsepol-2.5-6.el7.x86_64.rpm                                                                                                       | 288 kB  00:00:00     
(16/26): pigz-2.3.3-1.el7.centos.x86_64.rpm                                                                                                  |  68 kB  00:00:00     
(17/26): policycoreutils-python-2.5-17.1.el7.x86_64.rpm                                                                                      | 446 kB  00:00:00     
(18/26): setools-libs-3.3.8-1.1.el7.x86_64.rpm                                                                                               | 612 kB  00:00:00     
(19/26): policycoreutils-2.5-17.1.el7.x86_64.rpm                                                                                             | 858 kB  00:00:00     
(20/26): selinux-policy-targeted-3.13.1-166.el7_4.9.noarch.rpm                                                                               | 6.5 MB  00:00:00     
(21/26): selinux-policy-3.13.1-166.el7_4.9.noarch.rpm                                                                                        | 437 kB  00:00:01     
(22/26): systemd-219-42.el7_4.10.x86_64.rpm                                                                                                  | 5.2 MB  00:00:00     
(23/26): systemd-libs-219-42.el7_4.10.x86_64.rpm                                                                                             | 378 kB  00:00:00     
(24/26): systemd-python-219-42.el7_4.10.x86_64.rpm                                                                                           | 118 kB  00:00:00     
(25/26): systemd-sysv-219-42.el7_4.10.x86_64.rpm                                                                                             |  72 kB  00:00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.03.0.ce-1.el7.centos.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY ETA 
Public key for docker-ce-18.03.0.ce-1.el7.centos.x86_64.rpm is not installed
(26/26): docker-ce-18.03.0.ce-1.el7.centos.x86_64.rpm                                                                                        |  35 MB  00:08:07     
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                               113 kB/s |  54 MB  00:08:07     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-6.el7.x86_64                                                                                                                       1/49 
  Updating   : libselinux-2.5-11.el7.x86_64                                                                                                                    2/49 
  Updating   : systemd-libs-219-42.el7_4.10.x86_64                                                                                                             3/49 
  Updating   : dracut-033-502.el7_4.1.x86_64                                                                                                                   4/49 
  Updating   : kmod-20-15.el7_4.7.x86_64                                                                                                                       5/49 
  Updating   : systemd-219-42.el7_4.10.x86_64                                                                                                                  6/49 
warning: /etc/rc.d/rc.local created as /etc/rc.d/rc.local.rpmnew
  Updating   : libsemanage-2.5-8.el7.x86_64                                                                                                                    7/49 
  Updating   : libselinux-utils-2.5-11.el7.x86_64                                                                                                              8/49 
  Updating   : policycoreutils-2.5-17.1.el7.x86_64                                                                                                             9/49 
  Updating   : selinux-policy-3.13.1-166.el7_4.9.noarch                                                                                                       10/49 
  Updating   : glib2-2.50.3-3.el7.x86_64                                                                                                                      11/49 
  Updating   : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                                                              12/49 
  Updating   : libsemanage-python-2.5-8.el7.x86_64                                                                                                            13/49 
  Updating   : libselinux-python-2.5-11.el7.x86_64                                                                                                            14/49 
  Updating   : setools-libs-3.3.8-1.1.el7.x86_64                                                                                                              15/49 
  Updating   : policycoreutils-python-2.5-17.1.el7.x86_64                                                                                                     16/49 
  Installing : 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch                                                                                               17/49 
setsebool:  SELinux is disabled.
  Installing : pigz-2.3.3-1.el7.centos.x86_64                                                                                                                 18/49 
  Updating   : libseccomp-2.3.1-3.el7.x86_64                                                                                                                  19/49 
  Installing : docker-ce-18.03.0.ce-1.el7.centos.x86_64                                                                                                       20/49 
  Updating   : initscripts-9.49.39-1.el7_4.1.x86_64                                                                                                           21/49 
  Updating   : libgudev1-219-42.el7_4.10.x86_64                                                                                                               22/49 
  Updating   : systemd-sysv-219-42.el7_4.10.x86_64                                                                                                            23/49 
  Updating   : systemd-python-219-42.el7_4.10.x86_64                                                                                                          24/49 
  Updating   : dracut-config-rescue-033-502.el7_4.1.x86_64                                                                                                    25/49 
  Updating   : dracut-network-033-502.el7_4.1.x86_64                                                                                                          26/49 
  Cleanup    : policycoreutils-python-2.2.5-11.el7.x86_64                                                                                                     27/49 
  Cleanup    : libgudev1-208-11.el7.x86_64                                                                                                                    28/49 
  Cleanup    : systemd-python-208-11.el7.x86_64                                                                                                               29/49 
  Cleanup    : initscripts-9.49.17-1.el7.x86_64                                                                                                               30/49 
  Cleanup    : selinux-policy-targeted-3.12.1-153.el7.noarch                                                                                                  31/49 
  Cleanup    : selinux-policy-3.12.1-153.el7.noarch                                                                                                           32/49 
  Cleanup    : dracut-network-033-161.el7.x86_64                                                                                                              33/49 
  Cleanup    : dracut-config-rescue-033-161.el7.x86_64                                                                                                        34/49 
  Cleanup    : systemd-sysv-208-11.el7.x86_64                                                                                                                 35/49 
  Cleanup    : policycoreutils-2.2.5-11.el7.x86_64                                                                                                            36/49 
  Cleanup    : dracut-033-161.el7.x86_64                                                                                                                      37/49 
  Cleanup    : systemd-208-11.el7.x86_64                                                                                                                      38/49 
  Cleanup    : setools-libs-3.3.7-46.el7.x86_64                                                                                                               39/49 
  Cleanup    : systemd-libs-208-11.el7.x86_64                                                                                                                 40/49 
  Cleanup    : libselinux-utils-2.2.2-6.el7.x86_64                                                                                                            41/49 
  Cleanup    : glib2-2.36.3-5.el7.x86_64                                                                                                                      42/49 
  Cleanup    : libselinux-python-2.2.2-6.el7.x86_64                                                                                                           43/49 
  Cleanup    : libsemanage-python-2.1.10-16.el7.x86_64                                                                                                        44/49 
  Cleanup    : libsemanage-2.1.10-16.el7.x86_64                                                                                                               45/49 
  Cleanup    : libselinux-2.2.2-6.el7.x86_64                                                                                                                  46/49 
  Cleanup    : libsepol-2.1.9-3.el7.x86_64                                                                                                                    47/49 
  Cleanup    : kmod-14-9.el7.x86_64                                                                                                                           48/49 
  Cleanup    : libseccomp-2.1.1-2.el7.x86_64                                                                                                                  49/49 
  Verifying  : kmod-20-15.el7_4.7.x86_64                                                                                                                       1/49 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                                                                                                              2/49 
  Verifying  : initscripts-9.49.39-1.el7_4.1.x86_64                                                                                                            3/49 
  Verifying  : libselinux-2.5-11.el7.x86_64                                                                                                                    4/49 
  Verifying  : dracut-033-502.el7_4.1.x86_64                                                                                                                   5/49 
  Verifying  : libsepol-2.5-6.el7.x86_64                                                                                                                       6/49 
  Verifying  : libseccomp-2.3.1-3.el7.x86_64                                                                                                                   7/49 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                                                                                                      8/49 
  Verifying  : systemd-sysv-219-42.el7_4.10.x86_64                                                                                                             9/49 
  Verifying  : pigz-2.3.3-1.el7.centos.x86_64                                                                                                                 10/49 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                                                              11/49 
  Verifying  : 2:container-selinux-2.42-1.gitad8f0f7.el7.noarch                                                                                               12/49 
  Verifying  : dracut-config-rescue-033-502.el7_4.1.x86_64                                                                                                    13/49 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                                                                                                            14/49 
  Verifying  : systemd-libs-219-42.el7_4.10.x86_64                                                                                                            15/49 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                                                                                                       16/49 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                                                                                                            17/49 
  Verifying  : systemd-219-42.el7_4.10.x86_64                                                                                                                 18/49 
  Verifying  : libgudev1-219-42.el7_4.10.x86_64                                                                                                               19/49 
  Verifying  : libsemanage-2.5-8.el7.x86_64                                                                                                                   20/49 
  Verifying  : dracut-network-033-502.el7_4.1.x86_64                                                                                                          21/49 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                                                                                                            22/49 
  Verifying  : docker-ce-18.03.0.ce-1.el7.centos.x86_64                                                                                                       23/49 
  Verifying  : systemd-python-219-42.el7_4.10.x86_64                                                                                                          24/49 
  Verifying  : glib2-2.50.3-3.el7.x86_64                                                                                                                      25/49 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                                                                                                              26/49 
  Verifying  : setools-libs-3.3.7-46.el7.x86_64                                                                                                               27/49 
  Verifying  : dracut-config-rescue-033-161.el7.x86_64                                                                                                        28/49 
  Verifying  : systemd-sysv-208-11.el7.x86_64                                                                                                                 29/49 
  Verifying  : systemd-python-208-11.el7.x86_64                                                                                                               30/49 
  Verifying  : selinux-policy-3.12.1-153.el7.noarch                                                                                                           31/49 
  Verifying  : dracut-network-033-161.el7.x86_64                                                                                                              32/49 
  Verifying  : dracut-033-161.el7.x86_64                                                                                                                      33/49 
  Verifying  : libselinux-utils-2.2.2-6.el7.x86_64                                                                                                            34/49 
  Verifying  : glib2-2.36.3-5.el7.x86_64                                                                                                                      35/49 
  Verifying  : initscripts-9.49.17-1.el7.x86_64                                                                                                               36/49 
  Verifying  : systemd-libs-208-11.el7.x86_64                                                                                                                 37/49 
  Verifying  : libsemanage-2.1.10-16.el7.x86_64                                                                                                               38/49 
  Verifying  : libseccomp-2.1.1-2.el7.x86_64                                                                                                                  39/49 
  Verifying  : libsepol-2.1.9-3.el7.x86_64                                                                                                                    40/49 
  Verifying  : selinux-policy-targeted-3.12.1-153.el7.noarch                                                                                                  41/49 
  Verifying  : libselinux-2.2.2-6.el7.x86_64                                                                                                                  42/49 
  Verifying  : kmod-14-9.el7.x86_64                                                                                                                           43/49 
  Verifying  : policycoreutils-2.2.5-11.el7.x86_64                                                                                                            44/49 
  Verifying  : libgudev1-208-11.el7.x86_64                                                                                                                    45/49 
  Verifying  : libselinux-python-2.2.2-6.el7.x86_64                                                                                                           46/49 
  Verifying  : libsemanage-python-2.1.10-16.el7.x86_64                                                                                                        47/49 
  Verifying  : systemd-208-11.el7.x86_64                                                                                                                      48/49 
  Verifying  : policycoreutils-python-2.2.5-11.el7.x86_64                                                                                                     49/49 

Installed:
  docker-ce.x86_64 0:18.03.0.ce-1.el7.centos                                                                                                                        

Dependency Installed:
  container-selinux.noarch 2:2.42-1.gitad8f0f7.el7                                         pigz.x86_64 0:2.3.3-1.el7.centos                                        

Updated:
  dracut.x86_64 0:033-502.el7_4.1                                               initscripts.x86_64 0:9.49.39-1.el7_4.1                                              

Dependency Updated:
  dracut-config-rescue.x86_64 0:033-502.el7_4.1              dracut-network.x86_64 0:033-502.el7_4.1             glib2.x86_64 0:2.50.3-3.el7                      
  kmod.x86_64 0:20-15.el7_4.7                                libgudev1.x86_64 0:219-42.el7_4.10                  libseccomp.x86_64 0:2.3.1-3.el7                  
  libselinux.x86_64 0:2.5-11.el7                             libselinux-python.x86_64 0:2.5-11.el7               libselinux-utils.x86_64 0:2.5-11.el7             
  libsemanage.x86_64 0:2.5-8.el7                             libsemanage-python.x86_64 0:2.5-8.el7               libsepol.x86_64 0:2.5-6.el7                      
  policycoreutils.x86_64 0:2.5-17.1.el7                      policycoreutils-python.x86_64 0:2.5-17.1.el7        selinux-policy.noarch 0:3.13.1-166.el7_4.9       
  selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9        setools-libs.x86_64 0:3.3.8-1.1.el7                 systemd.x86_64 0:219-42.el7_4.10                 
  systemd-libs.x86_64 0:219-42.el7_4.10                      systemd-python.x86_64 0:219-42.el7_4.10             systemd-sysv.x86_64 0:219-42.el7_4.10            

Complete!
[root@wpg-jens01 system]# docker -v
Docker version 18.03.0-ce, build 0520e24
[root@wpg-jens01 system]# systemctl start docker
[root@wpg-jens01 system]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2018-03-29 10:22:54 CST; 6s ago
     Docs: https://docs.docker.com
 Main PID: 31867 (dockerd)
   Memory: 36.0M
   CGroup: /system.slice/docker.service
           ├─31867 /usr/bin/dockerd
           └─31872 docker-containerd --config /var/run/docker/containerd/containerd.toml

Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.444516369+08:00" level=info msg="[graphdriver] using prior storage driver...cemapper"
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.481159100+08:00" level=info msg="Graph migration to content-addressabilit... seconds"
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.481507372+08:00" level=warning msg="mountpoint for pids not found"
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.482531342+08:00" level=info msg="Loading containers: start."
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.560204029+08:00" level=info msg="Default bridge (docker0) is assigned wit... address"
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.614674591+08:00" level=info msg="Loading containers: done."
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.624857166+08:00" level=info msg="Docker daemon" commit=0520e24 graphdrive...8.03.0-ce
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.625041676+08:00" level=info msg="Daemon has completed initialization"
Mar 29 10:22:54 wpg-jens01.novalocal dockerd[31867]: time="2018-03-29T10:22:54.640550260+08:00" level=info msg="API listen on /var/run/docker.sock"
Mar 29 10:22:54 wpg-jens01.novalocal systemd[1]: Started Docker Application Container Engine.
Hint: Some lines were ellipsized, use -l to show in full.
[root@wpg-jens01 system]# 
```

## 升级Docker CE
  下载较新的软件包文件并重复安装，使用yum -y upgrade，并指向新文件。

## 卸载 Docker CE
  $ sudo yum remove docker-ce

  $ sudo rm -rf /var/lib/docke

## docker 代理配置
### 代理配置方法
```
该方法是持久化的，修改后会一直生效。该方法覆盖了默认的docker.service文件
1. 为docker服务创建一个内嵌的systemd目录
$ mkdir -p /etc/systemd/system/docker.service.d

2. 创建/etc/systemd/system/docker.service.d/http-proxy.conf文件，并添加HTTP_PROXY环境变量。其中[proxy-addr]和[proxy-port]分别改成实际情况的代理地址和端口：

[Service]
Environment="HTTP_PROXY=http://[proxy-addr]:[proxy-port]/" "HTTPS_PROXY=https://[proxy-addr]:[proxy-port]/"

3. 如果还有内部的不需要使用代理来访问的Docker registries，那么嗨需要制定NO_PROXY环境变量：

[Service]
Environment="HTTP_PROXY=http://[proxy-addr]:[proxy-port]/" "HTTPS_PROXY=https://[proxy-addr]:[proxy-port]/" "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com"

4. 更新配置：
$ systemctl daemon-reload

5. 重启Docker服务：
$ systemctl restart docker
```

### 具体配置
```bash
[root@wpg-jens01 system]# docker search activemq
^C
[root@wpg-jens01 system]# mkdir -p /etc/systemd/system/docker.service.d
[root@wpg-jens01 system]# touch /etc/systemd/system/docker.service.d/http-proxy.conf
[root@wpg-jens01 system]# vim /etc/systemd/system/docker.service.d/http-proxy.conf
[root@wpg-jens01 system]# cd /etc/systemd/system/docker.service.d/
[root@wpg-jens01 docker.service.d]# cat http-proxy.conf 
[Service]
Environment="HTTP_PROXY=http://10.0.0.111:3128" "HTTPS_PROXY=http://10.0.0.111:3128" "NO_PROXY=10.0.0.10,10.0.0.11,10.0.0.19,10.0.0.25,10.0.0.26,10.0.0.27"
[root@wpg-jens01 docker.service.d]#
[root@wpg-jens01 docker.service.d]# systemctl daemon-reload
[root@wpg-jens01 docker.service.d]# systemctl restart docker
[root@wpg-jens01 docker.service.d]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/docker.service.d
           └─http-proxy.conf
   Active: active (running) since Thu 2018-03-29 11:54:39 CST; 13s ago
     Docs: https://docs.docker.com
 Main PID: 33420 (dockerd)
   Memory: 35.4M
   CGroup: /system.slice/docker.service
           ├─33420 /usr/bin/dockerd
           └─33425 docker-containerd --config /var/run/docker/containerd/containerd.toml

Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.516716117+08:00" level=info msg="[graphdriver] using prior storage driver: devicemapper"
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.521834528+08:00" level=info msg="Graph migration to content-addressability took 0.00 seconds"
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.522155071+08:00" level=warning msg="mountpoint for pids not found"
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.522801440+08:00" level=info msg="Loading containers: start."
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.627377593+08:00" level=info msg="Default bridge (docker0) is assigned with an IP address 172.1...IP address"
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.668555742+08:00" level=info msg="Loading containers: done."
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.679222523+08:00" level=info msg="Docker daemon" commit=0520e24 graphdriver(s)=devicemapper ver...=18.03.0-ce
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.679325168+08:00" level=info msg="Daemon has completed initialization"
Mar 29 11:54:39 wpg-jens01.novalocal systemd[1]: Started Docker Application Container Engine.
Mar 29 11:54:39 wpg-jens01.novalocal dockerd[33420]: time="2018-03-29T11:54:39.691368355+08:00" level=info msg="API listen on /var/run/docker.sock"
Hint: Some lines were ellipsized, use -l to show in full.
[root@wpg-jens01 docker.service.d]#
[root@wpg-jens01 docker.service.d]# docker search mysql
NAME                                                   DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
mysql                                                  MySQL is a widely used, open-source relation…   5757                [OK]                
mariadb                                                MariaDB is a community-developed fork of MyS…   1859                [OK]                
mysql/mysql-server                                     Optimized MySQL Server Docker images. Create…   397                                     [OK]
zabbix/zabbix-server-mysql                             Zabbix Server with MySQL database support       92                                      [OK]
hypriot/rpi-mysql                                      RPi-compatible Docker Image with Mysql          79                                      
centurylink/mysql                                      Image containing mysql. Optimized to be link…   59                                      [OK]
zabbix/zabbix-web-nginx-mysql                          Zabbix frontend based on Nginx web-server wi…   48                                      [OK]
tutum/mysql                                            Base docker image to run a MySQL database se…   31                                      
1and1internet/ubuntu-16-nginx-php-phpmyadmin-mysql-5   ubuntu-16-nginx-php-phpmyadmin-mysql-5          30                                      [OK]
centos/mysql-57-centos7                                MySQL 5.7 SQL database server                   23                                      
mysql/mysql-cluster                                    Experimental MySQL Cluster Docker images. Cr…   19                                      
schickling/mysql-backup-s3                             Backup MySQL to S3 (supports periodic backup…   16                                      [OK]
linuxserver/mysql                                      A Mysql container, brought to you by LinuxSe…   14                                      
bitnami/mysql                                          Bitnami MySQL Docker Image                      13                                      [OK]
zabbix/zabbix-proxy-mysql                              Zabbix proxy with MySQL database support        12                                      [OK]
centos/mysql-56-centos7                                MySQL 5.6 SQL database server                   8                                       
openshift/mysql-55-centos7                             DEPRECATED: A Centos7 based MySQL v5.5 image…   6                                       
circleci/mysql                                         MySQL is a widely used, open-source relation…   4                                       
dsteinkopf/backup-all-mysql                            backup all DBs in a mysql server                3                                       [OK]
frodenas/mysql                                         A Docker Image for MySQL                        2                                       [OK]
ansibleplaybookbundle/mysql-apb                        An APB which deploys RHSCL MySQL                0                                       [OK]
openzipkin/zipkin-mysql                                Mirror of https://quay.io/repository/openzip…   0                                       
cloudfoundry/cf-mysql-ci                               Image used in CI of cf-mysql-release            0                                       
cloudposse/mysql                                       Improved `mysql` service with support for `m…   0                                       [OK]
astronomerio/mysql-sink                                MySQL sink                                      0                                       [OK]
[root@wpg-jens01 docker.service.d]#
```

注意：对于新创建的unit文件或，修改了的unit文件，要通知systemd重载此配置文件；

systemctl  daemon-reload


