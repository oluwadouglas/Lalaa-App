/// User model representing an authenticated user.
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime joinDate;
  final bool isPremium;
  final int sleepGoalMinutes;
  final String? bedtimeGoal;
  final String? wakeTimeGoal;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.joinDate,
    this.isPremium = false,
    this.sleepGoalMinutes = 480,
    this.bedtimeGoal,
    this.wakeTimeGoal,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      joinDate: DateTime.parse(json['join_date'] as String),
      isPremium: json['is_premium'] as bool? ?? false,
      sleepGoalMinutes: json['sleep_goal_minutes'] as int? ?? 480,
      bedtimeGoal: json['bedtime_goal'] as String?,
      wakeTimeGoal: json['wake_time_goal'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'join_date': joinDate.toIso8601String(),
        'is_premium': isPremium,
        'sleep_goal_minutes': sleepGoalMinutes,
        'bedtime_goal': bedtimeGoal,
        'wake_time_goal': wakeTimeGoal,
      };

  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    bool? isPremium,
    int? sleepGoalMinutes,
    String? bedtimeGoal,
    String? wakeTimeGoal,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate,
      isPremium: isPremium ?? this.isPremium,
      sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
      bedtimeGoal: bedtimeGoal ?? this.bedtimeGoal,
      wakeTimeGoal: wakeTimeGoal ?? this.wakeTimeGoal,
    );
  }

  /// Demo user for mock repository.
  static User demo() => User(
        id: 'demo-user-001',
        name: 'Douglas Opoka',
        email: 'douglas@lalaapa.com',
        joinDate: DateTime(2026, 4, 1),
        isPremium: false,
        sleepGoalMinutes: 480,
        bedtimeGoal: '10:30 PM',
        wakeTimeGoal: '6:30 AM',
      );
}
