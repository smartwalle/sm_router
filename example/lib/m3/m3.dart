import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 带有 URL 参数的 push
void main() {
  RouteCenter.handle("/", (ctx) => const M3View1());
  RouteCenter.handle("/m3/view2", (ctx) {
    var message = ctx.queryParam.get("message");
    return M3View2(message: message);
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: RouteCenter.routeInformationParser,
      routerDelegate: RouteCenter.routerDelegate,
    );
  }
}

class M3View1 extends StatelessWidget {
  const M3View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M3 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m3/view2 (有参数)"),
              onPressed: () {
                RouteCenter.push("/m3/view2?message=这是来自 /m3/view1 的参数");
              },
            ),
            TextButton(
              child: const Text("进入 /m3/view2 (没有参数)"),
              onPressed: () {
                RouteCenter.push("/m3/view2");
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class M3View2 extends StatelessWidget {
  final String? message;

  const M3View2({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M3 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m3/view1"),
              onPressed: () {
                RouteCenter.maybePop();
              },
            ),
            message != null ? Text("收到参数: $message") : const Text("没有收到参数"),
          ],
        ),
      ),
    );
  }
}
