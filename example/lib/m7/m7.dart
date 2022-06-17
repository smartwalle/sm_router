import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// pushRoutes 和 pushRoutesReplacement
void main() {
  RouteCenter.handle("/", (ctx) => const M7View1());
  RouteCenter.handle("/m7/view2", (ctx) => const M7View2());
  RouteCenter.handle("/m7/view3", (ctx) => const M7View3());
  RouteCenter.handle("/m7/view4", (ctx) => const M7View4());

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
                  RouteName("/m7/view2"),
                  RouteName("/m7/view3"),
                  RouteName("/m7/view4"),
                ];

                RouteCenter.pushRoutes(routes);
              },
            ),
            TextButton(
              child: const Text(
                  "pushRoutesReplacement: /m7/view2、/m7/view3、/m7/view4"),
              onPressed: () {
                var routes = [
                  RouteName("/m7/view2"),
                  RouteName("/m7/view3"),
                  RouteName("/m7/view4"),
                ];

                RouteCenter.pushRoutesReplacement(routes);
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
                RouteCenter.pop();
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
                RouteCenter.pop();
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
                RouteCenter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
