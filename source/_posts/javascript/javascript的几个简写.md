---
title: javascript的几个简写
date: 2017-08-03 13:30:40
tags: javascript
---
## 三元操作符
当想写if...else语句时，使用三元操作符来代替
```js
const x = 20;
let answer;

if (x > 30) {
    answer = 'is greater';
} else {
    answer = 'is lesser';
}
console.log(answer)

answer = x > 10 ? 'is greater' : 'is lesser';
console.log(answer)
```

## 短路求值简写方式
当给一个变量分配另一个值时，想确定源始值不是null，undefined或空值。可以写撰写一个多重条件的if语句.

```js
let variable1;
let variable2;
if (variable1 !== null || variable1 !== undefined || variable1 !== '') {
    variable2 = variable1;
}
console.log(variable2);   // undefined

let variable3 = variable1  || 'new'; // 左边为真,就不执行右边了;左边为假,才会执行右边.
console.log(variable3);   // new

let variable4 = variable1  && 'new'; // 左边为真,才会执行右边;左边为假,就不执行右边了.
console.log(variable4);   // undefined
```

## if存在条件简写方法
```js
if (likeJavaScript === true){}
// 简写如下:
if (likeJavaScript){}
```

## avaScript循环简写方法
```js
for (let i = 0; i < allImgs.length; i++)
//简写：
for (let index in allImgs)
```

```js
let allImgs = ['hello','baby',3];
for (let i = 0; i < allImgs.length; i++){
    console.log(allImgs[i]);
}
for (let index in allImgs){
    console.log(allImgs[index]);
}
```
