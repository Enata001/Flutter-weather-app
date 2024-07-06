import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class WeatherTimes extends StatelessWidget {
  final String time;
  final String url;
  final double temperature;
  const WeatherTimes({super.key, required this.time, required this.url, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 10),

      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(DateTime.parse(time)).hour}:00',
              style: GoogleFonts.lato(fontWeight: FontWeight.w600),
            ),
            Image.network(
              '${Constants.baseUrl + url}.png',
              scale: 1,
            ),
            Text(
              '$temperature°C',
              style: GoogleFonts.lato(fontWeight: FontWeight.w600),
            )

          ],
        ),
      ),
    );
  }
}
