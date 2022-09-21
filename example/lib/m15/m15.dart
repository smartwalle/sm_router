import 'package:flutter/material.dart';
import 'package:sm_browser/sm_browser.dart';
import 'package:sm_platform/sm_platform.dart';
import 'package:sm_router/sm_router.dart';

void main() {
  var share = Share();

  RouteCenter.handle("/", (ctx) => const M15Home());
  RouteCenter.handle("/m15/view1", (ctx) => const M15View1());
  RouteCenter.handle("/m15/view2", (ctx) => const M15View2());
  RouteCenter.handle("/m15/view3", (ctx) => const M15View3());
  RouteCenter.handle(
    "/m15/login",
    (ctx) => M15Login(
      share: share,
      from: ctx.queryParam.get("r") ?? "/",
    ),
  ).use((ctx) {
    if (share.token != null) {
      var r = ctx.queryParam.get("r") ?? "/";
      return Redirect(r);
    }
    return null;
  });

  RouteCenter.use((ctx) {
    if (share.token != null || ctx.routeName == "/" || ctx.routeName == "/m15/view1" || ctx.routeName == "/m15/login") {
      return null;
    }
    return Redirect("/m15/login?r=${ctx.requestName}");
  });

  runApp(const MainApp());
}

class Share {
  String? token;
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

class M15Home extends StatelessWidget {
  const M15Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M15Home"),
      ),
      body: TextButton(
        child: const Text("M15View1"),
        onPressed: () {
          RouteCenter.push("/m15/view1");
        },
      ),
    );
  }
}

class M15View1 extends StatelessWidget {
  const M15View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M15View1"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              RouteCenter.push("/m15/view2");
            },
            child: const Text("M15View2"),
          ),
          TextButton(
            onPressed: () {
              RouteCenter.push("/m15/view3");
            },
            child: const Text("M15View3"),
          ),
        ],
      ),
    );
  }
}

class M15View2 extends StatelessWidget {
  const M15View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M15View2"),
      ),
    );
  }
}

class M15View3 extends StatelessWidget {
  const M15View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M15View3"),
      ),
    );
  }
}

class M15Login extends StatelessWidget {
  final Share share;
  final String from;

  const M15Login({
    Key? key,
    required this.share,
    required this.from,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M15Login"),
      ),
      body: TextButton(
        onPressed: () {
          share.token = "good";

          if (KIDevice.isBrowser) {
            KIBrowser.location.replace("${KIBrowser.location.origin}#$from");
          } else {
            RouteCenter.replace(from);
          }
        },
        child: const Text("Login"),
      ),
    );
  }
}
