import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

// setKeyBuilder 和 PageView
void main() {
  RouteCenter.handle("/", (ctx) => const Text("")).use((ctx) => const Redirect("/m13/view1"));

  RouteCenter.handle("/m13/view1", (ctx) => const Home(initialPage: 0)).setKeyBuilder(
    (ctx) => const ValueKey("home"),
  );
  RouteCenter.handle("/m13/view2", (ctx) => const Home(initialPage: 1)).setKeyBuilder(
    (ctx) => const ValueKey("home"),
  );
  RouteCenter.handle("/m13/view3", (ctx) => const Home(initialPage: 2)).setKeyBuilder(
    (ctx) => const ValueKey("home"),
  );

  RouteCenter.handle("/m13/view4", (ctx) => const Text("")).use((ctx) => const Redirect("/m13/view41"));
  RouteCenter.handle("/m13/view41", (ctx) => const M13View4(initialPage: 0)).setKeyBuilder(
    (ctx) => const ValueKey("m13view4"),
  );
  RouteCenter.handle("/m13/view42", (ctx) => const M13View4(initialPage: 1)).setKeyBuilder(
    (ctx) => const ValueKey("m13view4"),
  );
  RouteCenter.handle("/m13/view43", (ctx) => const M13View4(initialPage: 2)).setKeyBuilder(
    (ctx) => const ValueKey("m13view4"),
  );

  runApp(const MainApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: RouteCenter.routeInformationParser,
      routerDelegate: RouteCenter.routerDelegate,
      scrollBehavior: AppScrollBehavior(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.initialPage}) : super(key: key);

  final int initialPage;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> views = [
    const M13View(title: "Page 1", color: Colors.red),
    const M13View(title: "Page 2", color: Colors.green),
    const M13View(title: "Page 3", color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PageView"),
      ),
      body: PageView(
        controller: PageController(
          initialPage: widget.initialPage,
        ),
        children: views,
        onPageChanged: (index) {
          RouteCenter.show("/m13/view${index + 1}");
        },
      ),
    );
  }
}

class M13View extends StatelessWidget {
  const M13View({Key? key, required this.title, required this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            TextButton(
              onPressed: () {
                RouteCenter.push("/m13/view4");
              },
              child: const Text(
                "进入 /m13/view4",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class M13View4 extends StatefulWidget {
  const M13View4({Key? key, required this.initialPage}) : super(key: key);

  final int initialPage;

  @override
  State<M13View4> createState() => _M13View4State();
}

class _M13View4State extends State<M13View4> {
  List<Widget> views = [
    const M13View41(title: "Page 4-1", color: Colors.lightBlue),
    const M13View41(title: "Page 4-2", color: Colors.lightGreen),
    const M13View41(title: "Page 4-3", color: Colors.redAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M13 View4"),
      ),
      body: PageView(
        controller: PageController(
          initialPage: widget.initialPage,
        ),
        children: views,
        onPageChanged: (index) {
          RouteCenter.pushReplacement("/m13/view4${index + 1}");
        },
      ),
    );
  }
}

class M13View41 extends StatelessWidget {
  const M13View41({Key? key, required this.title, required this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
