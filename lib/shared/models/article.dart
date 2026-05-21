/// Article model for the Learn feature.
class Article {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String content;
  final String? imageUrl;
  final int readTimeMinutes;
  final DateTime publishDate;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    this.imageUrl,
    required this.readTimeMinutes,
    required this.publishDate,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        summary: json['summary'] as String,
        content: json['content'] as String,
        imageUrl: json['image_url'] as String?,
        readTimeMinutes: json['read_time_minutes'] as int,
        publishDate: DateTime.parse(json['publish_date'] as String),
      );

  static List<Article> demoArticles() => [
        Article(id: 'art-1', title: 'The Science of Sleep Cycles', category: 'Sleep Science', summary: 'Understand how your body cycles through different sleep stages each night.', content: _scienceContent, readTimeMinutes: 5, publishDate: DateTime(2026, 5, 1)),
        Article(id: 'art-2', title: '10 Tips for Better Sleep Hygiene', category: 'Sleep Hygiene', summary: 'Simple changes to your routine that can dramatically improve sleep quality.', content: _hygieneContent, readTimeMinutes: 4, publishDate: DateTime(2026, 4, 28)),
        Article(id: 'art-3', title: 'How Diet Affects Your Sleep', category: 'Nutrition', summary: 'Learn which foods help you sleep better and which ones keep you awake.', content: _dietContent, readTimeMinutes: 6, publishDate: DateTime(2026, 4, 25)),
        Article(id: 'art-4', title: 'The Power of Power Naps', category: 'Sleep Science', summary: 'When and how to nap for maximum energy without ruining nighttime sleep.', content: _napContent, readTimeMinutes: 3, publishDate: DateTime(2026, 4, 20)),
        Article(id: 'art-5', title: 'Creating the Perfect Sleep Environment', category: 'Sleep Hygiene', summary: 'Temperature, lighting, noise — optimize your bedroom for deep sleep.', content: _environmentContent, readTimeMinutes: 5, publishDate: DateTime(2026, 4, 15)),
        Article(id: 'art-6', title: 'Exercise and Sleep: The Connection', category: 'Exercise', summary: 'How physical activity improves sleep quality, and the best time to work out.', content: _exerciseContent, readTimeMinutes: 4, publishDate: DateTime(2026, 4, 10)),
      ];

  static const _scienceContent = '''Your body cycles through four stages of sleep multiple times each night. Each cycle lasts roughly 90 minutes.\n\n**Stage 1 (Light Sleep):** The transition between wakefulness and sleep. Lasts 5-10 minutes.\n\n**Stage 2 (Light Sleep):** Heart rate slows, body temperature drops. This makes up about 50% of total sleep.\n\n**Stage 3 (Deep Sleep):** The most restorative stage. Your body repairs tissues, builds bone and muscle, and strengthens the immune system.\n\n**REM Sleep:** Your brain becomes more active. This is when most dreaming occurs. Critical for memory consolidation and learning.\n\nUnderstanding these cycles helps you time your alarm to wake during lighter sleep stages, feeling more refreshed.''';

  static const _hygieneContent = '''Good sleep hygiene is the foundation of quality rest. Here are 10 evidence-based tips:\n\n1. **Stick to a schedule** — Go to bed and wake up at the same time daily\n2. **Limit screen time** — No screens 30 minutes before bed\n3. **Keep it cool** — Set bedroom temperature to 65-68°F (18-20°C)\n4. **Block the light** — Use blackout curtains or a sleep mask\n5. **Avoid caffeine after 2 PM** — It takes 6+ hours to leave your system\n6. **Exercise regularly** — But not within 3 hours of bedtime\n7. **Limit alcohol** — It disrupts REM sleep\n8. **Create a wind-down routine** — Read, meditate, or stretch\n9. **Reserve your bed for sleep** — Don\'t work or watch TV in bed\n10. **Manage stress** — Try journaling or deep breathing exercises''';

  static const _dietContent = '''What you eat significantly impacts how well you sleep.\n\n**Foods that promote sleep:**\n- Cherries (natural melatonin source)\n- Almonds and walnuts\n- Turkey (contains tryptophan)\n- Kiwi fruit\n- Fatty fish (salmon, mackerel)\n- Chamomile tea\n\n**Foods to avoid before bed:**\n- Caffeine (coffee, chocolate, energy drinks)\n- Spicy foods (can cause heartburn)\n- Heavy, fatty meals\n- Sugary snacks\n- Alcohol (disrupts sleep architecture)\n\n**Timing matters:** Finish your last meal at least 2-3 hours before bedtime.''';

  static const _napContent = '''Power naps can boost alertness and performance when done correctly.\n\n**The ideal nap length:** 20-30 minutes. This keeps you in lighter sleep stages, making it easier to wake up refreshed.\n\n**Best time to nap:** Between 1-3 PM, when your body naturally dips in alertness.\n\n**Nap tips:**\n- Set an alarm to avoid oversleeping\n- Find a quiet, dark spot\n- Don\'t nap after 3 PM — it can interfere with nighttime sleep\n- A "coffee nap" (drinking coffee right before a 20-min nap) can be especially effective''';

  static const _environmentContent = '''Your bedroom environment plays a crucial role in sleep quality.\n\n**Temperature:** Keep your room between 60-67°F (15-19°C). Your body needs to cool down to initiate sleep.\n\n**Lighting:** Complete darkness is ideal. Even small amounts of light can suppress melatonin production. Use blackout curtains and cover LED lights.\n\n**Noise:** Use a white noise machine or earplugs if your environment is noisy. Consistent, low-level sound masks disruptive noises.\n\n**Mattress & Pillows:** Replace your mattress every 7-10 years. Your pillow should support your neck\'s natural curve.\n\n**Aromatherapy:** Lavender scent has been shown to decrease heart rate and blood pressure, promoting relaxation.''';

  static const _exerciseContent = '''Regular exercise is one of the most effective natural sleep aids.\n\n**Benefits:**\n- Reduces time to fall asleep by up to 55%\n- Increases total sleep time\n- Improves deep sleep duration\n- Reduces symptoms of insomnia\n\n**Best timing:**\n- Morning or afternoon exercise is ideal\n- Avoid vigorous exercise within 3 hours of bedtime\n- Gentle yoga or stretching before bed is beneficial\n\n**How much:** Aim for at least 150 minutes of moderate exercise per week (about 30 minutes, 5 days a week).''';
}
