import 'package:flutter/material.dart';

/// A single habit entry with streak tracking.
class Habit {
  final String id;
  final String name;
  final IconData icon;
  final int colorValue;
  final int currentStreak;
  final int bestStreak;
  final int totalPoints;
  final bool completedToday;
  final List<DateTime> completionHistory;
  final String? description;
  final String category;

  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalPoints = 0,
    this.completedToday = false,
    this.completionHistory = const [],
    this.description,
    this.category = 'General',
  });

  Color get color => Color(colorValue);

  Habit copyWith({
    bool? completedToday,
    int? currentStreak,
    int? bestStreak,
    int? totalPoints,
    List<DateTime>? completionHistory,
  }) {
    return Habit(
      id: id,
      name: name,
      icon: icon,
      colorValue: colorValue,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalPoints: totalPoints ?? this.totalPoints,
      completedToday: completedToday ?? this.completedToday,
      completionHistory: completionHistory ?? this.completionHistory,
      description: description,
      category: category,
    );
  }

  /// Demo habits for mock repository.
  static List<Habit> demoHabits() => [
        Habit(
          id: 'habit-1',
          name: 'No screens before bed',
          icon: Icons.phone_disabled_outlined,
          colorValue: 0xFF6366F1,
          currentStreak: 5,
          bestStreak: 12,
          totalPoints: 150,
          completedToday: true,
          category: 'Sleep Hygiene',
          description: 'Avoid phone and TV screens at least 30 minutes before bedtime.',
        ),
        Habit(
          id: 'habit-2',
          name: 'Consistent bedtime',
          icon: Icons.nights_stay_outlined,
          colorValue: 0xFF8B5CF6,
          currentStreak: 3,
          bestStreak: 8,
          totalPoints: 90,
          completedToday: false,
          category: 'Sleep Hygiene',
          description: 'Go to bed within 30 minutes of your target bedtime.',
        ),
        Habit(
          id: 'habit-3',
          name: 'Evening meditation',
          icon: Icons.self_improvement,
          colorValue: 0xFF10B981,
          currentStreak: 7,
          bestStreak: 14,
          totalPoints: 210,
          completedToday: true,
          category: 'Relaxation',
          description: 'Practice 10 minutes of guided meditation before sleep.',
        ),
        Habit(
          id: 'habit-4',
          name: 'No caffeine after 2PM',
          icon: Icons.coffee_outlined,
          colorValue: 0xFFF59E0B,
          currentStreak: 10,
          bestStreak: 21,
          totalPoints: 300,
          completedToday: true,
          category: 'Diet',
          description: 'Avoid coffee, tea, and energy drinks after 2:00 PM.',
        ),
        Habit(
          id: 'habit-5',
          name: 'Exercise 30 min',
          icon: Icons.directions_run,
          colorValue: 0xFFEF4444,
          currentStreak: 2,
          bestStreak: 6,
          totalPoints: 60,
          completedToday: false,
          category: 'Exercise',
          description: 'Complete at least 30 minutes of physical exercise (not close to bedtime).',
        ),
        Habit(
          id: 'habit-6',
          name: 'Sleep journal',
          icon: Icons.edit_note,
          colorValue: 0xFF3B82F6,
          currentStreak: 4,
          bestStreak: 9,
          totalPoints: 120,
          completedToday: false,
          category: 'Mindfulness',
          description: 'Write down your thoughts and worries before bed to clear your mind.',
        ),
      ];
}

/// Badges / achievements for gamification.
class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int colorValue;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final int requiredPoints;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.colorValue,
    this.isUnlocked = false,
    this.unlockedDate,
    required this.requiredPoints,
  });

  Color get color => Color(colorValue);

  static List<Badge> demoBadges() => [
        Badge(
          id: 'badge-1',
          name: 'Early Bird',
          description: 'Wake up before 7 AM for 7 days straight',
          icon: Icons.wb_sunny,
          colorValue: 0xFFF59E0B,
          isUnlocked: true,
          unlockedDate: DateTime(2026, 4, 15),
          requiredPoints: 100,
        ),
        Badge(
          id: 'badge-2',
          name: 'Sleep Master',
          description: 'Achieve a 90+ sleep score for 5 consecutive nights',
          icon: Icons.star,
          colorValue: 0xFF8B5CF6,
          isUnlocked: false,
          requiredPoints: 250,
        ),
        Badge(
          id: 'badge-3',
          name: 'Habit Hero',
          description: 'Complete all daily habits for 14 days',
          icon: Icons.emoji_events,
          colorValue: 0xFF10B981,
          isUnlocked: false,
          requiredPoints: 500,
        ),
        Badge(
          id: 'badge-4',
          name: 'Night Owl Reformed',
          description: 'Go to bed before 11 PM for 10 days',
          icon: Icons.bedtime,
          colorValue: 0xFF6366F1,
          isUnlocked: true,
          unlockedDate: DateTime(2026, 5, 1),
          requiredPoints: 200,
        ),
        Badge(
          id: 'badge-5',
          name: 'Social Butterfly',
          description: 'Join 3 sleep circles and post 10 times',
          icon: Icons.people,
          colorValue: 0xFFEC4899,
          isUnlocked: false,
          requiredPoints: 300,
        ),
        Badge(
          id: 'badge-6',
          name: '30-Day Streak',
          description: 'Log your sleep for 30 consecutive days',
          icon: Icons.local_fire_department,
          colorValue: 0xFFEF4444,
          isUnlocked: false,
          requiredPoints: 750,
        ),
      ];
}
