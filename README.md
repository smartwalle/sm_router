Flutter Navigator 2.0 路由管理。

## 快速使用
#### 注册路由
```dart
RouteCenter.handle("/", (ctx) => const Home());
RouteCenter.handle("/test", (ctx) => const TestView());
```

#### 设置 MaterialApp 的 routeInformationParser 和 routerDelegate
```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: RouteCenter.routeInformationParser,
      routerDelegate: RouteCenter.routerDelegate,
    );
  }
}
```

#### 跳转到指定路由
```dart
RouteCenter.push("/test?a=10");
```

## Context
RouteContext 对象主要提供以下信息：
* **routeName**：路由名称。例如: /test；
* **requestName**：请求名称，包含路由查询参数。例如: /test?a=10；
* **arguments**：路由参数，即 pushXXX 系列方法中提供的 arguments 参数（建议只在在非 web 应用中使用）；
* **queryParam**：路由查询参数，来源于 pushXXX 系列方法中的 routeName 参数，让 routeName 像 URL 一样可以指定参数(和 arguments 参数相比，在 web 应用中，param 参数不会因浏览器刷新而丢失)。例如: ctx.queryParam.get("a")；
* **data**：自定义数据，可以从路由拦截器传递一些信息到路由处理器；

## 拦截器
注册路由方法会返回一个路由节点对象，可以调用该路由节点对象的 use 方法为该路由添加路由拦截器。

一个路由可以添加多个拦截器，访问该路由时，其拦截器将被依次被调用，所有拦截器都通过之后才会执行路由处理器。

拦截器如果返回一个有效的 Redirect 对象，则表示本次访问被拦截，将显示该 Redirect 相关的页面，该路由后续的拦截器和处理器将不会被执行。

拦截器返回 null 对象，表示本次访问通过该拦截器的验证。

```dart 
RouteCenter.handle("/profile", (ctx) => const YourView()).use((ctx) {
    if (isLogin) {
        // 已登录，不需要拦截
        return ;
    }
    // 未登录，需要显示登录页面
    return Redirect("/login");
});
```

### 全局拦截器

可以调用 RouteCenter.use() 方法添加全局拦截器，全局拦截器作用于所有的路由。

访问一个路由的时候，将先执行全局拦截器，然后再执行路由的拦截器。