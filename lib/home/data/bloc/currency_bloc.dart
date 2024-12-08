import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/currency_repository.dart';
import 'currency_state.dart';
import 'currency_event.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final ICurrencyRepository currencyRepository;

  CurrencyBloc(this.currencyRepository) : super(const StartCurrencyState()) {
    on<FetchCurrentExchangeRate>(_fetchCurrentExchangeRate);
    on<FetchDailyExchangeRate>(_fetchDailyExchangeRate);
  }

  Future<void> _fetchCurrentExchangeRate(
    FetchCurrentExchangeRate event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const LoadingCurrencyState());
    try {
      final result =
          await currencyRepository.getCurrentExchangeRate(event.fromSymbol);
      emit(result);
    } catch (e) {
      emit(ErrorExceptionCurrencyState(error: e.toString()));
    }
  }

  Future<void> _fetchDailyExchangeRate(
    FetchDailyExchangeRate event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const LoadingCurrencysState());
    try {
      final result = await currencyRepository
          .getDailyCurrentExchangeRate(event.fromSymbol);

      emit(result);
    } catch (e) {
      emit(ErrorExceptionCurrencysState(error: e.toString()));
    }
  }
}
