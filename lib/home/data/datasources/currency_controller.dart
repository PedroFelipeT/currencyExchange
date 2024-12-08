import 'package:dio/dio.dart';

abstract interface class ICurrencyDataSource {
  Future getCurrentExchangeRate(String fromSymbol);
  Future getDailyCurrentExchangeRate(String fromSymbol);
}

class CurrencyDataSource implements ICurrencyDataSource {
  final Dio _dio = Dio();

  @override
  Future getCurrentExchangeRate(String fromSymbol) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> valueData = {
        "apiKey": 'RVZG0GHEV2KORLNA',
        "from_symbol": fromSymbol,
        "to_symbol": 'BRL'
      };

      var response = await _dio.get(
        "https://api-brl-exchange.actionlabs.com.br/api/1.0/open/currentExchangeRate",
        queryParameters: valueData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response);

        return e.response?.data;
      } else {
        print(e.message);
        return e.message;
      }
    }
  }

  @override
  Future getDailyCurrentExchangeRate(String fromSymbol) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> valueData = {
        "apiKey": 'RVZG0GHEV2KORLNA',
        "from_symbol": fromSymbol,
        "to_symbol": 'BRL'
      };

      var response = await _dio.get(
        "https://api-brl-exchange.actionlabs.com.br/api/1.0/open/dailyExchangeRate",
        queryParameters: valueData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response);

        return e.response?.data;
      } else {
        print(e.message);
        return e.message;
      }
    }
  }
}
