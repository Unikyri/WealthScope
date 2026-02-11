/// Time-based greeting utility.
/// Returns greeting based on time of day.
/// - 06-12: Good Morning
/// - 12-18: Good Afternoon
/// - 18-22: Good Evening
/// - 22-06: Good Night
String getTimeBasedGreeting() {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) return 'Good Morning';
  if (hour >= 12 && hour < 18) return 'Good Afternoon';
  if (hour >= 18 && hour < 22) return 'Good Evening';
  return 'Good Night';
}
