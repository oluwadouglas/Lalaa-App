import 'package:flutter/material.dart' hide Badge;
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../shared/models/habit.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late List<Habit> _habits;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _habits = Habit.demoHabits();
    _totalPoints = _habits.fold(0, (sum, h) => sum + h.totalPoints);
  }

  void _toggleHabit(int index) {
    setState(() {
      final h = _habits[index];
      _habits[index] = h.copyWith(
        completedToday: !h.completedToday,
        totalPoints: h.completedToday ? h.totalPoints - 10 : h.totalPoints + 10,
        currentStreak: h.completedToday ? h.currentStreak - 1 : h.currentStreak + 1,
      );
      _totalPoints = _habits.fold(0, (sum, h) => sum + h.totalPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = _habits.where((h) => h.completedToday).length;
    final badges = Badge.demoBadges();

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(title: const Text('Habits')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.sleepGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_totalPoints points',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('$completed/${_habits.length} completed today',
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Daily Habits',
                style: TextStyle(
                    color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List.generate(_habits.length, (i) => _HabitTile(
              habit: _habits[i],
              onToggle: () => _toggleHabit(i),
            )),
            const SizedBox(height: 24),
            Text('Achievements',
                style: TextStyle(
                    color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: badges.length,
              itemBuilder: (_, i) => _BadgeTile(badge: badges[i]),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  const _HabitTile({required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: habit.completedToday
                ? habit.color.withValues(alpha: 0.08)
                : context.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: habit.completedToday ? habit.color.withValues(alpha: 0.3) : context.divider,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: habit.completedToday ? habit.color : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: habit.completedToday ? habit.color : context.divider,
                    width: 2,
                  ),
                ),
                child: habit.completedToday
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.name,
                        style: TextStyle(
                          color: context.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: habit.completedToday
                              ? TextDecoration.lineThrough
                              : null,
                        )),
                    Text('🔥 ${habit.currentStreak} day streak',
                        style: TextStyle(color: context.hintText, fontSize: 11)),
                  ],
                ),
              ),
              Text('+10',
                  style: TextStyle(
                    color: habit.completedToday ? habit.color : context.hintText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badge.isUnlocked ? badge.color.withValues(alpha: 0.3) : context.divider,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(badge.icon,
              color: badge.isUnlocked ? badge.color : context.hintText,
              size: 28),
          const SizedBox(height: 6),
          Text(badge.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: badge.isUnlocked ? context.onSurface : context.hintText,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              )),
          if (!badge.isUnlocked)
            Icon(Icons.lock, size: 12, color: context.hintText),
        ],
      ),
    );
  }
}
