/// Represents the breakdown of sleep stages in a single night.
class SleepStages {
  final int deepMinutes;
  final int lightMinutes;
  final int remMinutes;
  final int awakeMinutes;

  const SleepStages({
    required this.deepMinutes,
    required this.lightMinutes,
    required this.remMinutes,
    required this.awakeMinutes,
  });

  int get totalMinutes => deepMinutes + lightMinutes + remMinutes + awakeMinutes;

  double get deepPercent => totalMinutes > 0 ? deepMinutes / totalMinutes : 0;
  double get lightPercent => totalMinutes > 0 ? lightMinutes / totalMinutes : 0;
  double get remPercent => totalMinutes > 0 ? remMinutes / totalMinutes : 0;
  double get awakePercent => totalMinutes > 0 ? awakeMinutes / totalMinutes : 0;

  factory SleepStages.fromJson(Map<String, dynamic> json) => SleepStages(
        deepMinutes: json['deep_minutes'] as int,
        lightMinutes: json['light_minutes'] as int,
        remMinutes: json['rem_minutes'] as int,
        awakeMinutes: json['awake_minutes'] as int,
      );

  Map<String, dynamic> toJson() => {
        'deep_minutes': deepMinutes,
        'light_minutes': lightMinutes,
        'rem_minutes': remMinutes,
        'awake_minutes': awakeMinutes,
      };
}

/// A single sleep log entry.
class SleepEntry {
  final String id;
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final Duration duration;
  final int qualityScore; // 0-100
  final SleepStages stages;
  final String? notes;

  const SleepEntry({
    required this.id,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.duration,
    required this.qualityScore,
    required this.stages,
    this.notes,
  });

  String get qualityLabel {
    if (qualityScore >= 85) return 'Excellent';
    if (qualityScore >= 70) return 'Good';
    if (qualityScore >= 50) return 'Fair';
    return 'Poor';
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wake_time'] as String),
      duration: Duration(minutes: json['duration_minutes'] as int),
      qualityScore: json['quality_score'] as int,
      stages: SleepStages.fromJson(json['stages'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'bedtime': bedtime.toIso8601String(),
        'wake_time': wakeTime.toIso8601String(),
        'duration_minutes': duration.inMinutes,
        'quality_score': qualityScore,
        'stages': stages.toJson(),
        'notes': notes,
      };

  /// Generate demo sleep entries for the last N days.
  static List<SleepEntry> demoEntries({int days = 14}) {
    final now = DateTime.now();
    final scores = [85, 72, 90, 65, 78, 88, 82, 70, 95, 76, 81, 68, 92, 74];
    final durations = [452, 390, 480, 360, 420, 465, 440, 375, 510, 400, 430, 345, 490, 410];

    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: i));
      final score = scores[i % scores.length];
      final totalMinutes = durations[i % durations.length];
      final deep = (totalMinutes * 0.20).round();
      final rem = (totalMinutes * 0.22).round();
      final awake = (totalMinutes * 0.05).round();
      final light = totalMinutes - deep - rem - awake;

      final bedtime = DateTime(date.year, date.month, date.day - 1, 22, 30);
      final wakeTime = bedtime.add(Duration(minutes: totalMinutes));

      return SleepEntry(
        id: 'sleep-${date.toIso8601String().substring(0, 10)}',
        date: date,
        bedtime: bedtime,
        wakeTime: wakeTime,
        duration: Duration(minutes: totalMinutes),
        qualityScore: score,
        stages: SleepStages(
          deepMinutes: deep,
          lightMinutes: light,
          remMinutes: rem,
          awakeMinutes: awake,
        ),
      );
    });
  }
}
