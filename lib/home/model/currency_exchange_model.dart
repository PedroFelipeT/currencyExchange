// ignore_for_file: public_member_api_docs, sort_constructors_first
class CurrencyExchange {
  final double exchangeRate;
  final String fromSymbol;
  final DateTime lastUpdatedAt;

  final bool success;
  final String toSymbol;

  CurrencyExchange({
    required this.exchangeRate,
    required this.fromSymbol,
    required this.lastUpdatedAt,
    required this.success,
    required this.toSymbol,
  });

  factory CurrencyExchange.fromJson(Map<String, dynamic> json) {
    return CurrencyExchange(
      exchangeRate: json['exchangeRate'].toDouble(),
      fromSymbol: json['fromSymbol'],
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
      success: json['success'],
      toSymbol: json['toSymbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exchangeRate': exchangeRate,
      'fromSymbol': fromSymbol,
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'success': success,
      'toSymbol': toSymbol,
    };
  }

  @override
  String toString() {
    return 'CurrencyExchange(exchangeRate: $exchangeRate, fromSymbol: $fromSymbol, lastUpdatedAt: $lastUpdatedAt,  success: $success, toSymbol: $toSymbol)';
  }
}
