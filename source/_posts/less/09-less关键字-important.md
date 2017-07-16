---
title: 09-less关键字(important)
date: 2017-07-14 06:07:07
tags: less
---
## less关键字(important)
在调用的混合集后面追加 !important 关键字,可以使混合集里面的所有属性都继承.
<!-- more -->
```
<!-- less -->
.foo (@bg: #f5f5f5, @color: #900) {
  background: @bg;
  color: @color;
  font-size: 16px;
  font-weight: 900;
}

.unimportant {
  .foo();
}
.important {
  .foo() !important;
}
<!-- css -->
.unimportant {
  background: #f5f5f5;
  color: #990000;
  font-size: 16px;
  font-weight: 900;
}
.important {
  background: #f5f5f5 !important;
  color: #990000 !important;
  font-size: 16px !important;
  font-weight: 900 !important;
}
```