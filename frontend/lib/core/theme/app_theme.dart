import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Configuration
/// Defines the application's visual theme following "Crypto Night" Aesthetic.
class AppTheme {
  // Private constructor
  AppTheme._();

  // ============================================================================
  // BRAND COLORS - Crypto Blue (Modern Fintech)
  // ============================================================================
  
  // Base Colors
  static const Color midnightBlue = Color(0xFF0F1115); // Main Background
  static const Color cardGrey = Color(0xFF161B22);     // Card Background
  static const Color deepBlue = Color(0xFF0E131F);     // Darker sections
  static const Color electricBlue = Color(0xFF137FEC); // Primary Brand
  static const Color emeraldAccent = Color(0xFF00D68F);// Success/Growth
  static const Color purpleAccent = Color(0xFF9C27B0); // Secondary Accent
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9CA3AF);
  
  // Functional Colors
  // Functional Colors
  static const Color errorRed = Color(0xFFCF6679);
  static const Color alertRed = Color(0xFFEF4444); // Restored for compatibility
  
  // Premium Deep Dive Colors
  static const Color neonGreen = Color(0xFF13EC92); // Primary
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color glassBorder = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)
  static const Color backgroundDark = Color(0xFF050505);      
  static const Color infoBlue = electricBlue;
  
  // Legacy Aliases (Mapped to new palette for compatibility)
  static const Color obsidianBlack = midnightBlue;
  static const Color carbonSurface = cardGrey;
  static const Color titaniumSilver = textWhite; 
  static const Color mutedGold = emeraldAccent; 
  // neonGreen removed to avoid duplicate declaration

  // Semantic Aliases
  static const Color primaryColor = electricBlue;
  static const Color secondaryColor = emeraldAccent;
  static const Color errorColor = alertRed;
  static const Color surfaceColor = cardGrey;
  static const Color backgroundColor = midnightBlue;
  static const Color successColor = emeraldAccent;

  // Gradients 
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF137FEC), Color(0xFF00D68F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161B22), Color(0xFF1A222D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper Methods
  static const Color neutralColor = textGrey;

  static Color getChartColor(int index) {
    switch (index % 4) {
      case 0: return electricBlue;   // Crypto
      case 1: return emeraldAccent;  // Stocks
      case 2: return purpleAccent;   // Real Estate
      case 3: return textGrey;       // Cash
      default: return electricBlue;
    }
  }

  static Color getChangeColor(double value) {
    if (value > 0) return emeraldAccent;
    if (value < 0) return alertRed;
    return textGrey;
  }

  // ============================================================================
  // THEME DATA GENERATORS
  // ============================================================================

  static ThemeData get darkTheme {
    // Crypto Typography: Manrope (Headings) & Inter (Body)
    final baseTextTheme = GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme);
    final bodyTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return _buildTheme(
      brightness: Brightness.dark,
      background: midnightBlue,
      surface: cardGrey,
      onSurface: textWhite,
      primary: electricBlue,
      baseTextTheme: baseTextTheme,
      bodyTextTheme: bodyTextTheme,
    );
  }

  static ThemeData get lightTheme {
    return darkTheme; // Force Dark Mode for this design
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color primary,
    required TextTheme baseTextTheme,
    required TextTheme bodyTextTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      
      // Color Scheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: emeraldAccent,
        onSecondary: Colors.black,
        error: errorColor,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        tertiary: purpleAccent,
      ),

      // Typography
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: bodyTextTheme.bodyLarge?.copyWith(color: onSurface),
        bodyMedium: bodyTextTheme.bodyMedium?.copyWith(color: textGrey), // Grey by default
        bodySmall: bodyTextTheme.bodySmall?.copyWith(color: textGrey.withOpacity(0.7)),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.8), // Translucent
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 8, // Higher elevation for floating effect
        shadowColor: Colors.black.withOpacity(0.4), // Stronger shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // More rounded (was 16)
          side: BorderSide(
            color: Colors.white.withOpacity(0.02), // Almost invisible border
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      iconTheme: IconThemeData(
        color: onSurface,
        size: 24,
      ),
      
      // Extensions
      extensions: [
        TechTheme(
          lineColor: Colors.white.withOpacity(0.05),
          highlightColor: primary,
          gridSize: 20.0,
          nodeSize: 8.0,
        ),
      ],
    );
  }
}

// ============================================================================
// THEME EXTENSIONS
// ============================================================================

class TechTheme extends ThemeExtension<TechTheme> {
  final Color lineColor;
  final Color highlightColor;
  final double gridSize;
  final double nodeSize;

  const TechTheme({
    required this.lineColor,
    required this.highlightColor,
    required this.gridSize,
    required this.nodeSize,
  });

  @override
  ThemeExtension<TechTheme> copyWith({
    Color? lineColor,
    Color? highlightColor,
    double? gridSize,
    double? nodeSize,
  }) {
    return TechTheme(
      lineColor: lineColor ?? this.lineColor,
      highlightColor: highlightColor ?? this.highlightColor,
      gridSize: gridSize ?? this.gridSize,
      nodeSize: nodeSize ?? this.nodeSize,
    );
  }

  @override
  ThemeExtension<TechTheme> lerp(ThemeExtension<TechTheme>? other, double t) {
    if (other is! TechTheme) return this;
    return TechTheme(
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      gridSize: gridSize + (other.gridSize - gridSize) * t,
      nodeSize: nodeSize + (other.nodeSize - nodeSize) * t,
    );
  }
}
