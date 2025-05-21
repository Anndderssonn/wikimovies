import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() {
    const seedColor = Color(0xFFB71C1C);
    const backgroundColor = Color(0xFF121212);

    return ThemeData(
      colorSchemeSeed: seedColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        bodyLarge: GoogleFonts.montserrat(color: Colors.grey[200]),
        bodyMedium: GoogleFonts.montserrat(color: Colors.grey[200]),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.grey[200],
        ),
        titleMedium: GoogleFonts.montserrat(color: seedColor),
        headlineSmall: GoogleFonts.montserrat(color: Colors.grey[200]),
        labelLarge: GoogleFonts.montserrat(color: Colors.grey[200]),
        titleSmall: GoogleFonts.montserrat(color: Colors.grey[200]),
        bodySmall: GoogleFonts.montserrat(color: Colors.grey[200]),
        labelMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
