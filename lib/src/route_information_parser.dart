import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// KIRouteInformationParser
class KIRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    String routeName = routeInformation.uri.path;
    return SynchronousFuture(routeName);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}
