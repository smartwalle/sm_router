import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// pushRoutesAndRemoveUntil 和 pushRoutesAndRemoveAll
void main() {
  KIRouter.handle("/", (ctx) => const M8View1());
  KIRouter.handle("/m8/view2", (ctx) => const M8View2());
  KIRouter.handle("/m8/view21", (ctx) => const M8View21());
  KIRouter.handle("/m8/view22", (ctx) => const M8View22());
  KIRouter.handle("/m8/view23", (ctx) => const M8View23());

  KIRouter.handle("/m8/view3", (ctx) => const M8View3());
  KIRouter.handle("/m8/view31", (ctx) => const M8View31());
  KIRouter.handle("/m8/view32", (ctx) => const M8View32());
  KIRouter.handle("/m8/view33", (ctx) => const M8View33());

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
                KIRouter.push("/m8/view2");
              },
            ),
            TextButton(
              child: const Text("进入 /m8/view2 (pushRoutesAndRemoveAll)"),
              onPressed: () {
                KIRouter.push("/m8/view3");
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
                KIRouter.push("/m8/view21");
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
                  KIRouteName("/m8/view22"),
                  KIRouteName("/m8/view23"),
                ];
                KIRouter.pushRoutesAndRemoveUntil(
                    routes, (ctx) => ctx.requestName == "/m8/view2");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View22 extends StatefulWidget {
  const M8View22({Key? key}) : super(key: key);

  @override
  State<M8View22> createState() => _M8View22State();
}

class _M8View22State extends State<M8View22> {
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
                KIRouter.pop();
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
                KIRouter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View3 extends StatelessWidget {
  const M8View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("下一页面"),
              onPressed: () {
                KIRouter.push("/m8/view31");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View31 extends StatelessWidget {
  const M8View31({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View3-1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("下一页面"),
              onPressed: () {
                var routes = [
                  KIRouteName("/m8/view32"),
                  KIRouteName("/m8/view33"),
                ];
                KIRouter.pushRoutesAndRemoveAll(routes);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View32 extends StatelessWidget {
  const M8View32({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View3-2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("无法返回"),
              onPressed: () {
                KIRouter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M8View33 extends StatelessWidget {
  const M8View33({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M8 View3-3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 M8 View3-2"),
              onPressed: () {
                KIRouter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
