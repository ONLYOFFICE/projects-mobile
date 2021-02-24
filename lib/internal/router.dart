import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:only_office_mobile/presentation/views/home_view/home_view.dart';
import 'package:only_office_mobile/presentation/views/login_view/login_view.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
