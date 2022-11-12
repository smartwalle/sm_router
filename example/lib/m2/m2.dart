import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

/// 带有返回值的 pop
void main() {
  KIRouter.handle("/", (ctx) => const M2View1());
  KIRouter.handle("/m2/view2", (ctx) => const M2View2());

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

class M2View1 extends StatefulWidget {
  const M2View1({Key? key}) : super(key: key);

  @override
  State<M2View1> createState() => _M2View1State();
}

class _M2View1State extends State<M2View1> {
  String? message;
  bool _pop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M2 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m2/view2"),
              onPressed: () {
                KIRouter.push<String>("/m2/view2").then((value) {
                  setState(() {
                    message = value;
                    _pop = true;
                  });
                });
              },
            ),
            if (_pop)
              message != null ? Text("有返回值: $message") : const Text("没有返回值"),
          ],
        ),
      ),
    );
  }
}

class M2View2 extends StatelessWidget {
  const M2View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M2 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m2/view1 (有返回值)"),
              onPressed: () {
                KIRouter.pop<String>("这是来自 /m2/view2 的消息");
              },
            ),
            TextButton(
              child: const Text("返回 /m2/view1 (没有返回值)"),
              onPressed: () {
                KIRouter.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
