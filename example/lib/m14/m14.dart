import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

// Hero
void main() {
  KIRouter.handle("/", (ctx) => const Text("Redirect")).use((ctx) => const KIRedirect("/m14/view1"));
  KIRouter.handle("/m14/view1", (ctx) => const M14View1());
  KIRouter.handle("/m14/view2", (ctx) => M14View2(tag: ctx.queryParam.get("tag")!));
  KIRouter.setPageBuilder((ctx, child) => KIFadeTransitionPage(child: child));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: KIRouter.routeInformationParser,
      routerDelegate: KIRouter.routerDelegate,
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
                KIRouter.push("/m14/view2?tag=tag1");
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
                KIRouter.push("/m14/view2?tag=tag2");
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
                KIRouter.push("/m14/view2?tag=tag3");
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
