/// Circle (community group) model for the Social feature.
class Circle {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final String joinCode;
  final String? imageUrl;
  final bool isJoined;
  final List<CirclePost> recentPosts;

  const Circle({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.joinCode,
    this.imageUrl,
    this.isJoined = false,
    this.recentPosts = const [],
  });

  factory Circle.fromJson(Map<String, dynamic> json) => Circle(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        memberCount: json['member_count'] as int,
        joinCode: json['join_code'] as String,
        imageUrl: json['image_url'] as String?,
        isJoined: json['is_joined'] as bool? ?? false,
      );

  Circle copyWith({bool? isJoined, int? memberCount}) => Circle(
        id: id,
        name: name,
        description: description,
        memberCount: memberCount ?? this.memberCount,
        joinCode: joinCode,
        imageUrl: imageUrl,
        isJoined: isJoined ?? this.isJoined,
        recentPosts: recentPosts,
      );

  static List<Circle> demoCircles() => [
        Circle(id: 'circle-1', name: 'Early Risers Club', description: 'A community for people who wake up before 6 AM.', memberCount: 156, joinCode: 'EARLY6', isJoined: true, recentPosts: CirclePost.demoPosts()),
        Circle(id: 'circle-2', name: 'Sleep Science Geeks', description: 'Discuss the latest research on sleep and circadian rhythms.', memberCount: 89, joinCode: 'SCIGK', isJoined: true),
        Circle(id: 'circle-3', name: 'Night Shift Support', description: 'Tips and support for shift workers managing irregular sleep schedules.', memberCount: 234, joinCode: 'NIGHT1', isJoined: false),
        Circle(id: 'circle-4', name: 'Meditation & Sleep', description: 'Combining mindfulness with better sleep practices.', memberCount: 312, joinCode: 'MED23', isJoined: false),
        Circle(id: 'circle-5', name: 'Parents Sleep Group', description: 'For parents learning to sleep well despite the little ones.', memberCount: 178, joinCode: 'PRNTS', isJoined: false),
      ];
}

/// A post within a circle feed.
class CirclePost {
  final String id;
  final String authorName;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final bool isLiked;

  const CirclePost({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  static List<CirclePost> demoPosts() => [
        CirclePost(id: 'post-1', authorName: 'Sarah K.', content: 'Just hit a 14-day streak of sleeping before 10:30 PM! The consistency is really paying off — my energy levels are through the roof. 🌙', timestamp: DateTime.now().subtract(const Duration(hours: 2)), likes: 23, comments: 5),
        CirclePost(id: 'post-2', authorName: 'Mike R.', content: 'Anyone else find that reading physical books before bed works way better than a Kindle? The backlight was definitely affecting my sleep.', timestamp: DateTime.now().subtract(const Duration(hours: 5)), likes: 18, comments: 12),
        CirclePost(id: 'post-3', authorName: 'Amara O.', content: 'Tried the weighted blanket recommendation from this group and WOW. My deep sleep went from 45 minutes to over 90 minutes! 💤', timestamp: DateTime.now().subtract(const Duration(days: 1)), likes: 45, comments: 8),
      ];
}

/// Leaderboard entry for circle rankings.
class LeaderboardEntry {
  final int rank;
  final String userName;
  final int sleepScore;
  final int streak;

  const LeaderboardEntry({
    required this.rank,
    required this.userName,
    required this.sleepScore,
    required this.streak,
  });

  static List<LeaderboardEntry> demoEntries() => const [
        LeaderboardEntry(rank: 1, userName: 'Sarah K.', sleepScore: 95, streak: 21),
        LeaderboardEntry(rank: 2, userName: 'Mike R.', sleepScore: 92, streak: 14),
        LeaderboardEntry(rank: 3, userName: 'Douglas O.', sleepScore: 88, streak: 10),
        LeaderboardEntry(rank: 4, userName: 'Amara O.', sleepScore: 85, streak: 8),
        LeaderboardEntry(rank: 5, userName: 'James T.', sleepScore: 82, streak: 6),
        LeaderboardEntry(rank: 6, userName: 'Lucy M.', sleepScore: 79, streak: 5),
        LeaderboardEntry(rank: 7, userName: 'Peter N.', sleepScore: 76, streak: 3),
      ];
}
