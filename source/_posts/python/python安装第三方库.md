---
title: python安装第三方库
date: 2018-09-21 06:16:04
tags: python
---
## python安装第三方库的三种方法

python很强大的一个地方，在于它有大量的第三方库，你不再需要去重新发明轮子了。学会安装和使用这些第三方库是学习python的必备技能。在早期2.7版本的时候安装第三方库是比较麻烦的，因为本身没有集成很多的安装工具，在最新版的拍摄当中，他已经把这些安装的工具集成进去了，所以安装第三方库就会变得方便很多。
<!-- more -->
### 使用pip
大多数库都可以通过pip安装，安装方法为，在命令行窗口输入

pip install libname

libname为库名

某些库通过pip安装不了，可能是因为没有打包上传到pypi中，可以下载安装包之后离线安装，方法是

pip install libpath

libpath为本地安装包地址，这些安装包一般以whl为后缀名。表示python扩展包的windows环境下的二进制文件。

有一个专门下载这种文件的地方http://www.lfd.uci.edu/~gohlke/pythonlibs/，是由加利福尼亚大学的师生为方便python用户使用而建立的，并非官方出品，使用时需自行承担风险。

### 源文件安装
如果下载下来的安装包为带有源文件的压缩包，解压之后，运行setup.py进行安装，

方法是命令行切换到安装包中setup.py文件所在的目录，执行 python setup.py install

### 运行安装包
有些类库提供了双击运行直接安装的安装包，比如python连接mysql数据库的驱动 mysql-connector-python

这些安装包的后缀名为msi或者exe。下载下来之后，双击运行之后就安装好了，前提是要根据python的版本及windows的位数下载对应的安装包，否则安装过程会报错或者直接提示无法安装。

## pip安装Numpy,matplotlib
### pip的简述
Python3.5及其以上版本中自带了pip工具，只需调用即可。

查看pip的信息

![python安装第三方库001](/assets/images/python/python安装第三方库001.png)

### 安装

pip install numpy , 耐心等待，自动安装.

![python安装第三方库002](/assets/images/python/python安装第三方库002.png)

pip install matplotlib

### 测试
```
import numpy as np
import matplotlib.pyplot as plt
x = np.array([1,2,3,4,5,6,7,8])
y = np.array([3,5,7,6,2,6,10,15])
plt.plot(x,y,'r')# 折线 1 x 2 y 3 color
plt.plot(x,y,'g',lw=10)# 4 line w
# 折线 饼状 柱状
x = np.array([1,2,3,4,5,6,7,8])
y = np.array([13,25,17,36,21,16,10,15])
plt.bar(x,y,0.2,alpha=1,color='b')# 5 color 4 透明度 3 0.9
plt.show()
```

运行上面一段代码,出现下图:

![python安装第三方库003](/assets/images/python/python安装第三方库003.png)

### 卸载
pip uninstall numpy
