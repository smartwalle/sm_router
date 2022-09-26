import 'package:flutter/widgets.dart';

class TransitionPage<T> extends Page<T> {
  const TransitionPage({
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
    return _TransitionPageRoute<T>(page: this);
  }
}

class _TransitionPageRoute<T> extends PageRoute<T> {
  _TransitionPageRoute({required TransitionPage<T> page}) : super(settings: page);

  TransitionPage<T> get _page => settings as TransitionPage<T>;

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

class NoTransitionPage<T> extends TransitionPage<T> {
  NoTransitionPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required super.child,
  }) : super(transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        });
}

class FadeTransitionPage<T> extends TransitionPage<T> {
  FadeTransitionPage({
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
