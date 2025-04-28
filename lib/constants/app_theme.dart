import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de colores primarios
  static const Color primaryColor = Color(0xFF1565C0); // Azul oscuro
  static const Color secondaryColor = Color(0xFF00897B); // Verde azulado
  static const Color accentColor = Color(0xFFFFC107); // Amarillo ámbar (para acentos)
  
  // Aliases para compatibilidad con clases existentes
  static const Color primary = primaryColor;
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color accent = accentColor;
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Colores de fondo
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F5F5);
  
  // Colores para estado de las finanzas
  static const Color success = Color(0xFF4CAF50); // Verde para números positivos
  static const Color error = Color(0xFFF44336); // Rojo para números negativos
  static const Color warning = Color(0xFFFFEB3B); // Amarillo para advertencias
  static const Color info = Color(0xFF2196F3); // Azul para información
  
  // Colores para visualizar finanzas
  static const Color positiveColor = success; // Verde para números positivos
  static const Color negativeColor = error; // Rojo para números negativos
  static const Color warningColor = warning; // Amarillo para advertencias
  
  // Colores para transacciones
  static const Color expense = Color(0xFFF44336);
  static const Color income = Color(0xFF4CAF50);
  static const Color transfer = Color(0xFF9C27B0);
  
  // Paleta de colores para categorías
  static const Color foodColor = Color(0xFF4CAF50); // Verde para alimentación
  static const Color transportColor = Color(0xFF2196F3); // Azul para transporte
  static const Color healthColor = Color(0xFFE91E63); // Rosa para salud
  static const Color educationColor = Color(0xFF9C27B0); // Púrpura para educación
  static const Color utilitiesColor = Color(0xFFFF9800); // Naranja para servicios
  static const Color investmentColor = Color(0xFF795548); // Marrón para inversiones
  
  // Colores adicionales para categorías
  static const Color foodCategory = foodColor;
  static const Color transportCategory = transportColor;
  static const Color homeCategory = Color(0xFF009688);
  static const Color entertainmentCategory = Color(0xFFE91E63);
  static const Color healthCategory = healthColor;
  static const Color educationCategory = educationColor;
  static const Color shoppingCategory = Color(0xFF9C27B0);
  static const Color savingsCategory = Color(0xFF00BCD4);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFE53935)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: Colors.white,
      surface: Colors.white,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
    fontFamily: 'Poppins',
  );
  
  // Tema oscuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onBackground: Colors.white,
      onSurface: Colors.white,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),
    fontFamily: 'Poppins',
  );
} 