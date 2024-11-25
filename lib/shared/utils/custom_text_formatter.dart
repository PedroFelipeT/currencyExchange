// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CustomTextFormatter {
  //Formata valor para real
  static realFormartter(String valor) {
    double convert = double.parse(valor);
    final formato = NumberFormat("#,##0.00", "pt_BR");
    return formato.format(convert);
  }

  //Tranformas data para Horas e minutos
  static String formatDateTime(String dateTimeString) {
    initializeDateFormatting('pt_BR', null);
    DateTime dateTime =
        DateTime.parse(dateTimeString).subtract(const Duration(hours: 3));
    DateFormat dateFormat = DateFormat('dd/MM/yyyy \'-\' HH\'h\'mm', 'pt_BR');

    String formattedDateTime = dateFormat.format(dateTime);
    return formattedDateTime;
  }

  static String formatDate(String dateTimeString) {
    if (dateTimeString.isNotEmpty) {
      initializeDateFormatting('pt_BR', null);
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

      String formattedDateTime = dateFormat.format(dateTime);
      return formattedDateTime;
    }

    return '';
  }

  static double calcularDiferencaPercentual(
      double valorAnterior, double valorAtual) {
    if (valorAnterior == 0) return 0;

    return ((valorAtual - valorAnterior) / valorAnterior) * 100;
  }
}
