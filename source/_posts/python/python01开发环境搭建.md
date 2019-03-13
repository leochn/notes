---
title: python01开发环境搭建
date: 2018-08-29 07:15:45
tags: python
---
## Python的介绍   
    Python是解释型语言

    Python（英国发音：/ˈpaɪθən/ 美国发音：/ˈpaɪθɑːn/），是一种广泛使用的高级编程语言，属于通用型编程语言，由吉多·范罗苏姆创造。
    第一版发布于1991年，可以视之为一种改良（加入一些其他编程语言的优点，如面向对象）的LISP。
    作为一种解释型语言，Python的设计哲学强调代码的可读性和简洁的语法（尤其是使用空格缩进划分代码块，而非使用大括号或者关键词）。
    相比于C++或Java，Python让开发者能够用更少的代码表达想法。不管是小型还是大型程序，该语言都试图让程序的结构清晰明了。 

    Life is short you need Python （人生苦短，我用Python）    

    Python的用途：
        WEB应用
            Facebook 豆瓣 。。。
        爬虫程序
        科学计算
        自动化运维
        大数据（数据清洗）
        云计算
        桌面软件/游戏
        人工智能
        。。。     

<!-- more -->

## Python开发环境搭建
    开发环境搭建就是安装Python的解释器
    Python的解释器分类：
        CPython（官方）
            用c语言编写的Python解释器
        PyPy
            用Python语言编写的Python解释器
        IronPython
            用.net编写的Python解释器
        Jython
            用Java编写的Python解释器

    步骤：
        1.下载安装包 python-3.6.5.exe
            - 3.x
            - 2.x    
        2.安装（傻瓜式安装） 
        3.打开命令行窗口，输入python 出现如下内容
            Python 3.6.5 (v3.6.5:f59c0932b4, Mar 28 2018, 16:07:46) [MSC v.1900 32 bit (Intel)] on win32
            Type "help", "copyright", "credits" or "license" for more information.
            >>>    

## Python的交互界面
    当我们通过命令行来输入Python，所进入到的界面就是Python的交互界面
    结构：
        版本和版权声明：
        Python 3.6.5 (v3.6.5:f59c0932b4, Mar 28 2018, 16:07:46) [MSC v.1900 32 bit (Intel)] on win32
        Type "help", "copyright", "credits" or "license" for more information.

        命令提示符：
        >>>

        在命令提示符后可以直接输入Python的指令！输入完的指令将会被Python的解释器立即执行！

        安装Python的同时，会自动安装一个Python的开发工具IDLE，通过IDLE也可以进入到交互模式
        但是不同的是，在IDLE中可以通过TAB键来查看语句的提示。
        IDLE实际上就是一个交互界面，但是他可以有一些简单的提示，并且可以将代码保存

    交互模式只能你输入一行代码，它就是执行一行，所以他并不适用于我们日常的开发！ 
        仅可以用来做一些日常的简单的测试！   

    我们一般会将Python代码编写到一个py文件中，然后通过python指令来执行文件中的代码

    练习：
        自己尝试创建一个py文件，并向文件中写入python打印语句（print...） 
            然后执行该文件。
        如果你的系统的扩展名无法修改，请尝试自行baidu！

## Python和Sublime的整合
    1.在Sublime中执行Python代码，ctrl + b 自动在Sublime内置的控制台中执行  
        这种执行方式，在某些版本的Sublime中对中文支持不好，并且不能使用input()函数

    2.使用SublimeREPL来运行python代码    
        安装完成，设置快捷键，希望按f5则自动执行当前的Python代码
        { 
            "keys": ["f5"], 
            "caption": "SublimeREPL:Python",
            "command": "run_existing_window_command", 
            "args":{
                "id": "repl_python_run",
                "file": "config/Python/Main.sublime-menu"
            }
        },

### 详细步骤

在菜单中选择Package Control：Install Package

在命令输入框中输入： SublimeREPL，进行安装。

点击菜单啦【Tools】->【SublimeREPL】->【python】，查看安装的插件，如图所示

设置快捷键：点击菜单栏【Preferences】->【Key Bindings】

输入代码如下并保存：

    { 
        "keys": ["f5"], 
        "caption": "SublimeREPL:Python",
        "command": "run_existing_window_command", 
        "args":{
            "id": "repl_python_run",
            "file": "config/Python/Main.sublime-menu"
        }
    },

