import '../../model/currency_data_model.dart';
import '../../model/currency_exchange_model.dart';

abstract interface class CurrencyState {}

class StartCurrencyState implements CurrencyState {
  const StartCurrencyState();
}

class SuccessCurrencyState implements CurrencyState {
  final CurrencyExchange currency;
  const SuccessCurrencyState({required this.currency});
}

class SuccessCurrencysState implements CurrencyState {
  final List<CurrencyData> currencys;
  const SuccessCurrencysState({required this.currencys});
}

class ErrorExceptionCurrencyState implements CurrencyState {
  final String? error;
  const ErrorExceptionCurrencyState({this.error});
}

class ErrorExceptionCurrencysState implements CurrencyState {
  final String? error;
  const ErrorExceptionCurrencysState({this.error});
}

class LoadingCurrencyState implements CurrencyState {
  const LoadingCurrencyState();
}

class LoadingCurrencysState implements CurrencyState {
  const LoadingCurrencysState();
}

class EmptyCurrencytate implements CurrencyState {
  const EmptyCurrencytate();
}
