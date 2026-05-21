import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ───────────────────────────────────────────────
// SLEEP TYPE QUIZ DATA (matching JS OnboardingPage.js)
// ───────────────────────────────────────────────

class QuizQuestion {
  final String id;
  final String question;
  final IconData icon;
  final List<QuizOption> options;
  const QuizQuestion({required this.id, required this.question, required this.icon, required this.options});
}

class QuizOption {
  final String emoji;
  final String label;
  final String value;
  const QuizOption({required this.emoji, required this.label, required this.value});
}

final List<QuizQuestion> _sleepQuiz = [
  const QuizQuestion(
    id: 'wake_feeling',
    question: 'How do you typically feel when you wake up?',
    icon: Icons.wb_sunny_rounded,
    options: [
      QuizOption(emoji: '😴', label: 'Still tired', value: 'tired'),
      QuizOption(emoji: '😐', label: 'Okay, not great', value: 'okay'),
      QuizOption(emoji: '😊', label: 'Refreshed', value: 'refreshed'),
      QuizOption(emoji: '😫', label: 'Exhausted', value: 'exhausted'),
    ],
  ),
  const QuizQuestion(
    id: 'time_to_sleep',
    question: 'How long does it take you to fall asleep?',
    icon: Icons.access_time_rounded,
    options: [
      QuizOption(emoji: '⚡', label: 'Under 10 minutes', value: 'quick'),
      QuizOption(emoji: '🌙', label: '10-30 minutes', value: 'normal'),
      QuizOption(emoji: '😰', label: '30-60 minutes', value: 'long'),
      QuizOption(emoji: '😵', label: 'Over an hour', value: 'very_long'),
    ],
  ),
  const QuizQuestion(
    id: 'disturbance',
    question: 'What disturbs your sleep the most?',
    icon: Icons.volume_up_rounded,
    options: [
      QuizOption(emoji: '🔥', label: 'Heat / Hot room', value: 'heat'),
      QuizOption(emoji: '🔊', label: 'Noise', value: 'noise'),
      QuizOption(emoji: '😰', label: 'Stress / Worry', value: 'stress'),
      QuizOption(emoji: '🤕', label: 'Physical pain', value: 'pain'),
    ],
  ),
  const QuizQuestion(
    id: 'position',
    question: 'What is your usual sleeping position?',
    icon: Icons.airline_seat_flat_rounded,
    options: [
      QuizOption(emoji: '🛌', label: 'On my side', value: 'side'),
      QuizOption(emoji: '🧘', label: 'On my back', value: 'back'),
      QuizOption(emoji: '😴', label: 'On my stomach', value: 'stomach'),
      QuizOption(emoji: '🔄', label: 'I move around a lot', value: 'restless'),
    ],
  ),
  const QuizQuestion(
    id: 'awakenings',
    question: 'How often do you wake up during the night?',
    icon: Icons.nightlight_round,
    options: [
      QuizOption(emoji: '😴', label: 'Rarely / Never', value: 'rarely'),
      QuizOption(emoji: '🌙', label: 'Once or twice', value: 'sometimes'),
      QuizOption(emoji: '😪', label: 'Several times', value: 'often'),
      QuizOption(emoji: '😩', label: 'I barely stay asleep', value: 'constant'),
    ],
  ),
  const QuizQuestion(
    id: 'mattress_feel',
    question: 'How does your mattress feel?',
    icon: Icons.bed_rounded,
    options: [
      QuizOption(emoji: '🪨', label: 'Too firm', value: 'too_firm'),
      QuizOption(emoji: '☁️', label: 'Too soft / saggy', value: 'too_soft'),
      QuizOption(emoji: '😊', label: 'Just right', value: 'just_right'),
      QuizOption(emoji: '🤷', label: 'Not sure', value: 'unsure'),
    ],
  ),
];

// ───────────────────────────────────────────────
// SLEEP TYPES (from JS)
// ───────────────────────────────────────────────

class SleepType {
  final String name;
  final String emoji;
  final String description;
  final Color color;
  const SleepType({required this.name, required this.emoji, required this.description, required this.color});
}

