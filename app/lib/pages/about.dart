import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactibeter/api/api_common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(image: AssetImage("assets/banner.png"), fit: BoxFit.fitWidth),
                Text(
                  "TactiBeter is een app om snel en eenvoudig je TactiPlan rooster te bekijken",
                  style: GoogleFonts.oxygen(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Server informatie",
                  style: GoogleFonts.oxygen(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Adres",
                      style: GoogleFonts.oxygen(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      server,
                      style: GoogleFonts.oxygen()
                    )
                  ],
                )
              ]
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Contact",
                  style: GoogleFonts.oxygen(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "U kunt contact met ons opnemen via E-Mail: t.debruijn@array21.dev",
                  style: GoogleFonts.oxygen()
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}