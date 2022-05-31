import 'package:examples/m1.dart';
import 'package:examples/m2.dart';
import 'package:examples/m3.dart';
import 'package:examples/m4.dart';
import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

void main() {
  Routes.handle("/", (ctx) => const HomeView());
  Routes.handle("/m1", (ctx) => M1Home());
  Routes.handle("/m2", (ctx) => M2Home());
  Routes.handle("/m3", (ctx) => M3Home());
  Routes.handle("/m4", (ctx) => M4Home());

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

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("m1 (简单 push 和 pop)"),
              onPressed: () {
                Routes.push("/m1");
              },
            ),
            TextButton(
              child: const Text("m2 (带有返回值的 pop)"),
              onPressed: () {
                Routes.push("/m2");
              },
            ),
            TextButton(
              child: const Text("m3 (带有 URL 参数的 push)"),
              onPressed: () {
                Routes.push("/m3");
              },
            ),
            TextButton(
              child: const Text("m4 (自定义动画)"),
              onPressed: () {
                Routes.push("/m4");
              },
            ),
          ],
        ),
      ),
    );
  }
}
