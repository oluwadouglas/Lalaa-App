import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';

/// Shell widget providing the persistent bottom navigation bar
/// with glassmorphism effect — fully theme-aware.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const _navItems = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Learn'),
    (icon: Icons.people_outline, activeIcon: Icons.people, label: 'Circles'),
    (icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Shop'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final navBg = isDark
        ? AppColors.background.withValues(alpha: 0.92)
        : AppColors.lightBackground.withValues(alpha: 0.95);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : AppColors.lightBorder;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: navBg,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_navItems.length, (index) {
                    final item = _navItems[index];
                    final isActive = navigationShell.currentIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => navigationShell.goBranch(
                          index,
                          initialLocation: index == navigationShell.currentIndex,
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isActive ? 4 : 0,
                                height: isActive ? 4 : 0,
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive ? AppColors.primary : Colors.transparent,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  key: ValueKey(isActive),
                                  color: isActive ? AppColors.primary : context.hintText,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: isActive ? AppColors.primary : context.hintText,
                                  fontSize: 11,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