const Map<String, SleepType> _sleepTypes = {
  'light': SleepType(
    name: 'The Light Sleeper',
    emoji: '🌙',
    description: 'You wake up easily and are sensitive to your environment. Small changes in noise, light, or temperature can disrupt your sleep.',
    color: Color(0xFF818CF8),
  ),
  'restless': SleepType(
    name: 'The Restless Sleeper',
    emoji: '🔄',
    description: 'You move around a lot and may struggle to find a comfortable position. Your sleep quality varies night to night.',
    color: Color(0xFFF59E0B),
  ),
  'deep': SleepType(
    name: 'The Deep Sleeper',
    emoji: '😴',
    description: 'You sleep deeply but may not be getting enough restorative sleep. Focus on consistency and duration.',
    color: Color(0xFF4F46E5),
  ),
  'anxious': SleepType(
    name: 'The Anxious Sleeper',
    emoji: '😰',
    description: 'Stress and worry keep your mind active at night. Relaxation techniques and wind-down routines can help tremendously.',
    color: Color(0xFFF87171),
  ),
  'comfort_seeker': SleepType(
    name: 'The Comfort Seeker',
    emoji: '🛏️',
    description: 'Physical comfort is key for your sleep. Your mattress, pillows, and bedding environment significantly impact your rest.',
    color: Color(0xFFC2410C),
  ),
};

String _determineSleepType(Map<String, String> answers) {
  if (answers['disturbance'] == 'stress' || answers['time_to_sleep'] == 'very_long') return 'anxious';
  if (answers['disturbance'] == 'pain' || answers['mattress_feel'] == 'too_firm' || answers['mattress_feel'] == 'too_soft') return 'comfort_seeker';
  if (answers['position'] == 'restless' || answers['awakenings'] == 'constant') return 'restless';
  if (answers['awakenings'] == 'rarely' && answers['wake_feeling'] == 'refreshed') return 'deep';
  return 'light';
}

