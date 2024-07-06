import 'package:flutter/material.dart';
import 'package:weather_app/models/coordinates.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/weather_details_screen.dart';

class Navigation {
  Navigation._();

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static const entry = '/';
  static const weatherDetails = 'weatherDetails';

  static goTo(String routeName, [dynamic args]) {
    return navKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static close() {
    return navKey.currentState?.pop();
  }

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case entry:
        return OpenRoute(
          widget: const HomeScreen(),
        );

      case weatherDetails:
        return OpenRoute(
          widget: WeatherDetailsScreen(coordinates: settings.arguments as Coordinates,),

        );
      default:
        return OpenRoute(
          widget: const ErrorScreen(),
        );
    }
  }
}

class OpenRoute extends PageRouteBuilder {
  final Widget widget;

  OpenRoute({required this.widget})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This page does not exist"),
      ),
    );
  }
}
