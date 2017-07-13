---
title: 08-lesss引入(importing)
date: 2017-07-14 06:06:32
tags: less
---
## lesss引入
什么是引入:你可以引入一个或多个.less文件,然后这个文件中的所有变量都可以在当前的less项目中使用.
<!-- more -->
### 小demo
main.less 文件:
```
@wp:960px;
```

style.less文件:
```
@import "main.less";
.centen{
    width:@wp;
}
```

编译后:
```
.centen{
    width:960px;
}
```

### 可带参数
1.once: 默认,只包含一次.
2.reference: 使用Less文件但不输出.
3.inline: 在输出中包含源文件但不加工它.
4.less: 将文件作为Less文件对象,无论是什么文件扩展名.
5.css: 将文件作为CSS文件对象,无论是什么文件扩展名.
6.multiple: multiple.