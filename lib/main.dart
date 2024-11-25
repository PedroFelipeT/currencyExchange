import 'package:currency_exchange_app/home/data/bloc/currency_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/data/datasources/currency_controller.dart';
import 'home/data/repositories/currency_repository.dart';
import 'home/ui/page/home_page.dart';
import 'shared/theme/app_colors.dart';

void main() {
  final dio = Dio();
  final dataSource = CurrencyDataSource(dio: dio);
  final repository = CurrencyRepository(currencyDatasource: dataSource);
  runApp(MyApp(currencyRepository: repository));
}

class MyApp extends StatelessWidget {
  final CurrencyRepository currencyRepository;
  const MyApp({super.key, required this.currencyRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CurrencyBloc(currencyRepository),
        child: const HomePage(),
      ),
    );
  }
}
