---
title: java+mysql递归拼接树形JSON列表
date: 2017-11-08 07:02:07
tags:
---
在做java web项目时，前端控件例如国家-省-市-区-县等树形列表，常常需要多级树形json数据，例如：
<!-- more -->
```json
[
  {
    "name": "商品目录",
    "pid": "-1",
    "id": "1",
    "children": [
      {
        "name": "日用品",
        "pid": "1",
        "id": "11",
        "children": [
          {
            "name": "洗发水",
            "pid": "11",
            "id": "111",
            "children": [
                {
                    "name": "霸王",
                    "pid": "111",
                    "id": "1111",
                    "children": []
                }
            ]
          }
        ]
      },
      {
        "name": "食品",
        "pid": "1",
        "id": "12",
        "children": []
      }
    ]
  }
]
```

java+mysql递归拼接树形JSON列表
http://blog.csdn.net/qq12547345/article/details/72765889


vue+vue-router+vuex,动态路由:
http://blog.csdn.net/s8460049/article/details/61190709