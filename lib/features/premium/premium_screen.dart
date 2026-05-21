import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_extensions.dart';

// ───────────────────────────────────────────────
// PREMIUM FEATURES (matching JS PremiumPage.js)
// ───────────────────────────────────────────────

class _PremiumFeature {
  final IconData icon;
  final String title;
  final String description;
  final String? highlight;
  const _PremiumFeature({required this.icon, required this.title, required this.description, this.highlight});
}

const List<_PremiumFeature> _premiumFeatures = [
  _PremiumFeature(icon: Icons.trending_up, title: '30 & 90 Day Sleep Trends', description: 'See your sleep journey over time with beautiful charts', highlight: 'Most Popular'),
  _PremiumFeature(icon: Icons.favorite, title: 'Your Sleep Age', description: 'Discover your biological sleep age and share with friends', highlight: 'Viral Feature'),
  _PremiumFeature(icon: Icons.calendar_today, title: 'Sleep Consistency Score', description: 'Track how regular your sleep schedule is week over week'),
  _PremiumFeature(icon: Icons.psychology, title: 'Habit Correlation Insights', description: 'Learn which habits improve or hurt your sleep quality'),
  _PremiumFeature(icon: Icons.bar_chart, title: 'Weekday vs Weekend Analysis', description: 'Compare your work week sleep to weekends'),
  _PremiumFeature(icon: Icons.access_time, title: 'Bedtime Drift Analysis', description: 'See if your bedtime is getting later or earlier'),
  _PremiumFeature(icon: Icons.menu_book, title: 'Full Learn Library', description: 'Access all sleep improvement programs and courses'),
  _PremiumFeature(icon: Icons.people, title: 'Circle Analytics Dashboard', description: 'Track your sleep circle performance together'),
];

// ───────────────────────────────────────────────
// PREMIUM SCREEN
// ───────────────────────────────────────────────

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String _selectedPlan = 'monthly';
  bool _loading = false;
  // TODO: Replace with real premium check from auth state
  bool get _isPremium => false;

  String get _priceDisplay => _selectedPlan == 'monthly' ? 'UGX 15,000' : 'UGX 150,000';
  String get _periodLabel => _selectedPlan == 'monthly' ? '/month' : '/year';

  void _handlePayNow() {
    setState(() => _loading = true);
    // TODO: integrate with payment API /payment/initialize
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment integration coming soon. Contact us on WhatsApp.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPremium) return _buildAlreadyPremium();
    return _buildPremiumOffer();
  }

  // ── Already Premium View ──
  Widget _buildAlreadyPremium() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGradient,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(Icons.workspace_premium, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text("You're Premium!", style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text('Enjoy all premium features and insights', style: AppTextStyles.bodyBase.copyWith(color: context.subText)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Back to Dashboard'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Premium Offer View ──
  Widget _buildPremiumOffer() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: () {
              // Share premium features
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGradient,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 30)],
                  ),
                  child: const Icon(Icons.workspace_premium, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.premiumGradient.createShader(bounds),
                  child: Text('Lala Apa Premium', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock deeper insights to transform your sleep and wake up feeling amazing',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyBase.copyWith(color: context.subText),
                ),

                const SizedBox(height: 32),

                // ── Plan Toggle ──
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.mutedFill,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _planToggle('Monthly', 'monthly'),
                      _planToggle('Yearly', 'yearly', badge: 'Save 17%'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Pricing Card ──
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Column(
                    children: [
                      // Price
                      Text(
                        _selectedPlan == 'monthly' ? 'Monthly Plan' : 'Yearly Plan',
                        style: AppTextStyles.bodyBase.copyWith(color: context.subText),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(_priceDisplay, style: AppTextStyles.scoreLarge.copyWith(fontSize: 36)),
                          const SizedBox(width: 6),
                          Text(_periodLabel, style: AppTextStyles.bodyBase.copyWith(color: context.subText)),
                        ],
                      ),
                      if (_selectedPlan == 'yearly') ...[
                        const SizedBox(height: 6),
                        Text(
                          "That's only UGX 12,500/month — save UGX 30,000!",
                          style: AppTextStyles.caption.copyWith(color: AppColors.secondary),
                        ),
                      ],
                      const SizedBox(height: 28),

                      // Features List
                      ..._premiumFeatures.map((f) => _featureRow(f)),

                      const SizedBox(height: 28),

                      // Pay Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handlePayNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.accentDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _loading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.credit_card),
                                    const SizedBox(width: 8),
                                    Text('Pay Now — $_priceDisplay', style: AppTextStyles.button.copyWith(color: AppColors.accentDark)),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text("You've already used your free trial", style: AppTextStyles.bodySmall.copyWith(color: context.hintText)),

                      const SizedBox(height: 20),

                      // Trust Signals
                      Divider(color: context.divider, height: 1),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _trustSignal(Icons.shield_outlined, 'Secure\nPayment', AppColors.secondary),
                          _trustSignal(Icons.bolt, 'Instant\nAccess', AppColors.accent),
                          _trustSignal(Icons.star_outline, 'Cancel\nAnytime', const Color(0xFF3B82F6)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // WhatsApp Contact
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text('Questions about Premium?', style: AppTextStyles.bodyBase.copyWith(color: context.subText)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: launch WhatsApp URL
                        },
                        icon: Icon(Icons.chat_bubble_outline, color: Colors.green[400]),
                        label: Text('Chat with us on WhatsApp', style: TextStyle(color: Colors.green[400])),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Maybe Later
                TextButton(
                  onPressed: () => context.go('/dashboard'),
                  child: Text('Maybe Later', style: AppTextStyles.bodyBase.copyWith(color: context.hintText)),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planToggle(String label, String plan, {String? badge}) {
    final isSelected = _selectedPlan == plan;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : context.subText,
                fontSize: 14,
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: -8, right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _featureRow(_PremiumFeature feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(feature.icon, size: 24, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Flexible(child: Text(feature.title, style: AppTextStyles.label.copyWith(fontSize: 15))),
                if (feature.highlight != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(feature.highlight!, style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontSize: 10)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trustSignal(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(text, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(fontSize: 10, color: context.hintText)),
      ],
    );
  }
}
