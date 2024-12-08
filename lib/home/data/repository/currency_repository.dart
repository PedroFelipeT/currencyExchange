import 'package:currency_exchange_app/home/data/bloc/currency_state.dart';
import 'package:currency_exchange_app/home/model/currency_data_model.dart';
import 'package:currency_exchange_app/shared/utils/custom_text_formatter.dart';

import '../../model/currency_exchange_model.dart';
import '../datasources/currency_controller.dart';

abstract interface class ICurrencyRepository {
  Future<CurrencyState> getCurrentExchangeRate(String fromSymbol);
  Future<CurrencyState> getDailyCurrentExchangeRate(String fromSymbol);
}

class CurrencyRepository implements ICurrencyRepository {
  final ICurrencyDataSource currencyDatasource;

  CurrencyRepository({required this.currencyDatasource});

  @override
  Future<CurrencyState> getCurrentExchangeRate(String fromSymbol) async {
    try {
      var response =
          await currencyDatasource.getCurrentExchangeRate(fromSymbol);

      CurrencyExchange currency = CurrencyExchange.fromJson(response);

      return SuccessCurrencyState(currency: currency);
    } catch (e) {
      return const ErrorExceptionCurrencyState(error: 'Falha ao carregar.');
    }
  }

  @override
  Future<CurrencyState> getDailyCurrentExchangeRate(String fromSymbol) async {
    try {
      List<CurrencyData> currencys = [];
      var response =
          await currencyDatasource.getDailyCurrentExchangeRate(fromSymbol);

      if (response["success"] == true) {
        List<dynamic> body = response["data"];

        List<CurrencyData> allCurrencys =
            body.map((json) => CurrencyData.fromJson(json)).toList();

        final DateTime thirtyDaysAgo =
            DateTime.now().subtract(const Duration(days: 30));

        currencys = allCurrencys.where((currency) {
          return currency.date.isAfter(thirtyDaysAgo);
        }).toList();

        for (int i = currencys.length - 1; i > 0; i--) {
          final anterior = currencys[i];
          final atual = currencys[i - 1];

          atual.closeDiff = CustomTextFormatter.calcularDiferencaPercentual(
              anterior.close, atual.close);
        }

        return SuccessCurrencysState(currencys: currencys);
      } else {
        return const ErrorExceptionCurrencysState(
            error: 'This information could not be loaded.');
      }
    } catch (e) {
      return const ErrorExceptionCurrencysState(
          error: 'This information could not be loaded.');
    }
  }
}
