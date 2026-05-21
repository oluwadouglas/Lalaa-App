import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// ── Lifestyle option data ──────────────────────────
class _LifestyleOption {
  final String value;
  final String label;
  final String icon;
  final String tip;
  const _LifestyleOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.tip,
  });
}

const List<_LifestyleOption> _kOptions = [
  _LifestyleOption(
    value: 'normal',
    label: 'Normal Day',
    icon: '😊',
    tip: 'Great! A regular day usually means your sleep should be on track. Aim for your usual bedtime.',
  ),
  _LifestyleOption(
    value: 'working_late',
    label: 'Working Late',
    icon: '💼',
    tip: 'Working late raises cortisol. Try a 10-min decompression ritual — close your laptop, dim the lights.',
  ),
  _LifestyleOption(
    value: 'night_out',
    label: 'Night Out',
    icon: '🎉',
    tip: 'If you were out late, try to still sleep 7+ hours. Darkness & cool temps will help reset your rhythm.',
  ),
  _LifestyleOption(
    value: 'social_event',
    label: 'Social Event',
    icon: '🎊',
    tip: 'Social stimulation can keep your mind active. Wind down with 5 minutes of deep breathing.',
  ),
  _LifestyleOption(
    value: 'travel',
    label: 'Travel',
    icon: '✈️',
    tip: 'Travelling disrupts circadian rhythm. Get sunlight in the morning and avoid screens on the flight.',
  ),
  _LifestyleOption(
    value: 'staying_in',
    label: 'Staying In',
    icon: '🏠',
    tip: 'Perfect for quality sleep! Keep your evening screen-free after 9 PM for a deep sleep bonus.',
  ),
  _LifestyleOption(
    value: 'unwell',
    label: 'Not Feeling Well',
    icon: '😷',
    tip: 'Rest is medicine. Sleep > 8 hours if possible, keep the room cool and hydrate well.',
  ),
  _LifestyleOption(
    value: 'stressful',
    label: 'Stressful Day',
    icon: '😰',
    tip: 'Stress spikes cortisol. Try box breathing (4-4-4-4) or light stretching before bed.',
  ),
];

// ── Main Modal Widget ──────────────────────────────
class LogLifestyleModal extends StatefulWidget {
  const LogLifestyleModal({super.key});

  @override
  State<LogLifestyleModal> createState() => _LogLifestyleModalState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LogLifestyleModal(),
    );
  }
}

class _LogLifestyleModalState extends State<LogLifestyleModal>
    with SingleTickerProviderStateMixin {
  String? _selectedContext;
  bool _noisyEnv = false;
  bool _alcoholInvolved = false;
  double _energyLevel = 3;
  bool _saving = false;
  String? _notes;

  late final AnimationController _tipAnimCtrl;
  late Animation<double> _tipFade;

  @override
  void initState() {
    super.initState();
    _tipAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _tipFade = CurvedAnimation(parent: _tipAnimCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _tipAnimCtrl.dispose();
    super.dispose();
  }

  void _select(String value) {
    setState(() => _selectedContext = value);
    _tipAnimCtrl.forward(from: 0);
  }

  _LifestyleOption? get _selected =>
      _selectedContext == null
          ? null
          : _kOptions.firstWhere((o) => o.value == _selectedContext);

  void _handleSave() async {
    if (_selectedContext == null) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(_selected!.icon),
              const SizedBox(width: 8),
              const Text('Lifestyle logged. We\'ll adjust your insights!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : Colors.white;
    final textColor =
        isDark ? AppColors.foreground : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final borderColor =
        isDark ? AppColors.border : AppColors.lightBorder;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 12,
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.auto_awesome,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'What\'s happening tonight?',
                              style:
                                  AppTextStyles.h3.copyWith(color: textColor),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: subColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Log your context so we can personalise your sleep score & tips.',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: subColor),
                      ),
                      const SizedBox(height: 24),

                      // ── Options Grid (2 columns)
                      Text('Choose one',
                          style: AppTextStyles.label
                              .copyWith(color: subColor, fontSize: 11)),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.8,
                        ),
                        itemCount: _kOptions.length,
                        itemBuilder: (context, index) {
                          final opt = _kOptions[index];
                          final isSelected =
                              _selectedContext == opt.value;
                          return GestureDetector(
                            onTap: () => _select(opt.value),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : borderColor,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(opt.icon,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      opt.label,
                                      style: AppTextStyles.label.copyWith(
                                        color: isSelected
                                            ? AppColors.primary
                                            : textColor,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle,
                                        color: AppColors.primary, size: 14),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // ── Personalized Tip
                      if (_selected != null) ...[
                        const SizedBox(height: 16),
                        FadeTransition(
                          opacity: _tipFade,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('💡',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selected!.tip,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: textColor,
                                        height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // ── Energy Level
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.bolt,
                              color: AppColors.accent, size: 18),
                          const SizedBox(width: 6),
                          Text('Energy Level Today',
                              style: AppTextStyles.label
                                  .copyWith(color: textColor, fontSize: 13)),
                          const Spacer(),
                          _energyLabel(_energyLevel),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.accent,
                          inactiveTrackColor:
                              AppColors.accent.withValues(alpha: 0.15),
                          thumbColor: AppColors.accent,
                          overlayColor:
                              AppColors.accent.withValues(alpha: 0.1),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: _energyLevel,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (v) =>
                              setState(() => _energyLevel = v),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Very low',
                              style: AppTextStyles.caption
                                  .copyWith(color: subColor, fontSize: 10)),
                          Text('Very high',
                              style: AppTextStyles.caption
                                  .copyWith(color: subColor, fontSize: 10)),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Divider(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.07)),
                      const SizedBox(height: 16),

                      // ── Optional Toggles
                      Text('Optional details:',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: subColor)),
                      const SizedBox(height: 8),
                      _toggleRow(
                        icon: Icons.volume_up_outlined,
                        label: 'Noisy environment',
                        value: _noisyEnv,
                        onChanged: (v) => setState(() => _noisyEnv = v),
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 4),
                      _toggleRow(
                        icon: Icons.local_bar_outlined,
                        label: 'Alcohol involved',
                        value: _alcoholInvolved,
                        onChanged: (v) =>
                            setState(() => _alcoholInvolved = v),
                        textColor: textColor,
                        isDark: isDark,
                      ),

                      // ── Quick Notes
                      const SizedBox(height: 16),
                      Text('Quick note (optional):',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: subColor)),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 2,
                        maxLength: 120,
                        style: TextStyle(color: textColor, fontSize: 13),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. late dinner, busy day at work…',
                          hintStyle:
                              TextStyle(color: subColor, fontSize: 13),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: AppColors.primary),
                          ),
                          counterStyle:
                              TextStyle(color: subColor, fontSize: 10),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                        onChanged: (v) => _notes = v,
                      ),

                      const SizedBox(height: 24),

                      // ── Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedContext == null || _saving
                              ? null
                              : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.primary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedContext == null
                                          ? 'Select a lifestyle first'
                                          : 'Save Lifestyle',
                                      style: AppTextStyles.button,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _toggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style:
                    AppTextStyles.bodyBase.copyWith(color: textColor, fontSize: 14))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _energyLabel(double v) {
    final labels = {
      1.0: ('😴', 'Very Low'),
      2.0: ('😑', 'Low'),
      3.0: ('😐', 'Medium'),
      4.0: ('😄', 'High'),
      5.0: ('⚡', 'Very High'),
    };
    final data = labels[v] ?? ('😐', 'Medium');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(data.$1, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(data.$2,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.accent, fontSize: 11)),
      ],
    );
  }
}
