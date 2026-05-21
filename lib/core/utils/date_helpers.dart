import 'package:intl/intl.dart';

/// Date and time formatting utilities used across the app.
class DateHelpers {
  DateHelpers._();

  /// e.g. "Tuesday, May 12"
  static String fullDayDate(DateTime date) =>
      DateFormat('EEEE, MMMM d').format(date);

  /// e.g. "May 12, 2026"
  static String mediumDate(DateTime date) =>
      DateFormat('MMMM d, y').format(date);

  /// e.g. "May 12"
  static String shortDate(DateTime date) =>
      DateFormat('MMM d').format(date);

  /// e.g. "12/05/2026"
  static String numericDate(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  /// e.g. "10:30 PM"
  static String time12h(DateTime date) =>
      DateFormat('h:mm a').format(date);

  /// e.g. "22:30"
  static String time24h(DateTime date) =>
      DateFormat('HH:mm').format(date);

  /// Returns greeting based on current time.
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Formats a duration like "7h 32m".
  static String durationHoursMinutes(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  /// Formats relative time like "2 days ago", "Just now".
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return shortDate(dateTime);
  }

  /// Returns true if the given date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if the given date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Returns a section label: "Today", "Yesterday", or the date.
  static String sectionLabel(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isYesterday(date)) return 'Yesterday';
    return shortDate(date);
  }
}
