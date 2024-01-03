import 'package:etravel_mobile/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.login:
      // return MaterialPageRoute(
      //     builder: (BuildContext context) => LoginView());
      case RoutesName.home:
      // return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RoutesName.history_order:
      // return MaterialPageRoute(
      //     builder: (BuildContext context) => HistoryScreen());
      case RoutesName.profile:
      // return MaterialPageRoute(
      //     builder: (BuildContext context) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: Center(child: Text('No page routes defined')),
          ),
        );
    }
  }
}
