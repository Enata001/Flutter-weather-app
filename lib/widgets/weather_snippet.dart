import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherSnippet extends StatelessWidget {
  final IconData icon;
  final String text;
  final String prop;

  const WeatherSnippet(
      {super.key, required this.icon, required this.text, required this.prop});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon),
            Text(
              text,
              style: GoogleFonts.lato(fontWeight: FontWeight.w600),
            )
          ],
        ),
        Text(
          prop,
          style: GoogleFonts.lato(fontSize: 10),
        ),
      ],
    );
  }
}
