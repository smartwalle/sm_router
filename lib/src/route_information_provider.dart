import 'package:flutter/widgets.dart';

class RouteProvider extends PlatformRouteInformationProvider {
  static String effectiveInitialLocation(String? initialLocation) {
    WidgetsFlutterBinding.ensureInitialized();
    final String platformDefault = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    if (initialLocation == null) {
      return platformDefault;
    } else if (platformDefault == '/') {
      return initialLocation;
    } else {
      return platformDefault;
    }
  }

  RouteProvider({
    required String initialLocation,
  }) : super(initialRouteInformation: RouteInformation(location: effectiveInitialLocation(initialLocation)));
}
