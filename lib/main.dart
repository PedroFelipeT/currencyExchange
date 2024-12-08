import 'package:currency_exchange_app/home/data/bloc/currency_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/data/datasources/currency_controller.dart';
import 'home/data/repository/currency_repository.dart';
import 'home/ui/page/home_page.dart';
import 'shared/theme/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ICurrencyDataSource>(
          create: (context) => CurrencyDataSource(),
        ),
        RepositoryProvider<CurrencyRepository>(
          create: (context) => CurrencyRepository(
            currencyDatasource:
                RepositoryProvider.of<ICurrencyDataSource>(context),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => CurrencyBloc(
            RepositoryProvider.of<CurrencyRepository>(context),
          ),
          child: const HomePage(),
        ),
      ),
    );
  }
}
