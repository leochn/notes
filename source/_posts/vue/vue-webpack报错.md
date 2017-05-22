---
title: vue-webpack报错
date: 2017-05-19 08:43:27
tags: [vue,webpack]
---
## webpack报错：Cannot assign to read only property 'exports' of object '#<Object>'

在做一个demo的时候,运行 npm run dev,发现在浏览器中报错,如下：<!--more-->

![webpack报错](/assets/images/vue/vue-webpack-import-error.png)

通过百度,在github中发现:
The code above is ok. You can mix require and export. You can't mix import and module.exports.
意思是import 和 module.exports 混用了。
查看代码,发现在xxx.js文件中有一段如下代码:

```
import {normalTime} from './timeFormat';

module.exports={
    normalTime
};
```

于是乎,修改代码如下:

```
import {normalTime} from './timeFormat';

export default{
    normalTime
};
```

问题得到了解决!
查资料发现:require和module.exports以及import和export default 不能混用.
