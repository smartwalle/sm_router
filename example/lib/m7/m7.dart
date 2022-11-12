import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// pushRoutes 和 pushRoutesReplacement
void main() {
  KIRouter.handle("/", (ctx) => const M7View1());
  KIRouter.handle("/m7/view2", (ctx) => const M7View2());
  KIRouter.handle("/m7/view3", (ctx) => const M7View3());
  KIRouter.handle("/m7/view4", (ctx) => const M7View4());

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

class M7View1 extends StatelessWidget {
  const M7View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M7 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("pushRoutes: /m7/view2、/m7/view3、/m7/view4"),
              onPressed: () {
                var routes = [
                  KIRouteName("/m7/view2"),
                  KIRouteName("/m7/view3"),
                  KIRouteName("/m7/view4"),
                ];

                KIRouter.pushRoutes(routes);
              },
            ),
            TextButton(
              child: const Text(
                  "pushRoutesReplacement: /m7/view2、/m7/view3、/m7/view4"),
              onPressed: () {
                var routes = [
                  KIRouteName("/m7/view2"),
                  KIRouteName("/m7/view3"),
                  KIRouteName("/m7/view4"),
                ];

                KIRouter.pushRoutesReplacement(routes);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M7View2 extends StatelessWidget {
  const M7View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M7 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m7/view1"),
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

class M7View3 extends StatelessWidget {
  const M7View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M7 View3"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m7/view2"),
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

class M7View4 extends StatelessWidget {
  const M7View4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M7 View4"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m7/view3"),
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
