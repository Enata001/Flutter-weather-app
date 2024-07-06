import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coordinates.dart';
import '../widgets/weather_snippet.dart';
import '../models/weather_data.dart';
import '../utils/constants.dart';
import '../utils/dimensions.dart';
import '../utils/navigation.dart';

class Weather extends StatelessWidget {
  final WeatherData data;

  const Weather({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(),
        const SizedBox(height: Dimensions.viewPadding),
        Text(
          '${data.name}, ${data.country.toUpperCase()}',
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
            letterSpacing: 1,
            fontSize: 65,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data.condition.toUpperCase(),
          style: GoogleFonts.lato(
            letterSpacing: 1.4,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            Navigation.goTo(
                Navigation.weatherDetails,
                Coordinates(
                    name: data.name,latitude: data.latitude, longitude: data.longitude));
          },
          label: Text(
            'More Info',
            style: GoogleFonts.aBeeZee(),
          ),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_right),
        ),
        const Spacer(),
        _snippetCard(context, data),
        const SizedBox(
          height: Dimensions.viewPadding,
        ),
      ],
    );
  }
}

Widget _snippetCard(BuildContext context, WeatherData data) {
  final size = MediaQuery.of(context).size.width;
  return Container(
    width: size < 600 ? double.infinity : size * 0.7,
    padding: const EdgeInsets.all(25.0),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        WeatherSnippet(
          icon: Icons.water_drop_sharp,
          text: '${data.humidity}%',
          prop: 'Humidity',
        ),
        SizedBox(
          height: 35,
          child: VerticalDivider(
            color: Theme.of(context).primaryColor,
          ),
        ),
        WeatherSnippet(
          icon: Icons.energy_savings_leaf_rounded,
          text: '${data.windSpeed}km/h',
          prop: 'Wind speed',
        ),
        SizedBox(
          height: 35,
          child: VerticalDivider(
            color: Theme.of(context).primaryColor,
          ),
        ),
        WeatherSnippet(
          icon: Icons.wind_power_rounded,
          text: '${data.pressure}Pa',
          prop: 'Pressure',
        ),
      ],
    ),
  );
}
