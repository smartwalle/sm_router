import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 简单 push 和 pop
void main() {
  KIRouter.defaultTitle = "DefaultTitle";

  KIRouter.handle("/", (ctx) => const M17View1(), title: "Home");
  KIRouter.handle("/m17/view2", (ctx) => const M17View2());
  KIRouter.handle("/m17/view3", (ctx) => const M17View3(), title: "View3");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: KIRouter.routeInformationParser,
      routerDelegate: KIRouter.routerDelegate,
    );
  }
}

class M17View1 extends StatelessWidget {
  const M17View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M17 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m17/view2"),
              onPressed: () {
                KIRouter.push("/m17/view2").then((value) {
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

class M17View2 extends StatelessWidget {
  const M17View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    KIRouter.title = "[NewTitle]";

    return Scaffold(
      appBar: AppBar(
        title: const Text("M17 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m17/view1"),
              onPressed: () {
                KIRouter.pop("from view2");
              },
            ),
            TextButton(
              child: const Text("进入 /m17/view3"),
              onPressed: () {
                KIRouter.push("/m17/view3").then((value) {
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

class M17View3 extends StatelessWidget {
  const M17View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M17 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m17/view2"),
              onPressed: () {
                KIRouter.pop("from view3");
              },
            ),
          ],
        ),
      ),
    );
  }
}
