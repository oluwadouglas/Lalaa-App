import 'package:flutter/material.dart';

/// Centralized "Afro-Luxe Nocturne" color palette for Lala Apa.
/// Dark-mode-first — the app lives in the bedroom.
class AppColors {
  AppColors._();

  // ── Brand Colors (from design_guidelines.json) ──
  static const Color primary = Color(0xFFC2410C);         // Warm orange
  static const Color primaryLight = Color(0xFFEA580C);
  static const Color primaryDark = Color(0xFF9A3412);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF10B981);        // Emerald green
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF064E3B);
  static const Color secondaryForeground = Color(0xFF064E3B);

  static const Color accent = Color(0xFFF59E0B);           // Amber / Gold
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFF451A03);
  static const Color accentForeground = Color(0xFF451A03);

  // ── Semantic Colors ──
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF064E3B);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFF451A03);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFF7F1D1D);
  static const Color info = Color(0xFF3B82F6);
  static const Color destructive = Color(0xFFF87171);

  // ── Dark Theme Base (Default) ──
  static const Color background = Color(0xFF0F172A);       // Deep navy
  static const Color foreground = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFF1E293B);           // Card background
  static const Color surfaceVariant = Color(0xFF334155);
  static const Color card = Color(0xFF1E293B);
  static const Color cardForeground = Color(0xFFF8FAFC);
  static const Color popover = Color(0xFF1E293B);
  static const Color border = Color(0xFF334155);
  static const Color borderLight = Color(0xFF475569);
  static const Color input = Color(0xFF334155);
  static const Color muted = Color(0xFF334155);
  static const Color mutedForeground = Color(0xFF94A3B8);

  // ── Text Colors ──
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF475569);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF9FAFB);

  // ── Light Theme Override ──
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF8FAFC);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);

  // ── Gradient Presets (from design_guidelines.json) ──
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)],
  );

  static const LinearGradient sleepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF050510)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFC2410C), Color(0xFFEA580C)],
  );

  // ── Sleep Stage Colors (from design_guidelines.json) ──
  static const Color deepSleep = Color(0xFF4F46E5);
  static const Color lightSleep = Color(0xFF818CF8);
  static const Color remSleep = Color(0xFFC7D2FE);
  static const Color awake = Color(0xFFF87171);

  // ── Chart Colors ──
  static const List<Color> chartPalette = [
    Color(0xFFC2410C), // primary
    Color(0xFF10B981), // secondary
    Color(0xFFF59E0B), // accent
    Color(0xFF4F46E5), // deep sleep
    Color(0xFF818CF8), // light sleep
    Color(0xFFF87171), // awake/destructive
  ];

  // ── Glass Card helper ──
  static Color glassCard = const Color(0xFF1E293B).withValues(alpha: 0.5);
  static Color glassBorder = Colors.white.withValues(alpha: 0.05);
}
