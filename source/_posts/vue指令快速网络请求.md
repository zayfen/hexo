---
title: Vue 通过指令实现快速的网络请求
author: zayfen
date: 2021/01/29
tags:
  - web
  - vue
categories:
  - web
archives:
  - web
---

# Vue 通过指令实现快速的网络请求

开发 Vue 应用，不可避免的会有很多的后台数据需要请求。传统的请求方式都是如下这种：

```javascript
// 拉取用户列表
Api.fetchUserList(payload)
  .then((res) => {
    if (res.code === 0) {
      const userList = res.data;
    } else {
      // do some thing
    }
  })
  .catch((err) => {
    // do something
  });
```

在一个 Vue 文件中只存在少量的一两个接口请求还是能忍受的，但是一旦接口多了起来，网络请求的代码就可能占用了整个 vue 文件一大半的代码量。

那么有没有办法简化这种请求呢？

Vue 中为了简单的绑定 Properties 和事件而实现了**指令**的概念，分别使用`v-bind`绑定 Properties, 使用`v-on`绑定事件。那么我们同样可以使用指令来简化网络请求的代码。

<!--  more -->

## Vue 指令介绍

vue 指令(directive)包含 2 部分的内容，一个是指令的名字（字符串），一个是指令的对象，对象中包含了 `bind`, `inserted`, `update`，`componentUpdated` 和`unbind`这 5 个钩子函数。

钩子函数都有几个参数`el`, `binding`,`vnode`, `oldVnode`。

- el: 指令绑定的元素，可以直接用来操作 DOM 对象。

- binding：一个对象，包含指令的一些属性信息。比如通过这个例子来描述`<div v-api:fetchUserList.sync="response"></div>`

| 属性名     | 属性描述                                                           |
| ---------- | ------------------------------------------------------------------ |
| name       | 指令名, 即例子中的 api                                             |
| value      | 指令的绑定值。即 response 的值                                     |
| oldValue   | 指令绑定的前一个值，仅在 update 和 componentUpdated 的狗子中有用   |
| expression | 字符形式的表达式。比如 v-sum="1+1"的 binding.expression 就是 “1+1” |
| arg        | 即例子中的 fetchUserList                                           |
| modifiers  | 即例子中的 { sync: true }                                          |

- vnode: Vue 编译生成的虚拟节点
- oldVnode： 上一个虚拟节点，仅在 update 和 componentUpdated 的钩子函数中有用

## V-API 指令的实现思路

在需要数据的页面上使用 v-api 指令。v-api 指令会指定接口名字和接口数据接收对象，v-api-param 会指定接口参数。在 inserted 的钩子函数中，通过 binding 对象获取接口名和接口参数，执行接口调用，在接口返回之后将数据设置在 response 中。

## V-API 指令的实现代码

```javascript
import Vue from "vue";
// Api对象中有所有的接口请求函数
import * as Api from "../api/index";

// <component  v-api:module.apiName="resultReceiver"
// v-api:apiName="resultReceiver"
Vue.directive("api", {
  inserted: function (el, binding, vnode, oldNode) {
    let fields = [];
    const moduleName = binding.arg;
    if (moduleName) {
      fields.push(moduleName);
    }

    let methodName = "";
    const modifiers = binding.modifiers;
    if (Object.keys(modifiers).length > 0) {
      methodName = Object.keys(modifiers)[0]; // first key as method name
    }
    if (methodName) {
      fields.push(methodName);
    }

    const apiParamDirective = vnode.data.directives.find(
      (item) => item.name === "api-param"
    );
    const param = apiParamDirective ? apiParamDirective.value : void 0;

    // resolve final request caller
    // const Api = require('../api/index')
    let fn = fields.length > 0 ? Api[fields.shift()] : void 0;
    while (fields.length > 0) {
      let field = fields.shift();
      fn = fn[field];
    }
    if (!fn) {
      throw new Error(
        `Error On v-api.js: can't find method ${moduleName}.${methodName} in Api`
      );
    }

    // do request here
    const vueInstance = vnode.context;
    fn(param)?.then((res) => {
      if (res.code === 0) {
        // 请求成功 设置返回的数数据
        vueInstance.$set(vueInstance.$data, binding.expression, res);
      } else {
        // error message
        const errMsg = res.message;
        vueInstance.$message.error(errMsg);
      }
    });
  },
});

// v-api-param=args
Vue.directive("api-param", {
  inserted: function (el, binding, vnode, oldNode) {
    // watch args, if args update, then execute v-api.inserted function to request data again
    const vueInstance = vnode.context;
    console.log("v-app.js watch ", binding.expression);
    vueInstance.$watch(
      binding.expression,
      function (newVal, oldVal) {
        // TODO: 增加节流  50ms
        const apiDirective = vnode.data.directives.find(
          (item) => item.name === "api" || item.name === "api-ex"
        );
        const _binding = {
          name: apiDirective.name,
          arg: apiDirective.arg,
          value: apiDirective.value,
          expression: apiDirective.expression,
          modifiers: apiDirective.modifiers,
        };
        apiDirective.def.inserted(el, _binding, vnode, oldNode);
      },
      { deep: true }
    );
  },
});
```

## V-API 指令 DEMO

```html
<template>
  <div v-api:fetUserList="users" v-api-param="userListParam">
    <ul v-for="(user, index) in users" :key="index">
      <li>{{user}]</li>
    </ul>
  </div>
</template>
<script>
  export default {
    data() {
      return {
        users: [],
        userListParam: { page: 1, pageSize: 100 },
      };
    },
  };
</script>
```
