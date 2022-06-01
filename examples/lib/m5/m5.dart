import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// pushAndRemoveAll 和 pushAndRemoveUntil
void main() {
  Routes.handle("/", (ctx) => const M5View1());
  Routes.handle("/m5/view2", (ctx) => const M5View2());
  Routes.handle("/m5/view3", (ctx) => const M5View3());
  Routes.handle("/m5/view4", (ctx) => const M5View4());

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

class M5View1 extends StatelessWidget {
  const M5View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text("M5 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m5/view2"),
              onPressed: () {
                Routes.push("/m5/view2");
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class M5View2 extends StatelessWidget {
  const M5View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text("M5 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m5/view3"),
              onPressed: () {
                Routes.push("/m5/view3");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M5View3 extends StatelessWidget {
  const M5View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[100],
      appBar: AppBar(
        title: const Text("M5 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m5/view4 (无法返回)"),
              onPressed: () {
                Routes.pushAndRemoveAll("/m5/view4");
              },
            ),
            TextButton(
              child: const Text("进入 /m5/view4 (会返回到 /m5/view2)"),
              onPressed: () {
                Routes.pushAndRemoveUntil("/m5/view4", (ctx) => ctx.routeName == "/m5/view2");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M5View4 extends StatelessWidget {
  const M5View4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: const Text("M5 View4"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: Routes.canPop() ? const Text("返回") : const Text("无法返回"),
              onPressed: () {
                Routes.maybePop().then((value) {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
