import 'package:dio/dio.dart';

class CurrencyDataSource {
  final Dio dio;

  CurrencyDataSource({required this.dio});

  Future getCurrentExchangeRate(String fromSymbol) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> valueData = {
        "apiKey": 'RVZG0GHEV2KORLNA',
        "from_symbol": fromSymbol,
        "to_symbol": 'BRL'
      };

      var response = await dio.get(
        "https://api-brl-exchange.actionlabs.com.br/api/1.0/open/currentExchangeRate",
        queryParameters: valueData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print('OK');
        print(response.data);
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response);
        if (e.response?.statusCode == 403) {
          return e.response?.data;
        }
      } else {
        //print(e.requestOptions);
        print(e.message);
        return e.message;
      }
    }
  }
}
