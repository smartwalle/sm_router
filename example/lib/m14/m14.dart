import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

// Hero
void main() {
  RouteCenter.handle("/", (ctx) => const Text("Redirect")).use((ctx) => const Redirect("/m14/view1"));
  RouteCenter.handle("/m14/view1", (ctx) => const M14View1());
  RouteCenter.handle("/m14/view2", (ctx) => M14View2(tag: ctx.queryParam.get("tag")!))
      .setPageBuilder((ctx, child) => TransitionPage(
            child,
            key: ctx.key,
            name: ctx.requestName,
            arguments: ctx.arguments,
          ));
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

class M14View1 extends StatelessWidget {
  const M14View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("点击查看大图"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            TextButton(
              child: Hero(
                tag: "tag1",
                child: Image.asset(
                  "images/1.jpg",
                  width: 100.0,
                ),
              ),
              onPressed: () {
                RouteCenter.push("/m14/view2?tag=tag1");
              },
            ),
            TextButton(
              child: Hero(
                tag: "tag2",
                child: Image.asset(
                  "images/1.jpg",
                  width: 100.0,
                ),
              ),
              onPressed: () {
                RouteCenter.push("/m14/view2?tag=tag2");
              },
            ),
            TextButton(
              child: Hero(
                tag: "tag3",
                child: Image.asset(
                  "images/1.jpg",
                  width: 100.0,
                ),
              ),
              onPressed: () {
                RouteCenter.push("/m14/view2?tag=tag3");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M14View2 extends StatelessWidget {
  const M14View2({Key? key, required this.tag}) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("这是大图"),
        backgroundColor: Colors.purple,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Hero(
          tag: tag,
          child: Image.asset(
            "images/1.jpg",
          ),
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
