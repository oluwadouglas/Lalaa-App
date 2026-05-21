import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/circle.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});
  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  late List<Circle> _circles;
  final _leaderboard = LeaderboardEntry.demoEntries();

  @override
  void initState() {
    super.initState();
    _circles = Circle.demoCircles().toList();
  }

  // Form controllers
  final _joinCodeController = TextEditingController();
  final _createNameController = TextEditingController();

  @override
  void dispose() {
    _joinCodeController.dispose();
    _createNameController.dispose();
    super.dispose();
  }

  void _handleJoin() {
    final code = _joinCodeController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _circles.add(Circle(id: 'joined_${DateTime.now().millisecondsSinceEpoch}', name: 'Circle $code', description: 'Joined circle', joinCode: code, memberCount: 5, isJoined: true));
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Successfully Joined'),
        content: Text('You have joined the circle using code $code!'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Awesome'))],
      ),
    );
    _joinCodeController.clear();
  }

  void _handleCreate() {
    final name = _createNameController.text.trim();
    if (name.isEmpty) return;
    
    final code = '${name.substring(0, 3).toUpperCase()}${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    setState(() {
      _circles.add(Circle(id: 'new_${DateTime.now().millisecondsSinceEpoch}', name: name, description: 'Newly created circle', joinCode: code, memberCount: 1, isJoined: true));
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Circle Created!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your new circle "$name" is ready.'),
            const SizedBox(height: 16),
            const Text('Invite Code:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(code, style: const TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const Icon(Icons.copy, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done'))],
      ),
    );
    _createNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final joinedCircle = _circles.firstWhere((c) => c.isJoined, orElse: () => _circles.first);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.foreground : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Sleep Community'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          // Removed QR code scanner here
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Header ──
            _buildHeroHeader(joinedCircle),
            const SizedBox(height: 24),

            // ── Active Challenges ──
            _sectionTitle('Weekly Challenges', icon: Icons.local_fire_department, color: AppColors.primary, textColor: textColor),
            const SizedBox(height: 12),
            _buildChallengesCarousel(),
            const SizedBox(height: 28),

            // ── Leaderboard ──
            _sectionTitle('Top Sleepers', icon: Icons.emoji_events, color: AppColors.accent, textColor: textColor),
            const SizedBox(height: 12),
            _buildLeaderboard(),
            const SizedBox(height: 28),

            // ── Discover Communities ──
            _sectionTitle('Discover Circles', icon: Icons.explore, color: AppColors.secondary, textColor: textColor),
            const SizedBox(height: 12),
            _buildDiscoverCircles(),
            const SizedBox(height: 28),

            // ── Join / Create Forms ──
            _sectionTitle('Manage Circles', icon: Icons.group_add, color: AppColors.primary, textColor: textColor),
            const SizedBox(height: 12),
            _buildManageForms(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {required IconData icon, required Color color, required Color textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.h3.copyWith(color: textColor)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(Circle circle) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Your Primary Circle', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.group, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Text(circle.name, style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 28)),
          const SizedBox(height: 4),
          Text('${circle.memberCount} active members this week', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              _heroStat('Your Rank', '#4', Icons.leaderboard),
              const SizedBox(width: 20),
              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(width: 20),
              _heroStat('Circle Score', '86', Icons.nights_stay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 14),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildChallengesCarousel() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _challengeCard('No Screens Before Bed', '7 Day Challenge', 0.6, AppColors.secondary),
          _challengeCard('Consistent Wake Time', '5 Day Challenge', 0.2, AppColors.accent),
          _challengeCard('8 Hours a Night', 'Weekend Challenge', 0.0, AppColors.primary),
        ],
      ),
    );
  }

  Widget _challengeCard(String title, String subtitle, double progress, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.foreground : AppColors.lightTextPrimary;
    final subColor = isDark ? AppColors.textTertiary : AppColors.lightTextSecondary;

    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.label.copyWith(fontSize: 14, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: subColor)),
          const Spacer(),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.foreground : AppColors.lightTextPrimary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) _leaderboardTile(_leaderboard[i], i, textColor),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton(
              onPressed: () {},
              child: const Text('View Full Leaderboard', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }

  Widget _leaderboardTile(LeaderboardEntry e, int index, Color textColor) {
    final medals = ['🥇', '🥈', '🥉'];
    return ListTile(
      leading: Container(
        width: 32, height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Text(medals[index], style: const TextStyle(fontSize: 18)),
      ),
      title: Text(e.userName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(e.sleepScore.toString(), style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
          Text('${e.streak} streak', style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDiscoverCircles() {
    final discoverList = _circles.where((c) => !c.isJoined).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.foreground : AppColors.lightTextPrimary;
    final subColor = isDark ? AppColors.textTertiary : AppColors.lightTextSecondary;

    // Fix: Increased height from 180 to 220 so the content fits completely.
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: discoverList.length,
        itemBuilder: (context, index) {
          final c = discoverList[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Let it shrink to fit
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.chartPalette[index % 3].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.people, color: AppColors.chartPalette[index % 3]),
                ),
                const SizedBox(height: 12),
                Text(c.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${c.memberCount} members', style: TextStyle(color: subColor, fontSize: 12)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36, // Slightly taller button for better tapping
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        final idx = _circles.indexWhere((circle) => circle.id == c.id);
                        if (idx != -1) {
                          _circles[idx] = Circle(id: c.id, name: c.name, description: c.description, joinCode: c.joinCode, memberCount: c.memberCount, isJoined: true);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined ${c.name}')));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                    child: const Text('Join', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildManageForms() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.foreground : AppColors.lightTextPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Join Circle Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.group_add, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 8),
                    Text('Join with Invite Code', style: AppTextStyles.label.copyWith(fontSize: 15, color: textColor)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _joinCodeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'e.g. SLEEP123',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _handleJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: const Text('Join'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Create Circle Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text('Create a New Circle', style: AppTextStyles.label.copyWith(fontSize: 15, color: textColor)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _createNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Circle Name',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _handleCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
