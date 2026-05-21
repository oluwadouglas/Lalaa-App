import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware color helpers. Use these instead of raw AppColors constants
/// so widgets automatically adapt when the user switches dark ↔ light mode.
///
/// Usage:
///   context.cardBg       → dark: AppColors.card      light: AppColors.lightCard
///   context.pageBg       → dark: AppColors.background light: AppColors.lightBackground
///   context.onSurface    → dark: AppColors.foreground  light: AppColors.lightTextPrimary
///   context.subText      → dark: AppColors.textSecondary light: AppColors.lightTextSecondary
///   context.hintText     → dark: AppColors.textTertiary  light: AppColors.lightTextSecondary (dimmer)
///   context.divider      → Theme.of(context).dividerColor
///   context.inputFill    → dark: white 5%            light: AppColors.lightBackground
///   context.mutedFill    → dark: surfaceVariant 30%   light: lightBorder 30%
extension ThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Scaffold / page background
  Color get pageBg => Theme.of(this).scaffoldBackgroundColor;

  /// Card / container background
  Color get cardBg => Theme.of(this).cardColor;

  /// Primary text colour
  Color get onSurface => isDark ? AppColors.foreground : AppColors.lightTextPrimary;

  /// Secondary / subtitle text colour
  Color get subText => isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

  /// Tertiary / hint text colour
  Color get hintText => isDark ? AppColors.textTertiary : AppColors.lightTextSecondary;

  /// Divider / border colour
  Color get divider => Theme.of(this).dividerColor;

  /// Subtle card border (same as divider, kept for clarity)
  Color get cardBorder => Theme.of(this).dividerColor;

  /// Muted fill — used for chip/button backgrounds, row highlights
  Color get mutedFill => isDark
      ? AppColors.surfaceVariant.withValues(alpha: 0.4)
      : AppColors.lightBorder.withValues(alpha: 0.5);

  /// Input field fill
  Color get inputFill => isDark
      ? Colors.white.withValues(alpha: 0.05)
      : AppColors.lightBackground;

  /// Section header background (slightly different from card)
  Color get sectionBg => isDark ? AppColors.surface : AppColors.lightSurface;
}
