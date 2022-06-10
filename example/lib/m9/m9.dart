import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// Redirect
void main() {
  RouteCenter.handle("/", (ctx) => const M1View1());
  RouteCenter.handle("/m9/view2", (ctx) => const M1View2()).use((ctx) {
    return const Redirect("/m9/view3");
  });
  RouteCenter.handle("/m9/view3", (ctx) => const M1View3());

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
        title: const Text("M9 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m9/view2 (会重定向到 /m9/view3)"),
              onPressed: () {
                RouteCenter.push("/m9/view2").then((value) {
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
        title: const Text("M9 View2"),
      ),
      body: Center(
        child: Column(
          children: const [
            Text("不会显示本页面"),
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
        title: const Text("M9 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回"),
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
