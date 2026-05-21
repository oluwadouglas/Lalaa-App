import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_extensions.dart';
import 'widgets/log_lifestyle_modal.dart';
import 'widgets/remind_me_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data — will be replaced by API calls
  final String _userName = 'User';
  final bool _isPremium = false;
  final bool _hasRecentLog = true;

  // Recent log mock
  final Map<String, dynamic> _recentLog = {
    'score': 74,
    'band': 'Good',
    'duration': 7.2,
    'timeToSleep': 15,
    'awakenings': 1,
    'diagnosis': 'Your score was pulled down by late bedtime and 1 night awakening.',
    'improveTonightTitle': 'Try going to bed 30 minutes earlier tonight',
    'improveTonightCta': 'Learn',
  };

  // Trends mock
  final Map<String, dynamic> _trends = {
    'avgSleep': 6.8,
    'avgScore': 72,
    'trend': 'improving',
  };

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.secondary;
    if (score >= 60) return AppColors.accent;
    return AppColors.destructive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$_greeting, $_userName',
                      style: AppTextStyles.h2.copyWith(fontSize: 26, color: context.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/logo-main.png', fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.nightlight_round, color: Colors.white, size: 22)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _hasRecentLog ? 'Last tracked: Today' : 'Start tracking your sleep!',
                style: AppTextStyles.bodySmall.copyWith(color: context.subText),
              ),

              const SizedBox(height: 20),

              // ── Quick Actions ──
              Row(
                children: [
                  Expanded(child: _actionButton(icon: Icons.add, label: 'Log Sleep', onTap: () => context.go('/log-sleep'), isPrimary: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _actionButton(icon: Icons.auto_awesome, label: 'Log Lifestyle', onTap: () => LogLifestyleModal.show(context), isPrimary: false)),
                ],
              ),

              const SizedBox(height: 20),

              // ── Last Night's Sleep Card ──
              if (_hasRecentLog) _buildRecentLogCard(),

              const SizedBox(height: 16),

              // ── Streaks ──
              _buildStreaksCard(),

              const SizedBox(height: 16),

              // ── Improve Tonight ──
              if (_recentLog['improveTonightTitle'] != null) _buildImproveTonightCard(),

              const SizedBox(height: 16),

              // ── 7-Day Trends ──
              _buildTrendsCard(),

              const SizedBox(height: 16),

              // ── Score Insights ──
              _buildScoreInsightsCard(),

              const SizedBox(height: 16),

              // ── Quick Nav ──
              Row(
                children: [
                  Expanded(child: _navTile(Icons.menu_book, 'Learn', () => context.go('/learn'))),
                  const SizedBox(width: 12),
                  Expanded(child: _navTile(Icons.feedback_outlined, 'Feedback', () {})),
                ],
              ),

              const SizedBox(height: 16),

              // ── Premium Upsell ──
              if (!_isPremium) _buildPremiumBanner(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLogCard() {
    final score = _recentLog['score'] as int;
    final band = _recentLog['band'] as String;
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.nightlight_round, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text("Last Night's Sleep", style: AppTextStyles.label.copyWith(fontSize: 16, color: context.onSurface)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _scoreColor(score).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(band, style: AppTextStyles.caption.copyWith(color: _scoreColor(score))),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _statBlock('Sleep Score', score.toString(), _scoreColor(score)),
              _statBlock('Duration', '${_recentLog['duration']}h', context.onSurface),
              _statBlock('To Sleep', '${_recentLog['timeToSleep']} min', context.onSurface),
              _statBlock('Woke Up', '${_recentLog['awakenings']}x', context.onSurface),
            ],
          ),
          if (_recentLog['diagnosis'] != null) ...[
            const SizedBox(height: 16),
            Divider(color: context.divider),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.mutedFill,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Why this score?', style: AppTextStyles.label.copyWith(fontSize: 13, color: context.onSurface)),
                  const SizedBox(height: 4),
                  Text(_recentLog['diagnosis'], style: AppTextStyles.bodySmall.copyWith(color: context.subText)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBlock(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, color: context.hintText)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.scoreMedium.copyWith(fontSize: 24, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildStreaksCard() {
    return _glassCard(
      child: Row(
        children: [
          Expanded(child: _streakItem('🔥', '3', 'Logging\nStreak')),
          Container(width: 1, height: 50, color: context.divider),
          Expanded(child: _streakItem('⏰', '2', 'Rhythm\nStreak')),
        ],
      ),
    );
  }

  Widget _streakItem(String emoji, String count, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(count, style: AppTextStyles.scoreMedium.copyWith(fontSize: 28, color: AppColors.accent)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(fontSize: 10, color: context.subText)),
      ],
    );
  }

  Widget _buildImproveTonightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 20, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('Improve Tonight', style: AppTextStyles.label.copyWith(fontSize: 16, color: context.onSurface)),
            ],
          ),
          const SizedBox(height: 12),
          Text(_recentLog['improveTonightTitle'], style: AppTextStyles.bodyBase.copyWith(color: context.onSurface)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => context.go('/learn'), child: const Text('Learn More'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(
                onPressed: () => RemindMeModal.show(context, actionTitle: _recentLog['improveTonightTitle']),
                icon: const Icon(Icons.notifications_outlined, size: 16),
                label: const Text('Remind Me'),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text('Last 7 Days', style: AppTextStyles.label.copyWith(fontSize: 16, color: context.onSurface)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avg Sleep', style: AppTextStyles.caption.copyWith(color: context.subText)),
                    const SizedBox(height: 4),
                    Text('${_trends['avgSleep']}h', style: AppTextStyles.scoreMedium.copyWith(color: AppColors.secondary, fontSize: 28)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avg Score', style: AppTextStyles.caption.copyWith(color: context.subText)),
                    const SizedBox(height: 4),
                    Text('${_trends['avgScore']}', style: AppTextStyles.scoreMedium.copyWith(color: _scoreColor(_trends['avgScore']), fontSize: 28)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                      child: Text('↑ Improving', style: AppTextStyles.caption.copyWith(color: AppColors.secondary, fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: () => context.go('/analytics'), child: const Text('View Detailed Analytics')),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInsightsCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.emoji_events, size: 20, color: AppColors.accent),
                const SizedBox(width: 8),
                Text('What Your Score Means', style: AppTextStyles.label.copyWith(fontSize: 16, color: context.onSurface)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_upward, size: 12, color: AppColors.secondary),
                  Text(' Improving', style: AppTextStyles.caption.copyWith(color: AppColors.secondary, fontSize: 10)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your average score of 72 is Good. You\'re sleeping enough but could improve consistency.',
            style: AppTextStyles.bodySmall.copyWith(color: context.subText),
          ),
          const SizedBox(height: 16),
          Text('Key Factors:', style: AppTextStyles.label.copyWith(fontSize: 13, color: context.onSurface)),
          const SizedBox(height: 8),
          _factorRow('Duration', '7.2h — Good', true),
          _factorRow('Consistency', 'Irregular bedtime', false),
          _factorRow('Awakenings', '1x avg — Normal', true),
          const SizedBox(height: 16),
          Divider(color: context.divider),
          const SizedBox(height: 12),
          Text('How to Improve:', style: AppTextStyles.label.copyWith(fontSize: 13, color: context.onSurface)),
          const SizedBox(height: 8),
          _tipRow('Set a consistent bedtime within 30 min each night'),
          _tipRow('Avoid screens 30 minutes before bed'),
          _tipRow('Keep your room cool and dark'),
        ],
      ),
    );
  }

  Widget _factorRow(String factor, String detail, bool positive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(factor, style: AppTextStyles.bodySmall.copyWith(color: context.subText)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (positive ? AppColors.secondary : AppColors.destructive).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(detail, style: AppTextStyles.caption.copyWith(
              color: positive ? AppColors.secondary : AppColors.destructive, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _tipRow(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: AppColors.accent)),
          Expanded(child: Text(tip, style: AppTextStyles.bodySmall.copyWith(color: context.subText))),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✨ Upgrade to Premium', style: AppTextStyles.label.copyWith(color: AppColors.accent, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Get unlimited insights, ad-free experience, and exclusive content',
              style: AppTextStyles.bodySmall.copyWith(color: context.subText)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/premium'),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5))),
              child: Text('Learn More', style: TextStyle(color: AppColors.accent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navTile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: context.onSurface),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: context.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required VoidCallback onTap, required bool isPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          boxShadow: isPrimary
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isPrimary ? Colors.white : AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.button.copyWith(color: isPrimary ? Colors.white : AppColors.primary)),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.divider),
      ),
      child: child,
    );
  }
}
