import 'package:flutter/material.dart';

class AppColors {
  // White Mode
  static const Color imperialRed =
      Color(0xFFE54B4B); // Headers e fundos destacados
  static const Color seashell = Color(0xFFF7EBE8); // Fundo do app light mode
  static const Color jet = Color.fromRGBO(68, 65, 64, 1); // Letras e detalhes

  // Dark Mode
  static const Color darkBackground =
      jet; // Inversão do seashell para o fundo no dark mode
  static const Color darkText =
      seashell; // Inversão do jet para o texto no dark mode
}
