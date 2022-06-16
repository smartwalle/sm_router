import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 简单 push 和 pop
void main() {
  RouteCenter.handle("/", (ctx) => const M1View1());
  RouteCenter.handle("/m1/view2", (ctx) => const M1View2());
  RouteCenter.handle("/m1/view31", (ctx) => const M1View3());

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

class M1View1 extends StatelessWidget {
  const M1View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M1 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m1/view2"),
              onPressed: () {
                RouteCenter.push("/m1/view2").then((value) {
                  print(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M1View2 extends StatelessWidget {
  const M1View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M1 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m1/view1"),
              onPressed: () {
                RouteCenter.pop("from view2");
              },
            ),
            TextButton(
              child: const Text("进入 /m1/view3"),
              onPressed: () {
                RouteCenter.push("/m1/view3").then((value) {
                  print(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M1View3 extends StatelessWidget {
  const M1View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M1 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m1/view2"),
              onPressed: () {
                RouteCenter.pop("from view3");
              },
            ),
          ],
        ),
      ),
    );
  }
}
