/// All backend API route constants in one place.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Base ──
  static const String baseUrl = 'http://10.0.2.2:8000';

  // ── Auth ──
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String refreshToken = '/api/auth/refresh';
  static const String profile = '/api/auth/profile';

  // ── Sleep ──
  static const String sleepEntries = '/api/sleep';
  static String sleepEntry(String id) => '/api/sleep/$id';
  static const String sleepStats = '/api/sleep/stats';

  // ── Habits ──
  static const String habits = '/api/habits';
  static String habit(String id) => '/api/habits/$id';
  static String habitToggle(String id) => '/api/habits/$id/toggle';

  // ── Social / Circles ──
  static const String circles = '/api/circles';
  static String circle(String id) => '/api/circles/$id';
  static String circleJoin(String code) => '/api/circles/join/$code';
  static const String leaderboard = '/api/circles/leaderboard';

  // ── Learn ──
  static const String modules = '/api/learn/modules';
  static String article(String id) => '/api/learn/articles/$id';

  // ── Marketplace ──
  static const String products = '/api/marketplace/products';
  static String product(String id) => '/api/marketplace/products/$id';
  static const String cart = '/api/marketplace/cart';
  static const String checkout = '/api/marketplace/checkout';
  static const String orders = '/api/marketplace/orders';
  static String order(String id) => '/api/marketplace/orders/$id';

  // ── Notifications ──
  static const String notificationPrefs = '/api/notifications/preferences';
}
