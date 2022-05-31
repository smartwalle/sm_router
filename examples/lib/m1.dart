import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

final _m1Route = RouteCenter();

class M1Home extends StatelessWidget {
  M1Home({Key? key}) : super(key: key) {
    _m1Route.handle("/", (ctx) => const M1View1());
    _m1Route.handle("/m1/view2", (ctx) => const M1View2());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _m1Route.routeInformationParser,
      routerDelegate: _m1Route.routerDelegate,
    );
  }
}

class M1View1 extends StatelessWidget {
  const M1View1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Routes.pop();
          },
        ),
        title: const Text("M1 View1"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("进入 /m1/view2"),
              onPressed: () {
                _m1Route.push("/m1/view2");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class M1View2 extends StatelessWidget {
  const M1View2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M1 View2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: const Text("返回 /m1/view1"),
              onPressed: () {
                _m1Route.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
