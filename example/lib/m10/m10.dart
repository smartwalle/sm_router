import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// NavigatorWrapper
void main() {
  RouteCenter.handle(
      "/", (ctx) => const M10View(title: "M10 View1", color: Colors.red));
  RouteCenter.handle("/m10/view2",
      (ctx) => const M10View(title: "M10 View2", color: Colors.yellow));
  RouteCenter.handle("/m10/view3",
      (ctx) => const M10View(title: "M10 View3", color: Colors.green));
  RouteCenter.handle(
          "/m10/view4",
          (ctx) =>
              const M10View(title: "M10 View4", color: Colors.purpleAccent))
      .setNavigatorWrapper((ctx, navigator) => NavWrapper2(child: navigator));

  RouteCenter.setNavigatorWrapper((ctx, navigator) {
    return NavWrapper1(
      ctx: ctx,
      child: navigator,
    );
  });

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

class NavWrapper1 extends StatefulWidget {
  const NavWrapper1({
    Key? key,
    required this.ctx,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Context ctx;

  @override
  State<NavWrapper1> createState() {
    return _NavWrapper1State();
  }
}

class _NavWrapper1State extends State<NavWrapper1> {
  @override
  void initState() {
    super.initState();
    print("_MainWrapperState initState");
  }

  @override
  Widget build(BuildContext context) {
    print("_MainWrapperState build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigator Wrapper 1"),
      ),
      body: Row(
        children: [
          PreferredSize(
            preferredSize: const Size(100, double.infinity),
            child: Container(
              color: Colors.deepPurpleAccent,
              child: Column(
                children: [
                  MenuButton(
                      ctx: widget.ctx, routeName: "/", title: "进入 /m10/view1"),
                  MenuButton(
                      ctx: widget.ctx,
                      routeName: "/m10/view2",
                      title: "进入 /m10/view2"),
                  MenuButton(
                      ctx: widget.ctx,
                      routeName: "/m10/view3",
                      title: "进入 /m10/view3"),
                  MenuButton(
                      ctx: widget.ctx,
                      routeName: "/m10/view4",
                      title: "进入 /m10/view4"),
                ],
              ),
            ),
          ),
          Flexible(
            child: ClipRect(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.ctx,
    required this.routeName,
    required this.title,
  }) : super(key: key);

  final Context ctx;
  final String routeName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ctx.routeName == routeName
          ? null
          : () {
              RouteCenter.push(routeName);
            },
      child: Text(
        title,
        style: TextStyle(
          color: ctx.routeName == routeName ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}

class M10View extends StatelessWidget {
  const M10View({Key? key, required this.title, required this.color})
      : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class NavWrapper2 extends StatefulWidget {
  const NavWrapper2({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<NavWrapper2> createState() => _NavWrapper2State();
}

class _NavWrapper2State extends State<NavWrapper2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigator Wrapper 2"),
      ),
      body: widget.child,
    );
  }
}
