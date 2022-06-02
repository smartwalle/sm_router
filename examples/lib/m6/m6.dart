import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// NavigatorWrapper
void main() {
  RouteCenter.handle("/", (ctx) => const M6View1());
  RouteCenter.handle("/m6/view2", (ctx) => const M6View2());
  RouteCenter.handle("/m6/view3", (ctx) => const M6View3());

  RouteCenter.setNavigatorWrapper((context, route, navigator) {
    return MainWrapper(
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

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<MainWrapper> createState() {
    return _MainWrapperState();
  }
}

class _MainWrapperState extends State<MainWrapper> {
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
        title: const Text("Navigator Wrapper"),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 20),
          child: Row(
            children: [
              TextButton(
                child: const Text(
                  "进入 /m6/view1",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  RouteCenter.pushReplacement("/");
                },
              ),
              TextButton(
                child: const Text(
                  "进入 /m6/view2",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  RouteCenter.pushReplacement("/m6/view2");
                },
              ),
              TextButton(
                child: const Text(
                  "进入 /m6/view3",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  RouteCenter.pushReplacement("/m6/view3");
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}

class M6View1 extends StatelessWidget {
  const M6View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
    );
  }
}

class M6View2 extends StatelessWidget {
  const M6View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
    );
  }
}

class M6View3 extends StatelessWidget {
  const M6View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
    );
  }
}
