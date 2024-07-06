import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/cache_provider.dart';

import '../utils/navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CacheProvider(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(colorSchemeSeed: Colors.blue),
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigation.navKey,
        onGenerateRoute: Navigation.onGenerateRoute,
      ),
    );
  }
}
