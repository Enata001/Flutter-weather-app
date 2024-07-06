import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/coordinates.dart';
import '../models/status.dart';
import '../models/weather_summary.dart';
import '../utils/constants.dart';
import '../utils/dimensions.dart';
import '../utils/extensions.dart';
import '../widgets/weather_times.dart';
import '../models/detailed_weather.dart';
import '../services/weather_service.dart';
import '../widgets/weather_snippet.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final Coordinates coordinates;

  const WeatherDetailsScreen({super.key, required this.coordinates});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  Status _status = Status.loading;

  //Method to load information from the open weather api
  Future<DetailedWeatherData?> getDetails(
      String location, BuildContext context) async {
    setState(() {
      _status = Status.loading;
    });

    final weather = await WeatherService().fetchCurrentWeather(
        city: location,
        onError: () {
          setState(() {
            _status = Status.error;
          });

          context.messenger(
            title: 'Error',
            description: 'Something went wrong. please try again',
            icon: Icons.error_outline,
          );
        });
    final result =
        await WeatherService().fetchForecastDetails(widget.coordinates);
    if (weather != null) {
      final data = DetailedWeatherData.fromMap(weather);
      data.summary.addAll(result as Iterable<WeatherSummary>);
      return data;
    }
    return null;
  }

  DetailedWeatherData? data;

  loadDetails() async {
    data = await getDetails(widget.coordinates.name, context);
    if (data != null) {
      setState(() {
        _status = Status.done;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(
          widget.coordinates.name,
          style: GoogleFonts.lato(
            letterSpacing: 1.2,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Future.delayed(
                  Duration.zero,
                  () {
                    setState(() {
                      _status = Status.loading;
                    });
                    loadDetails();
                  },
                );
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
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
        child: SafeArea(child: loadInformation(_status, context, data)),
      ),
    );
  }
}
//Widget Function to load detailed weather information after completion
Widget loadInformation(
    Status status, BuildContext context, DetailedWeatherData? data) {
  switch (status) {
    case Status.done:
      return showWeather(context, data!);
    case Status.loading:
      return const Center(
        child: CircularProgressIndicator(),
      );
    case Status.error:
      return Center(
        child: Text(
          'Oops...An error occurred',
          style: GoogleFonts.lato(
            letterSpacing: 1.2,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
  }
}

//Widget Function to display detailed weather information after completion
Widget showWeather(BuildContext context, DetailedWeatherData data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Text(
        DateFormat.yMMMMEEEEd().format(DateTime.now()),
        style: GoogleFonts.lato(
          letterSpacing: 1.2,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      Image.network(
        '${Constants.baseUrl + data.icon}@2x.png',
        scale: 1,
      ),
      Text(
        '${data.temperature}°C',
        style: GoogleFonts.lato(
            letterSpacing: 1, fontSize: 65, fontWeight: FontWeight.bold),
      ),
      Text(
        data.condition.toUpperCase(),
        style: GoogleFonts.lato(
          letterSpacing: 1.4,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      _detailedSnippetCard(context, data),
      Align(
        alignment: MediaQuery.sizeOf(context).width < 800
            ? Alignment.bottomLeft
            : Alignment.bottomCenter,
        child: Text(
          'Next 24 hours',
          style: GoogleFonts.lato(
            letterSpacing: 1.2,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SizedBox(
        height: 120,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: data.summary.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            //Custom widget to load summary weather details for upcoming weather conditions
            return WeatherTimes(
                time: data.summary[index].time,
                url: data.summary[index].icon,
                temperature: data.summary[index].temperature);
          },
        ),
      ),
    ],
  );
}
//Widget function to create snippet card of weather properties
Widget _detailedSnippetCard(BuildContext context, DetailedWeatherData data) {
  final size = MediaQuery.of(context).size.width;
  return Container(
    width: size < 600 ? double.infinity : size * 0.7,
    padding: const EdgeInsets.all(25.0),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Custom weather snippet widget
            WeatherSnippet(
              icon: Icons.water_drop_sharp,
              text: '${data.humidity}%',
              prop: 'Humidity',
            ),
            WeatherSnippet(
              icon: Icons.energy_savings_leaf_rounded,
              text: '${data.windSpeed}km/h',
              prop: 'Wind speed',
            ),
            WeatherSnippet(
              icon: Icons.wind_power_rounded,
              text: '${data.pressure}Pa',
              prop: 'Pressure',
            ),
          ],
        ),
        SizedBox(
          height: Dimensions.viewPadding,
          child: Divider(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WeatherSnippet(
              icon: Icons.thermostat_sharp,
              text: '${data.humidity}°C',
              prop: 'Feels like',
            ),
            WeatherSnippet(
              icon: Icons.thermostat_sharp,
              text: '${data.windSpeed}°C',
              prop: 'Min Temp',
            ),
            WeatherSnippet(
              icon: Icons.thermostat_sharp,
              text: '${data.pressure}°C',
              prop: 'Max Temp',
            ),
          ],
        ),
        SizedBox(
          height: Dimensions.viewPadding,
          child: Divider(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ],
    ),
  );
}
