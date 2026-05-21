import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_extensions.dart';

// ── Constants ──

class _ComfortOption {
  final int value;
  final String emoji;
  final String label;
  const _ComfortOption(this.value, this.emoji, this.label);
}

const _comfortOptions = [
  _ComfortOption(1, '😣', 'Very Bad'),
  _ComfortOption(2, '😕', 'Bad'),
  _ComfortOption(3, '👍', 'Okay'),
  _ComfortOption(4, '😊', 'Good'),
  _ComfortOption(5, '🔥', 'Amazing'),
];

class _ChipOption {
  final int value;
  final String label;
  final String? emoji;
  const _ChipOption(this.value, this.label, [this.emoji]);
}

const _latencyOptions = [
  _ChipOption(2, '0-5 min'),
  _ChipOption(10, '5-15 min'),
  _ChipOption(22, '15-30 min'),
  _ChipOption(45, '30-60 min'),
  _ChipOption(75, '60+ min'),
];

const _wakeOptions = [
  _ChipOption(0, 'None', '😴'),
  _ChipOption(1, '1 time', '🌙'),
  _ChipOption(2, '2 times', '🌙'),
  _ChipOption(3, '3 times', '😪'),
  _ChipOption(4, '4+ times', '😩'),
];

const _moodOptions = [
  _ComfortOption(1, '😫', 'Very Bad'),
  _ComfortOption(2, '😔', 'Bad'),
  _ComfortOption(3, '😐', 'Okay'),
  _ComfortOption(4, '🙂', 'Good'),
  _ComfortOption(5, '😁', 'Great'),
];

class _AffectorOption {
  final String id;
  final String label;
  final String emoji;
  const _AffectorOption(this.id, this.label, this.emoji);
}

const _sleepAffectors = [
  _AffectorOption('heat', 'Heat / Hot room', '🔥'),
  _AffectorOption('mosquitoes', 'Mosquitoes', '🦟'),
  _AffectorOption('power_outage', 'Power outage', '⚡'),
  _AffectorOption('outside_noise', 'Outside noise', '🔊'),
  _AffectorOption('bed_partner', 'Bed partner', '👥'),
  _AffectorOption('stress', 'Stress / Worry', '😰'),
  _AffectorOption('late_meal', 'Late meal', '🍽️'),
  _AffectorOption('late_phone', 'Late phone use', '📱'),
];

const _pressurePoints = ['Neck', 'Shoulders', 'Back', 'Hips', 'Knees', 'Other'];

// ── Screen ──

class SleepLogScreen extends StatefulWidget {
  const SleepLogScreen({super.key});
  @override
  State<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends State<SleepLogScreen> {
  int _step = 1;

  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 0);
  int? _latency;
  int? _wakeInterruptions;

  int? _comfortRating;
  int? _wakeMood;
  final List<String> _selectedAffectors = [];
  final List<String> _selectedPressurePoints = [];
  bool _morningOpen = false;

  bool _loading = false;

  double get _durationHours {
    int sleepMin = _sleepTime.hour * 60 + _sleepTime.minute;
    int wakeMin = _wakeTime.hour * 60 + _wakeTime.minute;
    if (wakeMin <= sleepMin) wakeMin += 24 * 60;
    return (wakeMin - sleepMin) / 60.0;
  }

  Color get _durationColor {
    if (_durationHours >= 7) return AppColors.secondary;
    if (_durationHours >= 6) return AppColors.accent;
    return AppColors.destructive;
  }

  String get _durationLabel {
    if (_durationHours >= 7) return 'Great!';
    if (_durationHours >= 6) return 'Okay';
    return 'Low';
  }

