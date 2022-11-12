import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// KIRouteInformationParser
class KIRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    String routeName = routeInformation.location ?? "/";
    return SynchronousFuture(routeName);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}
