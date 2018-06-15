---
title: javascript中的深拷贝和浅拷贝
date: 2017-12-28 13:25:10
tags: javascript
---
## javaScript的变量类型
1.基本类型：
5种基本数据类型Undefined、Null、Boolean、Number 和 String，变量是直接按值存放的，存放在栈内存中的简单数据段，可以直接访问。
<!-- more -->

2.引用类型：
存放在堆内存中的对象，变量保存的是一个指针，这个指针指向另一个位置。当需要访问引用类型（如对象，数组等）的值时，首先从栈中获得该对象的地址指针，然后再从堆内存中取得所需的数据。

## 深拷贝和浅拷贝
JavaScript存储对象都是存地址的，所以浅拷贝会导致 obj1 和obj2 指向同一块内存地址。改变了其中一方的内容，都是在原来的内存上做修改会导致拷贝对象和源对象都发生改变，而深拷贝是开辟一块新的内存地址，将原对象的各个属性逐个复制进去。对拷贝对象和源对象各自的操作互不影响。
```js
var arr1 = [1, 2, 3];
var arr2 = arr1;
arr1[0] = 'change';
console.log('shallow copy: ' + arr1 );  // shallow copy: change,2,3
console.log('shallow copy: ' + arr2 );  // shallow copy: change,2,3
```

## 浅拷贝和深拷贝的区分
首先深复制和浅复制只针对像 Object, Array 这样的复杂对象的。简单来说，浅复制只复制一层对象的属性，而深复制则递归复制了所有层级.
下面是一个简单的浅复制实现:
```js
var obj = { a:1, arr: [2,3] };
var shallowObj = shallowCopy(obj);
function shallowCopy(src) {
  var dst = {};
  for (var prop in src) {
    if (src.hasOwnProperty(prop)) {
      dst[prop] = src[prop];
    }
  }
  return dst;
}
```
因为浅复制只会将对象的各个属性进行依次复制，并不会进行递归复制，而 JavaScript 存储对象都是存地址的，所以浅复制会导致 obj.arr 和 shallowObj.arr 指向同一块内存地址.
导致的结果:
```js
shallowObj.arr[1] // = 3;
obj.arr[1]        // = 3
```

## 浅拷贝的实现
1.简单的引用复制
```js
function shallowClone(copyObj) {
  var obj = {};
  for ( var i in copyObj) {
    obj[i] = copyObj[i];
  }
  return obj;
}
var x = {
  a: 1,
  b: { f: { g: 1 } },
  c: [ 1, 2, 3 ]
};
var y = shallowClone(x);
console.log(y.b.f === x.b.f);     // true

```

2. Object.assign()
Object.assign() 方法可以把任意多个的源对象自身的可枚举属性拷贝给目标对象，然后返回目标对象
```js
var x = {
  a: 1,
  b: { f: { g: 1 } },
  c: [ 1, 2, 3 ]
};
var y = Object.assign({}, x);
console.log(y.b.f === x.b.f);     // true
```

## 深拷贝的实现
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
  <script>
    // 深拷贝...
    var cloneObj = function(obj){
        var str, newobj = obj.constructor === Array ? [] : {};
        if(typeof obj !== 'object'){
            return;
        } else if(window.JSON){
            str = JSON.stringify(obj), //系列化对象
            newobj = JSON.parse(str);  //还原
        } else {
            for(var i in obj){
                newobj[i] = typeof obj[i] === 'object' ? 
                cloneObj(obj[i]) : obj[i]; 
            }
        }
        return newobj;
    };
    var resultData = [{
                  "id": "320800",
                  "parentId": "100000",
                  "name": "江苏省",
                  "children": [{
                      "id": "320801",
                      "parentId": "320800",
                      "name": "江苏省-项目1",
                      "children": [{
                          "id": "QWQWQWWQ",
                          "parentId": "320801",
                          "name": "项目1-泵房1",
                          "children": [{
                              "id": "951372609180696577",
                              "parentId": "320801",
                              "name": "项目1-泵房1-设备1"
                          }, {
                              "id": "951374939439529986",
                              "parentId": "320801",
                              "name": "项目1-泵房1-设备2"
                          }]
                      }, {
                          "id": "951372609180696577",
                          "parentId": "320801",
                          "name": "项目1-泵房2",
                          "children": [{
                              "id": "951372609180696577",
                              "parentId": "320801",
                              "name": "项目1-泵房2-设备1"
                          }, {
                              "id": "951374939439529986",
                              "parentId": "320801",
                              "name": "项目1-泵房2-设备2"
                          }]
                      }]
                  }, {
                      "id": "320801",
                      "parentId": "320800",
                      "name": "江苏省-项目2",
                      "children": [{
                          "id": "951372609180696577",
                          "parentId": "320801",
                          "name": "项目2-泵房1",
                          "children": [{
                              "id": "951372609180696577",
                              "parentId": "320801",
                              "name": "项目2-泵房1-设备1"
                          }, {
                              "id": "951374939439529986",
                              "parentId": "320801",
                              "name": "项目2-泵房1-设备2"
                          }]
                      }, {
                          "id": "951372609180696577",
                          "parentId": "320801",
                          "name": "项目2-泵房2",
                          "children": [{
                              "id": "951372609180696577",
                              "parentId": "320801",
                              "name": "项目2-泵房2-设备1"
                          }, {
                              "id": "951374939439529986",
                              "parentId": "320801",
                              "name": "项目2-泵房2-设备2"
                          }]
                      }]
                  }]
              }]
    var newDataCloneObj = cloneObj(resultData);
    newDataCloneObj[0].id = '12121212';
    newDataCloneObj[0].children[0].id='asd123456'
    newDataCloneObj[0].children[0].children[1].name ='asd123456设备IIIDDD'
    console.log(resultData[0].id);
    console.log(newDataCloneObj[0].id);

    console.log(resultData[0].children[0].id);
    console.log(newDataCloneObj[0].children[0].id);

    console.log(resultData[0].children[0].children[1].name);
    console.log(newDataCloneObj[0].children[0].children[1].name);
  </script>
</head>
<body>
    
</body>
</html>
```

## json对象的深拷贝
```
json对象的深拷贝可以用下面的两条语句实现
JSON.parse(jsonstr);     //可以将json字符串转换成json对象 
JSON.stringify(jsonobj); //可以将json对象转换成json对符串
```

```js
var str = JSON.stringify(resultData);
console.log(str);
var jsonObj = JSON.parse(str)
console.log(jsonObj[0].children[0].children[1].name);
``` 
