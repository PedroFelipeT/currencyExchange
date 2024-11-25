class CurrencyData {
  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime date;
  double closeDiff;

  CurrencyData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.date,
    this.closeDiff = 0.0,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'date': date.toIso8601String(),
    };
  }
}
