import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

final _m3Route = RouteCenter();

class M3Home extends StatelessWidget {
  M3Home({Key? key}) : super(key: key) {
    _m3Route.handle("/", (ctx) => const M3View1());
    _m3Route.handle("/m3/view2", (ctx) {
      var message = ctx.queryParam.get("message");
      return M3View2(message: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _m3Route.routeInformationParser,
      routerDelegate: _m3Route.routerDelegate,
    );
  }
}

class M3View1 extends StatelessWidget {
  const M3View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Routes.pop();
          },
        ),
        title: const Text("M3 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m3/view2 (有参数)"),
              onPressed: () {
                _m3Route.push("/m3/view2?message=这是来自 /m3/view1 的参数");
              },
            ),
            TextButton(
              child: const Text("进入 /m3/view2 (没有参数)"),
              onPressed: () {
                _m3Route.push("/m3/view2");
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
                _m3Route.pop();
              },
            ),
            message != null ? Text("收到参数: $message") : const Text("没有收到参数"),
          ],
        ),
      ),
    );
  }
}
