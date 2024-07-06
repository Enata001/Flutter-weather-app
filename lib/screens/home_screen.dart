import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/provider/cache_provider.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/dimensions.dart';
import 'package:weather_app/utils/extensions.dart';
import 'package:weather_app/widgets/search.dart';
import '../models/status.dart';
import '../widgets/weather_card.dart';
import 'weather_details_screen.dart';

Status _status = Status.loading;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Fetching the weather details from the openweathermap api
  Future<WeatherData?> loadWeatherDetails(
      String location, BuildContext context) async {
    final result = await WeatherService().fetchCurrentWeather(
        city: location,
        onError: () {
          context.messenger(
            title: 'Error',
            description: 'Something went wrong. please try again',
            icon: Icons.error_outline,
          );
        });

    if (result != null) {
      final weather = WeatherData.fromMap(result);
      return weather;
    }
    return null;
  }

  //Initializing SharedPreferences to load previous weather details
  awaitCache() async {
    await SharedPreferences.getInstance();
    setState(() {
      _status = Status.done;
    });
  }

  @override
  void initState() {
    super.initState();
    awaitCache();
  }

  @override
  Widget build(BuildContext context) {
    CacheProvider pref = Provider.of<CacheProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: Dimensions.viewPadding,
            right: Dimensions.viewPadding,
            top: Dimensions.viewPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: const GradientRotation(5.8),
              colors: [
                Colors.indigo.shade200,
                Colors.cyan.shade100,
                Colors.indigo.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Custom search widget for city
              SearchWidget(onSubmitted: (val) async {
                if (val == null || val.isEmpty) return;
                await pref.setCity(val);
              }),
              _status == Status.done
                  ? Expanded(
                      child: (pref.city == null)
                          ? Center(
                              child: Text(
                                'Please Enter a location to Search',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => Future.delayed(
                                Duration.zero,
                                () async => await pref.setCity(pref.city!),
                              ),
                              child: CustomScrollView(
                                slivers: [
                                  SliverFillRemaining(
                                    //Loading city results from the loadWeatherMethod
                                    child: FutureBuilder(
                                      future: loadWeatherDetails(
                                          pref.city!, context),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          //Weather widget to display the weather
                                          return Weather(
                                            data: snapshot.data!,
                                          );
                                        }
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            !snapshot.hasData) {
                                          return Center(
                                            child: Text(
                                              'Oops.. No Results Found',
                                              style: GoogleFonts.lato(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ))
                  : const Expanded(
                      child: Center(
                      child: CircularProgressIndicator(),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
