-----------

title: Vue通过指令实现快速的网络请求

author: zayfen

date: 2021/01/29

tags:

	- vue
	- web

categories:

 - web

archives:

​	- web

---------------



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



## Vue指令介绍

vue指令(directive)包含2部分的内容，一个是指令的名字（字符串），一个是指令的对象，对象中包含了 `bind`, `inserted`, `update`，`componentUpdated` 和`unbind`这5个钩子函数。

