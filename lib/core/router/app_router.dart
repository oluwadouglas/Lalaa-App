import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/sleep_log/sleep_log_screen.dart';
import '../../features/sleep_log/sleep_history_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/marketplace/marketplace_screen.dart';
import '../../features/habits/habits_screen.dart';
import '../../features/social/circles_screen.dart';
import '../../features/learn/learn_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../shared/widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    // ── Auth Routes (no bottom nav) ──
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),

    // ── Shell Route (with bottom nav) ──
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Branch 0: Home / Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (_, __) => const DashboardScreen(),
            ),
          ],
        ),
        // Branch 1: Learn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (_, __) => const LearnScreen(),
            ),
          ],
        ),
        // Branch 2: Circles
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/circles',
              builder: (_, __) => const CirclesScreen(),
            ),
          ],
        ),
        // Branch 3: Marketplace
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/marketplace',
              builder: (_, __) => const MarketplaceScreen(),
            ),
          ],
        ),
        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Full-screen Routes (above shell) ──
    GoRoute(
      path: '/log-sleep',
      builder: (_, __) => const SleepLogScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (_, __) => const SleepHistoryScreen(),
    ),
    GoRoute(
      path: '/analytics',
      builder: (_, __) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/habits',
      builder: (_, __) => const HabitsScreen(),
    ),
    GoRoute(
      path: '/premium',
      builder: (_, __) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (_, __) => const EditProfileScreen(),
    ),
  ],
);
