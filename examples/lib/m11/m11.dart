import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

// setKey 和 show
void main() {
  RouteCenter.handle("/", (ctx) => const Text("Redirect")).use((ctx) => const Redirect("/m11/view1"));
  RouteCenter.handle("/m11/view1", (ctx) => const Home(currentIndex: 0)).setKeyBuilder((ctx) => const ValueKey("home"));
  RouteCenter.handle("/m11/view2", (ctx) => const Home(currentIndex: 1)).setKeyBuilder((ctx) => const ValueKey("home"));
  RouteCenter.handle("/m11/view3", (ctx) => const Home(currentIndex: 2)).setKeyBuilder((ctx) => const ValueKey("home"));
  RouteCenter.handle("/m11/view4", (ctx) => const M11View4());

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

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> views = [
    const M11View(title: "title", color: Colors.red),
    const M11View(title: "title", color: Colors.green),
    const M11View(title: "title", color: Colors.purple)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[widget.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              RouteCenter.show("/m11/view1");
              break;
            case 1:
              RouteCenter.show("/m11/view2");
              break;
            case 2:
              RouteCenter.show("/m11/view3");
              break;
          }
        },
      ),
    );
  }
}

class M11View extends StatefulWidget {
  const M11View({Key? key, required, required this.title, required this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  State<M11View> createState() {
    print("M11View createState");
    return _M11ViewState();
  }
}

class _M11ViewState extends State<M11View> {
  @override
  Widget build(BuildContext context) {
    print("_M11ViewState build");
    return Container(
      color: widget.color,
      child: Center(
        child: TextButton(
          onPressed: () {
            RouteCenter.push("/m11/view4");
          },
          child: const Text(
            "进入 /m11/view4",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class M11View4 extends StatelessWidget {
  const M11View4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("M11 View4"),
      ),
    );
  }
}
