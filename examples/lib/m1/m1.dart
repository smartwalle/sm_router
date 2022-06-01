import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 简单 push 和 pop
void main() {
  Routes.handle("/", (ctx) => const M1View1());
  Routes.handle("/m1/view2", (ctx) => const M1View2());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Routes.routeInformationParser,
      routerDelegate: Routes.routerDelegate,
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
                Routes.push("/m1/view2");
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
                Routes.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
