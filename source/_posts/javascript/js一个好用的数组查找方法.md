---
title: js一个好用的数组查找方法
date: 2018-05-29 15:09:54
tags: javascript
---
https://blog.csdn.net/chemmuxin1993/article/details/53747696
<!-- more -->

## 示例
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <script>
        /**
         * 
         * 查找数组，返回匹配到的第一个index
         * 
         * @param array 被查找的数组
         * @param feature 查找特征 或者为一个具体值，用于匹配数组遍历的值，或者为一个对象，表明所有希望被匹配的key-value
         * @param or boolean 希望命中feature全部特征或者只需命中一个特征，默认true
         * 
         * @return 数组下标  查找不到返回-1
         */
        function findArray(array, feature, all = true) {
            for(let index in array){
                let cur = array[index];
                if(feature instanceof Object){
                    let allRight = true;
                    for(let key in feature){
                        let value = feature[key];
                        if(cur[key] == value && !all) return index;
                        if(all && cur[key] != value){
                            allRight = false;
                            break;
                        }
                    }
                    if(allRight) return index;
                }else{
                    if(cur == feature){
                        return index;
                    }
                }
            }
            return -1;
        }

        //简单值数组
        var arr = [0,1,2,3,4,5];
        var index = findArray(arr, 5);
        console.log(index);              // 5
        console.log(findArray(arr, 9));  // -1

        arr = [0,6,6,3,4,5];
        console.log(findArray(arr, 6));  // 1

        //对象数组
        var arr = [{
            id : '2',
            name : 'cm5x',
            age : 23
        },{
            id : '1',
            name : 'cmx',
            age : 23
        },{
            id : '5',
            name : '习大大',
            age : 60
        }];
        console.log(arr);

        //单个特征查找
        console.log(findArray(arr, {id: '5'}));  // 2

        //多个特征全满足查找
        console.log(findArray(arr, {id: '1', name: 'cmx',age:23})); //1

        //多个特征单个满足查找（false,表示需要全部满足）
        console.log(findArray(arr, {id: '5', name: '习大大',age:60},false));  //0

    </script>
</head>
<body>
</body>
</html>
```
