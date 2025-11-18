/// Archivo de constantes globales para la aplicación Pomodoro Personalizado.
/// Aquí se definen valores fijos usados en la configuración, temas y lógica general.

import 'package:flutter/material.dart';

// Duraciones estándar de sesiones y descansos (en minutos)
class PomodoroDurations {
  static const int work = 25;
  static const int shortBreak = 5;
  static const int longBreak = 15;
  static const int sessionsPerCycle = 4;
}

// Colores base para categorías y temas
class AppColors {
  static const Color work = Color(0xFF1976D2); // Azul
  static const Color study = Color(0xFF388E3C); // Verde
  static const Color rest = Color(0xFFFBC02D); // Amarillo
  static const Color background = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFF7B1FA2); // Morado
}

// Iconos base para categorías
class AppIcons {
  static const String work = 'work';
  static const String study = 'school';
  static const String rest = 'bedtime';
}

// Nombres de categorías estándar
class CategoryNames {
  static const String work = 'Trabajo';
  static const String study = 'Estudio';
  static const String rest = 'Descanso';
}

// Otros valores globales
const String appName = 'Pomodoro Personalizado';
const String defaultCategoryId = 'default';