  Future<void> _pickTime(bool isSleep) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isSleep ? _sleepTime : _wakeTime,
    );
    if (picked != null) {
      setState(() {
        if (isSleep) {
          _sleepTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
    }
  }

  void _handleSave() {
    if (_comfortRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please rate your mattress comfort')),
      );
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sleep logged! Duration: ${_durationHours.toStringAsFixed(1)}h')),
        );
        context.go('/dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _step == 1 ? context.go('/dashboard') : setState(() => _step = 1),
                    child: Icon(Icons.arrow_back_rounded, color: context.onSurface),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Log Your Sleep', style: AppTextStyles.h3.copyWith(fontSize: 20, color: context.onSurface)),
                        Text('Step $_step of 2', style: AppTextStyles.caption.copyWith(color: context.subText)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _dot(_step >= 1),
                      const SizedBox(width: 6),
                      _dot(_step >= 2),
                    ],
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _step == 1 ? _buildStep1() : _buildStep2(),
              ),
            ),

            // ── Bottom Button ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _step == 1 ? () => setState(() => _step = 2) : (_loading ? null : _handleSave),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_step == 1 ? 'Continue' : 'Save Sleep Log', style: AppTextStyles.button),
                            const SizedBox(width: 8),
                            Icon(_step == 1 ? Icons.arrow_forward : Icons.check, size: 20),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) => Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? AppColors.primary : context.mutedFill,
        ),
      );

  Widget _buildStep1() {
    return Column(
      children: [
        const SizedBox(height: 8),
        _card(
          icon: Icons.access_time_rounded,
          iconColor: AppColors.primary,
          title: 'Sleep Timing',
          subtitle: 'When did you sleep last night?',
          child: Column(
            children: [
              _timeRow('🛏  Sleep Time', _sleepTime, true),
              const SizedBox(height: 16),
              _timeRow('⏰  Wake Time', _wakeTime, false),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.mutedFill,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sleep Duration', style: AppTextStyles.bodySmall.copyWith(color: context.subText)),
                    Row(
                      children: [
                        Text('${_durationHours.toStringAsFixed(1)}h', style: AppTextStyles.scoreMedium.copyWith(color: _durationColor, fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(_durationLabel, style: AppTextStyles.caption.copyWith(color: _durationColor)),
                      ],
                    ),
                  ],
                ),
              ),
              if (_durationHours < 7) ...[
                const SizedBox(height: 8),
                Text('Recommended: 7-9 hours for adults', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'How long did it take to fall asleep?',
          subtitle: 'Tap one',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _latencyOptions.map((opt) => _chipButton(opt.label, _latency == opt.value, () => setState(() => _latency = opt.value))).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'How many times did you wake up?',
          subtitle: 'Night awakenings (not including final wake-up)',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _wakeOptions.map((opt) => _chipButton('${opt.emoji ?? ""} ${opt.label}', _wakeInterruptions == opt.value, () => setState(() => _wakeInterruptions = opt.value))).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const SizedBox(height: 8),
        _card(
          icon: Icons.nightlight_round,
          iconColor: AppColors.accent,
          title: 'Mattress Comfort',
          subtitle: 'How did your mattress feel last night?',
          child: Column(
            children: [
              Row(
                children: _comfortOptions.map((opt) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _comfortRating = opt.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _comfortRating == opt.value
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : context.mutedFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _comfortRating == opt.value ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(opt.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(opt.label.split(' ').first, style: AppTextStyles.caption.copyWith(fontSize: 10, color: context.subText)),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
              if (_comfortRating != null && _comfortRating! <= 2) ...[
                const SizedBox(height: 20),
                Divider(color: context.divider),
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft, child: Text('Where did you feel discomfort?', style: AppTextStyles.label.copyWith(color: context.onSurface))),
                const SizedBox(height: 4),
                Align(alignment: Alignment.centerLeft, child: Text('Tap all that apply', style: AppTextStyles.caption.copyWith(color: context.subText))),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _pressurePoints.map((p) {
                    final sel = _selectedPressurePoints.contains(p.toLowerCase());
                    return _chipButton(p, sel, () {
                      setState(() {
                        final id = p.toLowerCase();
                        sel ? _selectedPressurePoints.remove(id) : _selectedPressurePoints.add(id);
                      });
                    }, selectedColor: AppColors.destructive);
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _accordionCard(
          emoji: '☀️',
          title: 'Morning Check-in',
          subtitle: 'Optional',
          isOpen: _morningOpen,
          onToggle: () => setState(() => _morningOpen = !_morningOpen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wake-up Mood', style: AppTextStyles.label.copyWith(color: context.onSurface)),
              const SizedBox(height: 4),
              Text('How do you feel this morning?', style: AppTextStyles.caption.copyWith(color: context.subText)),
              const SizedBox(height: 12),
              Row(
                children: _moodOptions.map((opt) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _wakeMood = opt.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _wakeMood == opt.value ? AppColors.primary.withValues(alpha: 0.2) : context.mutedFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _wakeMood == opt.value ? AppColors.primary : Colors.transparent, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(opt.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 2),
                          Text(opt.label.split(' ').first, style: AppTextStyles.caption.copyWith(fontSize: 9, color: context.subText)),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('What affected your sleep?', style: AppTextStyles.label.copyWith(color: context.onSurface)),
                  Text('(tap all that apply)', style: AppTextStyles.caption.copyWith(color: context.subText)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sleepAffectors.map((a) {
                  final sel = _selectedAffectors.contains(a.id);
                  return _chipButton('${a.emoji} ${a.label}', sel, () {
                    setState(() => sel ? _selectedAffectors.remove(a.id) : _selectedAffectors.add(a.id));
                  });
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _card({IconData? icon, Color? iconColor, required String title, String? subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: iconColor ?? AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.label.copyWith(fontSize: 16, color: context.onSurface)),
                      if (subtitle != null) Text(subtitle, style: AppTextStyles.caption.copyWith(color: context.subText)),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Text(title, style: AppTextStyles.label.copyWith(color: context.onSurface)),
            if (subtitle != null) Text(subtitle, style: AppTextStyles.caption.copyWith(color: context.subText)),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _accordionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool isOpen,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.divider),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.label.copyWith(color: context.onSurface)),
                        Text(subtitle, style: AppTextStyles.caption.copyWith(color: context.subText)),
                      ],
                    ),
                  ),
                  Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: context.hintText),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Divider(color: context.divider),
                  const SizedBox(height: 12),
                  child,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _timeRow(String label, TimeOfDay time, bool isSleep) {
    return GestureDetector(
      onTap: () => _pickTime(isSleep),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.mutedFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyBase.copyWith(color: context.onSurface)),
            Text(time.format(context), style: AppTextStyles.scoreMedium.copyWith(fontSize: 24, color: context.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _chipButton(String label, bool selected, VoidCallback onTap, {Color? selectedColor}) {
    final color = selectedColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : context.mutedFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: selected ? color : context.subText,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
