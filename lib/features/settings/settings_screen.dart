import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifBedtime = true;
  bool _notifWakeup = true;
  bool _notifWeekly = false;

  TimeOfDay _defaultBedtime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _defaultWakeTime = const TimeOfDay(hour: 6, minute: 30);

  Future<void> _pickTime(bool isBedtime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isBedtime ? _defaultBedtime : _defaultWakeTime,
    );
    if (picked != null) {
      setState(() {
        if (isBedtime) _defaultBedtime = picked;
        else _defaultWakeTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle('Sleep Schedule'),
          _ActionTile(
            'Default Bedtime',
            Icons.bedtime,
            () => _pickTime(true),
            trailingText: _defaultBedtime.format(context),
          ),
          _ActionTile(
            'Target Wake Time',
            Icons.wb_sunny,
            () => _pickTime(false),
            trailingText: _defaultWakeTime.format(context),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Notifications'),
          _ToggleTile('Bedtime Reminder', 'Get reminded when it\'s time to sleep', _notifBedtime, (v) => setState(() => _notifBedtime = v)),
          _ToggleTile('Wake-up Alarm', 'Morning alarm at your target wake time', _notifWakeup, (v) => setState(() => _notifWakeup = v)),
          _ToggleTile('Weekly Summary', 'Receive a weekly sleep report', _notifWeekly, (v) => setState(() => _notifWeekly = v)),
          const SizedBox(height: 24),
          _SectionTitle('Appearance'),
          _ToggleTile(
            'Dark Mode',
            'Switch to dark theme',
            ref.watch(themeModeProvider) == ThemeMode.dark,
            (v) => ref.read(themeModeProvider.notifier).setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Account'),
          _ActionTile('Change Password', Icons.lock_outline, () {}),
          _ActionTile('Privacy Policy', Icons.privacy_tip_outlined, () {}),
          _ActionTile('Terms of Service', Icons.description_outlined, () {}),
          const SizedBox(height: 24),
          _SectionTitle('About'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lala Apa', style: TextStyle(fontWeight: FontWeight.bold, color: context.onSurface)),
                const SizedBox(height: 4),
                Text('Version 1.0.0', style: TextStyle(color: context.hintText, fontSize: 13)),
                const SizedBox(height: 4),
                Text('Sleep wellness companion', style: TextStyle(color: context.hintText, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: TextStyle(
            color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
      );
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile(this.title, this.subtitle, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: 14, color: context.onSurface)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: context.hintText)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      );
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;

  const _ActionTile(this.title, this.icon, this.onTap, {this.trailingText});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: context.subText, size: 20),
        title: Text(title, style: TextStyle(fontSize: 14, color: context.onSurface)),
        trailing: trailingText != null
            ? Text(trailingText!, style: TextStyle(color: context.hintText, fontSize: 14, fontWeight: FontWeight.w600))
            : Icon(Icons.chevron_right, size: 18, color: context.hintText),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      );
}
