import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// ── Time preset data ───────────────────────────────
class _TimePreset {
  final String id;
  final String label;
  final String time; // HH:mm
  final IconData icon;
  _TimePreset({
    required this.id,
    required this.label,
    required this.time,
    required this.icon,
  });
}

// ── Modal ─────────────────────────────────────────
class RemindMeModal extends StatefulWidget {
  final String? actionTitle;

  const RemindMeModal({super.key, this.actionTitle});

  static Future<void> show(BuildContext context, {String? actionTitle}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RemindMeModal(actionTitle: actionTitle),
    );
  }

  @override
  State<RemindMeModal> createState() => _RemindMeModalState();
}

class _RemindMeModalState extends State<RemindMeModal> {
  final List<_TimePreset> _presets = [
    _TimePreset(id: 'early_evening', label: 'Early Evening', time: '19:00', icon: Icons.wb_twilight),
    _TimePreset(id: 'evening', label: 'Evening', time: '20:00', icon: Icons.nights_stay_outlined),
    _TimePreset(id: 'night', label: 'Night', time: '21:00', icon: Icons.nightlight_round),
    _TimePreset(id: 'bedtime', label: 'Bedtime', time: '21:30', icon: Icons.bed_outlined),
    _TimePreset(id: 'late_night', label: 'Late Night', time: '22:00', icon: Icons.dark_mode_outlined),
  ];

  String _selectedId = 'bedtime';
  String? _editingId;
  bool _loading = false;

  String get _selectedTime =>
      _presets.firstWhere((p) => p.id == _selectedId).time;

  String _fmt(String t) {
    final parts = t.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final ampm = h >= 12 ? 'PM' : 'AM';
    final dh = h % 12 == 0 ? 12 : h % 12;
    return '$dh:$m $ampm';
  }

  void _handlePresetTap(_TimePreset preset) {
    if (_editingId == preset.id) return;
    if (_selectedId == preset.id) {
      // second tap → edit mode
      setState(() => _editingId = preset.id);
    } else {
      setState(() {
        _selectedId = preset.id;
        _editingId = null;
      });
    }
  }

  void _handleTimeChange(String presetId, String newTime) {
    setState(() {
      final i = _presets.indexWhere((p) => p.id == presetId);
      _presets[i] = _TimePreset(
        id: _presets[i].id,
        label: _presets[i].label,
        time: newTime,
        icon: _presets[i].icon,
      );
    });
  }

  void _handleSubmit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.alarm_on, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text('Reminder set for ${_fmt(_selectedTime)} daily!'),
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

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set Daily Reminder',
                        style: AppTextStyles.h3.copyWith(color: textColor)),
                    Text(
                      widget.actionTitle ??
                          'Get a daily reminder to improve your sleep',
                      style: AppTextStyles.bodySmall.copyWith(color: subColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: subColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instruction
                  Row(
                    children: [
                      Icon(Icons.touch_app_outlined, size: 14, color: subColor),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to select · tap again to edit time',
                        style: AppTextStyles.caption.copyWith(color: subColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

          // Presets Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: _presets.length,
            itemBuilder: (context, index) {
              final preset = _presets[index];
              final isSelected = _selectedId == preset.id;
              final isEditing = _editingId == preset.id;

              return GestureDetector(
                onTap: () {
                  if (!isEditing) _handlePresetTap(preset);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(preset.icon,
                          size: 18,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary),
                      const SizedBox(height: 4),
                      Text(
                        preset.label,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.accent : textColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (isEditing)
                        SizedBox(
                          height: 28,
                          child: TextField(
                            autofocus: true,
                            controller:
                                TextEditingController(text: preset.time),
                            keyboardType: TextInputType.datetime,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: AppColors.accent),
                              ),
                            ),
                            onChanged: (v) =>
                                _handleTimeChange(preset.id, v),
                            onSubmitted: (_) =>
                                setState(() => _editingId = null),
                          ),
                        )
                      else
                        Text(
                          _fmt(preset.time),
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: subColor,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Selected time summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm, color: AppColors.accent, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reminder scheduled at',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.accent)),
                    Text(
                      _fmt(_selectedTime),
                      style: AppTextStyles.scoreMedium
                          .copyWith(fontSize: 22, color: textColor),
                    ),
                    Text('Daily · Timezone: EAT',
                        style: AppTextStyles.caption
                            .copyWith(color: subColor, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Cancel',
                      style: TextStyle(color: subColor)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.accentDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Set Reminder',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
        ],
      ),
    );
  }
}
