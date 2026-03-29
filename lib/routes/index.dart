import 'package:flutter/material.dart';
import 'auth/export.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    ...AuthRoutes.routes,
    // Add other module routes here in the future
  };

  static String initialRoute = AuthRoutes.getStarted;
}
