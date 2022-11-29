import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KIRoutePage<T> extends Page<T> {
  const KIRoutePage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.fullscreenDialog = false,
  });

  final Widget child;

  final RouteTransitionsBuilder transitionsBuilder;

  final Duration transitionDuration;

  final Duration reverseTransitionDuration;

  final bool opaque;

  final bool barrierDismissible;

  final Color? barrierColor;

  final String? barrierLabel;

  final bool maintainState;

  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) {
    return _KIPageRoute<T>(page: this);
  }
}

class _KIPageRoute<T> extends PageRoute<T> {
  _KIPageRoute({required KIRoutePage<T> page}) : super(settings: page);

  KIRoutePage<T> get _page => settings as KIRoutePage<T>;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get opaque => _page.opaque;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(scopesRoute: true, explicitChildNodes: true, child: _page.child);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _page.transitionsBuilder(context, animation, secondaryAnimation, child);
  }
}

class KINoTransitionPage<T> extends KIRoutePage<T> {
  KINoTransitionPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required super.child,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}

class KIFadeTransitionPage<T> extends KIRoutePage<T> {
  KIFadeTransitionPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required super.child,
  }) : super(transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
}
