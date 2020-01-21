import 'package:exam/Screens/screen1.dart';
import 'package:exam/Screens/screen2.dart';
import 'package:flutter/material.dart';

const String DEFAULT_ROUTE = '/';
const String SCREEN_1 = '/screen1';
const String SCREEN_2 = '/screen2';
const String SCREEN_3 = '/screen3';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DEFAULT_ROUTE:
        return MaterialPageRoute(builder: (_) => Screen1());
      case SCREEN_1:
        return MaterialPageRoute(builder: (_) => Screen1());
      case SCREEN_2:
        return MaterialPageRoute(builder: (_) => Screen2());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
