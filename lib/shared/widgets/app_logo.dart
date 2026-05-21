import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable app logo widget used across auth and branding screens.
class AppLogo extends StatelessWidget {
  final double size;
  final double fontSize;

  const AppLogo({super.key, this.size = 110, this.fontSize = 28});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(size * 0.25),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Lala\nApa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
