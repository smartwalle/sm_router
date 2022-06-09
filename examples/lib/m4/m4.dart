import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 自定义动画
void main() {
  RouteCenter.setPageBuilder((ctx, child) => TransitionPage(
        child,
        key: ctx.key,
        name: ctx.requestName,
        arguments: ctx.arguments,
      ));

  RouteCenter.handle("/", (ctx) => const M4View1());
  RouteCenter.handle("/m4/view2", (ctx) => const M4View2());
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

class M4View1 extends StatelessWidget {
  const M4View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text("M4 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m4/view2"),
              onPressed: () {
                RouteCenter.push("/m4/view2");
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class M4View2 extends StatelessWidget {
  const M4View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Text("M4 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m4/view1"),
              onPressed: () {
                RouteCenter.maybePop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransitionPage extends Page {
  final Widget child;

  const TransitionPage(
    this.child, {
    LocalKey? key,
    String? name,
    Object? arguments,
  }) : super(key: key, name: name, arguments: arguments);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
