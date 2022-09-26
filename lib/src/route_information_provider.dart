import 'package:flutter/widgets.dart';

class RouteProvider extends PlatformRouteInformationProvider {
  RouteProvider({
    required String initialLocation,
  }) : super(initialRouteInformation: RouteInformation(location: initialLocation));
}
