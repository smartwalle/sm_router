import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

// setKey 和 show
void main() {
  RouteCenter.handle("/", (ctx) => const Text("Redirect")).use((ctx) => const Redirect("/m12/view1"));
  RouteCenter.handle(
      "/m12/view1",
      (ctx) => Home(
            key: ctx.key,
            ctx: ctx,
            child: const M12View(title: "title", color: Colors.red),
          )).setKey(const ValueKey("home"));
  RouteCenter.handle(
      "/m12/view2",
      (ctx) => Home(
            key: ctx.key,
            ctx: ctx,
            child: const M12View(title: "title", color: Colors.green),
          )).setKey(const ValueKey("home"));
  RouteCenter.handle(
      "/m12/view3",
      (ctx) => Home(
            key: ctx.key,
            ctx: ctx,
            child: const M12View(title: "title", color: Colors.purple),
          )).setKey(const ValueKey("home"));
  RouteCenter.handle("/m12/view4", (ctx) => const M12View4());

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
    required this.ctx,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Context ctx;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                  MenuButton(ctx: widget.ctx, routeName: "/m12/view1", title: "进入 /m12/view1"),
                  MenuButton(ctx: widget.ctx, routeName: "/m12/view2", title: "进入 /m12/view2"),
                  MenuButton(ctx: widget.ctx, routeName: "/m12/view3", title: "进入 /m12/view3"),
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
              RouteCenter.show(routeName);
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

class M12View extends StatefulWidget {
  const M12View({Key? key, required, required this.title, required this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  State<M12View> createState() {
    print("M12View createState");
    return _M12ViewState();
  }
}

class _M12ViewState extends State<M12View> {
  @override
  Widget build(BuildContext context) {
    print("_M12ViewState build");
    return Container(
      color: widget.color,
      child: Center(
        child: TextButton(
          onPressed: () {
            RouteCenter.push("/m12/view4");
          },
          child: const Text(
            "进入 /m12/view4",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class M12View4 extends StatelessWidget {
  const M12View4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("M12 View4"),
      ),
    );
  }
}
