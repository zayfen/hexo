------
title: Vue通过指令实现快速的网络请求
author: zayfen
date: 2021/01/29
tags:
- web
- vue
categories:
 - web
archives:
 - web
------



# Vue通过指令实现快速的网络请求

开发Vue应用，不可避免的会有很多的后台数据需要请求。传统的请求方式都是如下这种：

```javascript
// 拉取用户列表
Api.fetchUserList(payload).then(res => {
    if (res.code === 0) {
        const userList = res.data
       
    } else {
        // do some thing
    }
}).catch(err => {
    // do something 
})
```

在一个Vue文件中只存在少量的一两个接口请求还是能忍受的，但是一旦接口多了起来，网络请求的代码就可能占用了整个vue文件一大半的代码量。

那么有没有办法简化这种请求呢？



Vue中为了简单的绑定Properties和事件而实现了**指令**的概念，分别使用`v-bind`绑定Properties, 使用`v-on`绑定事件。那么我们同样可以使用指令来简化网络请求的代码。

<!--  more -->

## Vue指令介绍

vue指令(directive)包含2部分的内容，一个是指令的名字（字符串），一个是指令的对象，对象中包含了 `bind`, `inserted`, `update`，`componentUpdated` 和`unbind`这5个钩子函数。



钩子函数都有几个参数`el`, `binding`,`vnode`, `oldVnode`。

* el: 指令绑定的元素，可以直接用来操作DOM对象。

* binding：一个对象，包含指令的一些属性信息。比如通过这个例子来描述`<div v-api:fetchUserList.sync="response"></div>`

| 属性名     | 属性描述                                                     |
| ---------- | ------------------------------------------------------------ |
| name       | 指令名, 即例子中的 api                                       |
| value      | 指令的绑定值。即response的值                                 |
| oldValue   | 指令绑定的前一个值，仅在 update 和 componentUpdated的狗子中有用 |
| expression | 字符形式的表达式。比如 v-sum="1+1"的binding.expression就是 “1+1” |
| arg        | 即例子中的 fetchUserList                                     |
| modifiers  | 即例子中的 { sync: true }                                    |

* vnode: Vue编译生成的虚拟节点
* oldVnode： 上一个虚拟节点，仅在update 和 componentUpdated 的钩子函数中有用

## V-API指令的实现思路

在需要数据的页面上使用v-api指令。v-api指令会指定接口名字和接口数据接收对象，v-api-param会指定接口参数。在inserted的钩子函数中，通过binding对象获取接口名和接口参数，执行接口调用，在接口返回之后将数据设置在response中。



## V-API指令的实现代码

```javascript
Vue.directive('api', {
    inserted (el, binding, vnode, oldVnode) {
		
	}
})


Vue.directive('api-param', {
    inserted (el, binding, vnode, oldVnode) {
        
    }
})
```



## V-API指令DEMO

```html
<template>
    <div 
         v-api:fetUserList="users"
         v-api-param="userListParam"
    >
		<ul v-for="(user, index) in users" :key="index">
            <li>{{user}]</li>
        </ul>
    </div>
</template>
<script>
    export default {
        data () {
            return {
                users: [],
                userListParam: { page: 1, pageSize: 100 }
            }
        }
    }
</script>
```