// ───────────────────────────────────────────────
// ONBOARDING SCREEN — 11 Step Wizard
// ───────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  int _currentStep = 0; // 0..10 = 11 steps total
  final Map<String, String> _quizAnswers = {};
  String? _selectedOption;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Steps: 0=Welcome, 1=QuizIntro, 2-7=Quiz(6), 8=Result, 9=Features, 10=Challenge
  static const int _welcomeStep = 0;
  static const int _quizIntroStep = 1;
  static const int _quizStartStep = 2;
  static const int _quizEndStep = 7;
  static const int _resultStep = 8;
  static const int _featuresStep = 9;
  static const int _challengeStep = 10;
  static const int _totalSteps = 11;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  bool _isAnimating = false;

  void _goNext() {
    if (_isAnimating) return;

    // If on a quiz step, save answer
    if (_currentStep >= _quizStartStep && _currentStep <= _quizEndStep && _selectedOption != null) {
      final qi = _currentStep - _quizStartStep;
      _quizAnswers[_sleepQuiz[qi].id] = _selectedOption!;
      _selectedOption = null;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _isAnimating = true);
      _fadeController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _currentStep++;
          _isAnimating = false;
        });
        _fadeController.forward();
      });
    } else {
      // Done — go to dashboard
      context.go('/dashboard');
    }
  }

  void _goBack() {
    if (_isAnimating) return;

    if (_currentStep > 0) {
      setState(() => _isAnimating = true);
      _fadeController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          if (_currentStep >= _quizStartStep && _currentStep <= _quizEndStep) {
            final qi = _currentStep - _quizStartStep;
            _selectedOption = _quizAnswers[_sleepQuiz[qi].id];
          }
          _currentStep--;
          _isAnimating = false;
        });
        _fadeController.forward();
      });
    }
  }

  double get _progress => (_currentStep + 1) / _totalSteps;

  bool get _canProceed {
    if (_currentStep >= _quizStartStep && _currentStep <= _quizEndStep) {
      return _selectedOption != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Progress Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      GestureDetector(
                        onTap: _goBack,
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary, size: 22),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_currentStep + 1}/$_totalSteps',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildStep(),
                ),
              ),

              // ── Bottom Button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _buildBottomButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    if (_currentStep == _welcomeStep) return _buildWelcome();
    if (_currentStep == _quizIntroStep) return _buildQuizIntro();
    if (_currentStep >= _quizStartStep && _currentStep <= _quizEndStep) {
      return _buildQuizStep(_sleepQuiz[_currentStep - _quizStartStep]);
    }
    if (_currentStep == _resultStep) return _buildResult();
    if (_currentStep == _featuresStep) return _buildFeatures();
    if (_currentStep == _challengeStep) return _buildChallenge();
    return const SizedBox();
  }

  // ── Step 0: Welcome ──
  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset('assets/images/logo-main.png', fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.nightlight_round, size: 64, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
          Text('Welcome to\nLala Apa', textAlign: TextAlign.center, style: AppTextStyles.h1.copyWith(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            'Your Personal Sleep Intelligence.\nTrack, understand, and improve your sleep.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Quiz Intro ──
  Widget _buildQuizIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔮', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text('Discover Your\nSleep Type', textAlign: TextAlign.center, style: AppTextStyles.h2),
          const SizedBox(height: 16),
          Text(
            'Answer 6 quick questions and we\'ll identify your unique sleep personality to personalize your experience.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBase.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _miniFeature(Icons.timer, 'Takes 1 min'),
              const SizedBox(width: 32),
              _miniFeature(Icons.auto_awesome, 'Personalized'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  // ── Steps 2-7: Quiz Questions ──
  Widget _buildQuizStep(QuizQuestion question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(question.icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(question.question, style: AppTextStyles.h3),
          const SizedBox(height: 32),
          ...question.options.map((option) => _buildQuizOption(option)),
        ],
      ),
    );
  }

  Widget _buildQuizOption(QuizOption option) {
    final isSelected = _selectedOption == option.value;
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = option.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(child: Text(option.label, style: AppTextStyles.bodyBase.copyWith(
              color: isSelected ? AppColors.foreground : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ))),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Step 8: Quiz Result ──
  Widget _buildResult() {
    final typeKey = _determineSleepType(_quizAnswers);
    final type = _sleepTypes[typeKey]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(type.emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text('You are...', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 8),
          Text(type.name, textAlign: TextAlign.center, style: AppTextStyles.h2.copyWith(color: type.color)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: type.color.withValues(alpha: 0.3)),
            ),
            child: Text(type.description, textAlign: TextAlign.center, style: AppTextStyles.bodyBase.copyWith(color: AppColors.foreground)),
          ),
        ],
      ),
    );
  }

  // ── Step 9: Feature Previews ──
  Widget _buildFeatures() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text('What You Can Do', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Lala Apa helps you improve your sleep in multiple ways.', textAlign: TextAlign.center, style: AppTextStyles.bodyBase.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _featureCard('🌙', 'Track Your Sleep', 'Log your sleep time, quality, and comfort. Get a personalized sleep score every morning.', AppColors.primary),
          _featureCard('📊', 'AI Sleep Insights', 'Smart recommendations based on your patterns to help you improve your sleep habits.', AppColors.secondary),
          _featureCard('🛏️', 'Find Sleep Solutions', 'Discover products and habits designed for the African lifestyle to improve your rest.', const Color(0xFF4F46E5)),
          _featureCard('👥', 'Sleep Circles', 'Join sleep improvement groups, compete with friends, and earn rewards together.', AppColors.accent),
        ],
      ),
    );
  }

  Widget _featureCard(String emoji, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label.copyWith(color: AppColors.foreground)),
                const SizedBox(height: 4),
                Text(desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 10: First Challenge ──
  Widget _buildChallenge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.premiumGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 30)],
            ),
            child: const Icon(Icons.emoji_events_rounded, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text('Your First Challenge', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          Text(
            'Log your sleep tonight and start building your streak! Consistent tracking is the first step to better sleep.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _challengeBadge('🌙', 'Log 3 nights this week'),
          const SizedBox(height: 12),
          _challengeBadge('📊', 'Check your first sleep score'),
          const SizedBox(height: 12),
          _challengeBadge('💤', 'Try one sleep improvement tip'),
        ],
      ),
    );
  }

  Widget _challengeBadge(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodyBase.copyWith(color: AppColors.foreground))),
          Icon(Icons.circle_outlined, size: 22, color: AppColors.accent.withValues(alpha: 0.5)),
        ],
      ),
    );
  }

  // ── Bottom Button ──
  Widget _buildBottomButton() {
    final isLastStep = _currentStep == _challengeStep;
    final label = _currentStep == _welcomeStep ? "Let's Begin"
        : _currentStep == _quizIntroStep ? 'Start Quiz'
        : _currentStep == _resultStep ? 'See What You Can Do'
        : isLastStep ? 'Go to Dashboard'
        : 'Continue';

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _canProceed ? _goNext : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLastStep ? AppColors.accent : AppColors.primary,
          foregroundColor: isLastStep ? AppColors.accentDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          elevation: 0,
        ),
        child: Text(label, style: AppTextStyles.button.copyWith(
          color: isLastStep ? AppColors.accentDark : Colors.white,
        )),
      ),
    );
  }
}
