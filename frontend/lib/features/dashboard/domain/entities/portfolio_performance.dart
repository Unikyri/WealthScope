/// Portfolio performance metrics
class PortfolioPerformance {
  final double todayChange;
  final double todayChangePercent;
  final double weekChange;
  final double weekChangePercent;
  final double monthChange;
  final double monthChangePercent;
  final double ytdChange;
  final double ytdChangePercent;

  const PortfolioPerformance({
    required this.todayChange,
    required this.todayChangePercent,
    required this.weekChange,
    required this.weekChangePercent,
    required this.monthChange,
    required this.monthChangePercent,
    required this.ytdChange,
    required this.ytdChangePercent,
  });
}
