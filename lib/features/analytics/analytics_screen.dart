import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_extensions.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data — will be replaced by API
  final List<Map<String, dynamic>> _entries = List.generate(7, (i) => {
    'day': i,
    'score': 60 + (i * 5) % 35,
    'hours': 6.0 + (i * 0.3) % 2.5,
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/dashboard'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: context.hintText,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Score'),
            Tab(text: 'Duration'),
            Tab(text: 'Stages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScoreTab(context),
          _buildDurationTab(context),
          _buildStagesTab(context),
        ],
      ),
    );
  }

  Widget _buildScoreTab(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleep Score Trend',
              style: AppTextStyles.h3.copyWith(color: context.onSurface)),
          const SizedBox(height: 4),
          Text('Last 7 days', style: TextStyle(color: context.hintText, fontSize: 13)),
          const SizedBox(height: 24),
          // Simple bar chart (no fl_chart dependency issue in light mode)
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_entries.length, (i) {
                final score = _entries[i]['score'] as int;
                final barColor = score >= 80 ? AppColors.secondary
                    : score >= 60 ? AppColors.accent : AppColors.destructive;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('$score', style: TextStyle(color: barColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: (score / 100) * 150,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: TextStyle(color: context.hintText, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          _statRow(context, 'Average Score', '${(_entries.map((e) => e['score'] as int).reduce((a, b) => a + b) / _entries.length).round()}'),
          _statRow(context, 'Best Night', '${_entries.map((e) => e['score'] as int).reduce((a, b) => a > b ? a : b)}'),
          _statRow(context, 'Nights Tracked', '${_entries.length}'),
        ],
      ),
    );
  }

  Widget _buildDurationTab(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nightly Duration',
              style: AppTextStyles.h3.copyWith(color: context.onSurface)),
          const SizedBox(height: 4),
          Text('Hours of sleep per night', style: TextStyle(color: context.hintText, fontSize: 13)),
          const SizedBox(height: 24),
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_entries.length, (i) {
                final hours = _entries[i]['hours'] as double;
                final barColor = hours >= 7 ? AppColors.secondary : AppColors.warning;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${hours.toStringAsFixed(1)}h', style: TextStyle(color: barColor, fontSize: 9, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: (hours / 10) * 150,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: TextStyle(color: context.hintText, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          _statRow(context, 'Average Duration', '${(_entries.map((e) => e['hours'] as double).reduce((a, b) => a + b) / _entries.length).toStringAsFixed(1)}h'),
        ],
      ),
    );
  }

  Widget _buildStagesTab(BuildContext context) {
    final stages = [
      (label: 'Deep Sleep', value: 0.20, color: AppColors.deepSleep),
      (label: 'Light Sleep', value: 0.45, color: AppColors.lightSleep),
      (label: 'REM', value: 0.25, color: AppColors.remSleep),
      (label: 'Awake', value: 0.10, color: AppColors.awake),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleep Stage Breakdown',
              style: AppTextStyles.h3.copyWith(color: context.onSurface)),
          const SizedBox(height: 4),
          Text('Last night', style: TextStyle(color: context.hintText, fontSize: 13)),
          const SizedBox(height: 24),
          // Horizontal stacked bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: stages.map((s) => Flexible(
                flex: (s.value * 100).round(),
                child: Container(
                  height: 32,
                  color: s.color,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),
          ...stages.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: s.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(s.label, style: TextStyle(color: context.subText, fontSize: 14))),
                Text('${(s.value * 100).round()}%',
                    style: TextStyle(color: context.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _statRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.subText, fontSize: 14)),
          Text(value, style: TextStyle(color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
