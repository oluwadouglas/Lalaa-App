import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../auth/auth_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar & info
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary,
              child: Text(
                (user?.name ?? 'U')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'User',
              style: TextStyle(color: context.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? '',
              style: TextStyle(color: context.hintText, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (user?.isPremium ?? false) ? AppColors.warningLight : context.mutedFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (user?.isPremium ?? false) ? '⭐ Premium' : 'Free Plan',
                style: TextStyle(
                  color: (user?.isPremium ?? false) ? AppColors.warning : context.hintText,
                  fontSize: 12, fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Stats
            Row(
              children: [
                _ProfileStat(value: '14', label: 'Day Streak', icon: Icons.local_fire_department, color: AppColors.primary),
                _ProfileStat(value: '85', label: 'Avg Score', icon: Icons.nights_stay, color: AppColors.accent),
                _ProfileStat(value: '930', label: 'Points', icon: Icons.emoji_events, color: AppColors.warning),
              ],
            ),
            const SizedBox(height: 28),
            // Menu items
            _MenuItem(icon: Icons.person_outline, label: 'Edit Profile', onTap: () => context.push('/edit-profile')),
            _MenuItem(icon: Icons.workspace_premium, label: 'Upgrade to Premium',
                onTap: () => context.push('/premium'), color: AppColors.warning),
            _MenuItem(icon: Icons.history, label: 'Sleep History', onTap: () => context.push('/history')),
            _MenuItem(icon: Icons.bar_chart, label: 'My Analytics', onTap: () => context.push('/analytics')),
            _MenuItem(icon: Icons.info_outline, label: 'About Lala Apa', onTap: () {}),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _ProfileStat({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: context.hintText, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? context.subText),
      title: Text(label, style: TextStyle(color: color ?? context.onSurface, fontSize: 14)),
      trailing: Icon(Icons.chevron_right, color: context.hintText, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
