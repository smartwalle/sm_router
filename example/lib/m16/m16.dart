import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

void main() {
  var share = Share();

  KIRouter.handle("/", (ctx) => const M16Home());
  KIRouter.handle("/m16/view1", (ctx) => const M16View1());
  KIRouter.handle("/m16/view2", (ctx) => const M16View2());
  KIRouter.handle("/m16/view3", (ctx) => const M16View3());
  KIRouter.handle(
    "/m16/login",
    (ctx) => M16Login(
      share: share,
      from: ctx.queryParam.get("r") ?? "/",
    ),
  ).use((ctx) {
    if (share.token != null) {
      var r = ctx.queryParam.get("r") ?? "/";
      return KIRedirect(r);
    }
    return null;
  });

  KIRouter.use((ctx) {
    if (share.token != null || ctx.routeName == "/" || ctx.routeName == "/m16/view1" || ctx.routeName == "/m16/login") {
      return null;
    }
    return KIRedirect("/m16/login?r=${ctx.requestName}");
  });

  KIRouter.setPageBuilder((ctx, child) => KIFadeTransitionPage(child: child));

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
      routeInformationParser: KIRouter.routeInformationParser,
      routerDelegate: KIRouter.routerDelegate,
      routeInformationProvider: KIRouter.routeInformationProvider("/m16/view1"),
    );
  }
}

class M16Home extends StatelessWidget {
  const M16Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M16Home"),
      ),
      body: TextButton(
        child: const Text("M16View1"),
        onPressed: () {
          KIRouter.push("/m16/view1");
        },
      ),
    );
  }
}

class M16View1 extends StatelessWidget {
  const M16View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M16View1"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              KIRouter.push("/m16/view2");
            },
            child: const Text("M16View2"),
          ),
          TextButton(
            onPressed: () {
              KIRouter.push("/m16/view3");
            },
            child: const Text("M16View3"),
          ),
        ],
      ),
    );
  }
}

class M16View2 extends StatelessWidget {
  const M16View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M16View2"),
      ),
    );
  }
}

class M16View3 extends StatelessWidget {
  const M16View3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M16View3"),
      ),
    );
  }
}

class M16Login extends StatelessWidget {
  final Share share;
  final String from;

  const M16Login({
    Key? key,
    required this.share,
    required this.from,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M16Login"),
      ),
      body: TextButton(
        onPressed: () {
          share.token = "good";

          KIRouter.neglect(context, () {
            KIRouter.replace(from);
          });
        },
        child: const Text("Login"),
      ),
    );
  }
}
