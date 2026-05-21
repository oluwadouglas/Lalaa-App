import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

class SleepHistoryScreen extends StatelessWidget {
  const SleepHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo history data
    final history = [
      {'date': DateTime.now().subtract(const Duration(days: 1)), 'duration': 7.5, 'score': 85},
      {'date': DateTime.now().subtract(const Duration(days: 2)), 'duration': 6.2, 'score': 72},
      {'date': DateTime.now().subtract(const Duration(days: 3)), 'duration': 8.1, 'score': 94},
      {'date': DateTime.now().subtract(const Duration(days: 4)), 'duration': 5.5, 'score': 60},
      {'date': DateTime.now().subtract(const Duration(days: 5)), 'duration': 7.8, 'score': 88},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final entry = history[index];
          final date = entry['date'] as DateTime;
          final duration = entry['duration'] as double;
          final score = entry['score'] as int;

          Color scoreColor = AppColors.success;
          if (score < 70) scoreColor = AppColors.error;
          else if (score < 80) scoreColor = AppColors.warning;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.divider),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM d').format(date),
                        style: TextStyle(
                          color: context.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${duration}h sleep duration',
                        style: TextStyle(
                          color: context.subText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: context.hintText),
                  onPressed: () {
                    // Open details
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
