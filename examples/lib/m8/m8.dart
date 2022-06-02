import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// pushRoutesAndRemoveUntil 和 pushRoutesAndRemoveAll
void main() {
  RouteCenter.handle("/", (ctx) => const M8View1());
  RouteCenter.handle("/m8/view2", (ctx) => const M8View2());
  RouteCenter.handle("/m8/view21", (ctx) => const M8View21());
  RouteCenter.handle("/m8/view22", (ctx) => const M8View22());
  RouteCenter.handle("/m8/view23", (ctx) => const M8View23());

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

class M8View1 extends StatelessWidget {
  const M8View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m8/view2 (pushRoutesAndRemoveUntil)"),
              onPressed: () {
                RouteCenter.push("/m8/view2");
              },
            ),
            TextButton(
              child: const Text("进入 /m8/view3 (pushRoutesAndRemoveAll)"),
              onPressed: () {
                RouteCenter.push("/m8/view3");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View2 extends StatelessWidget {
  const M8View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("下一页面"),
              onPressed: () {
                RouteCenter.push("/m8/view21");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View21 extends StatelessWidget {
  const M8View21({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View2-1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("下一页面"),
              onPressed: () {
                var routes = [
                  RouteName("/m8/view22"),
                  RouteName("/m8/view23"),
                ];
                RouteCenter.pushRoutesAndRemoveUntil(routes, (ctx) => ctx.requestName == "/m8/view2");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View22 extends StatelessWidget {
  const M8View22({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View2-2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("直接返回 M8 View2，不会显示 M8 View2-1"),
              onPressed: () {
                RouteCenter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View23 extends StatelessWidget {
  const M8View23({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View2-3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 M8 View2-2"),
              onPressed: () {
                RouteCenter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
