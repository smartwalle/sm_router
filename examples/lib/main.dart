import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

void main() {
  Routes.handle("/page1", (ctx) {
    return const Page1();
  });
  Routes.handle("/page2", (ctx) {
    return const Page2();
  }, (ctx, child) {
    return TransitionPage(key: ctx.key, child: child, name: ctx.requestName, arguments: ctx.arguments);
  });
  Routes.handle("/page3", (ctx) {
    return const Page3();
  });
  Routes.handle("/page4", (ctx) {
    return const Page4();
  });
  Routes.setInitialRouteName("/page1");

  runApp(const MyApp());
}

class TransitionPage<T> extends Page<T> {
  final Widget child;

  const TransitionPage({
    required LocalKey key,
    required this.child,
    String? name,
    Object? arguments,
  }) : super(key: key, name: name, arguments: arguments);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Routes.routeInformationParser,
      routerDelegate: Routes.routerDelegate,
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page1 build....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("page1"),
      ),
      backgroundColor: Colors.lightGreenAccent[100],
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text('去 /page2'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.push<String>("/page2").then((value) {
                  print("获取返回值: $value");
                });
              },
            ),
            TextButton(
              child: const Text('maybePop'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.maybePop();
              },
            ),
            TextButton(
              child: const Text('popToRoot'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.popToRoot();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page2 build....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("page2"),
      ),
      backgroundColor: Colors.amberAccent[100],
      body: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            TextButton(
              child: const Text('去 /page3'),
              onPressed: () {
                Routes.push("/page3");
              },
            ),
            TextButton(
              child: const Text('pop'),
              onPressed: () {
                Routes.pop<String>("pop");
              },
            ),
            TextButton(
              child: const Text("maybePop"),
              onPressed: () {
                Routes.maybePop("maybePop");
              },
            ),
            TextButton(
              child: const Text('popToRoot'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.popToRoot();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page3 build....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("page3"),
      ),
      backgroundColor: Colors.redAccent[100],
      body: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            TextButton(
              child: const Text('去 /page1'),
              onPressed: () {
                Routes.push("/page1");
              },
            ),
            TextButton(
              child: const Text('去 /page4'),
              onPressed: () {
                Routes.popAndPushNamed("/page4");
              },
            ),
            TextButton(
              child: const Text('pop'),
              onPressed: () {
                Routes.pop();
              },
            ),
            TextButton(
              child: const Text("maybePop"),
              onPressed: () {
                Routes.maybePop();
              },
            ),
            TextButton(
              child: const Text('popToRoot'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.popToRoot();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page4 build....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("page4"),
      ),
      backgroundColor: Colors.blue[100],
      body: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            TextButton(
              child: const Text('pop'),
              onPressed: () {
                Routes.popMatched((ctx) => ctx.routeName == "/page4");
              },
            ),
            TextButton(
              child: const Text("maybePop"),
              onPressed: () {
                Routes.maybePop();
              },
            ),
            TextButton(
              child: const Text('popToRoot'),
              onPressed: () {
                // Routes.of(context).pushNamed("/page2");
                // state.pushNamed("/efg");
                Routes.popToRoot();
              },
            ),
          ],
        ),
      ),
    );
  }
}
