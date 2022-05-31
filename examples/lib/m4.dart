import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

final _m4Route = RouteCenter();

class M4Home extends StatelessWidget {
  M4Home({Key? key}) : super(key: key) {
    _m4Route.setPageBuilder((ctx, child) => TransitionPage(
          child,
          key: ctx.key,
          name: ctx.requestName,
          arguments: ctx.arguments,
        ));

    _m4Route.handle("/", (ctx) => const M4View1());
    _m4Route.handle("/m4/view2", (ctx) => const M4View2());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _m4Route.routeInformationParser,
      routerDelegate: _m4Route.routerDelegate,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Routes.pop();
          },
        ),
        title: const Text("M4 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m4/view2"),
              onPressed: () {
                _m4Route.push("/m4/view2");
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
                _m4Route.pop();
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
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
