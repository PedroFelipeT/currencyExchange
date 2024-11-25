abstract interface class CurrencyEvent {}

class FetchCurrentExchangeRate implements CurrencyEvent {
  final String fromSymbol;

  FetchCurrentExchangeRate(this.fromSymbol);
}

class FetchDailyExchangeRate implements CurrencyEvent {
  final String fromSymbol;

  FetchDailyExchangeRate(this.fromSymbol);
}
