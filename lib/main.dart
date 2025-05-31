import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whazlansaja/screen/beranda_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Mobile 2 bersama azlansaja',
      theme: ThemeData(
        colorSchemeSeed: Colors.greenAccent,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        // brightness: Brightness.light,
        // textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home:BerandaScreen(),
    );
  }
}
