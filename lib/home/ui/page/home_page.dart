import 'package:currency_exchange_app/shared/constants/app_images.dart';
import 'package:currency_exchange_app/shared/utils/custom_text_formatter.dart';
import 'package:currency_exchange_app/shared/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/theme/app_colors.dart';
import '../../data/bloc/currency_bloc.dart';
import '../../data/bloc/currency_event.dart';
import '../../data/bloc/currency_state.dart';
import '../widgets/input_currency_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double closeDiff = 0;
  bool visibilty = false;
  bool _isFocused = false;

  final _formKey = GlobalKey<FormState>();
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 160,
                  child: SvgPicture.asset(
                    AppImages.logo.path,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: AppColors.grey,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'BRL EXCHANGE RATE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.branded,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _controller.text.isEmpty
                                  ? AppColors.grey
                                  : AppColors.branded,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      child: InputCurrencyWidget(
                        controller: _controller,
                        focusNode: _focusNode,
                        isFocused: _isFocused,
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomBottom(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final currencyCode = _controller.text.trim();
                      if (currencyCode.isNotEmpty) {
                        if (isExpanded) {
                          setState(() {
                            visibilty = true;
                            isExpanded = !isExpanded;
                          });
                        } else {
                          setState(() {
                            visibilty = true;
                          });
                        }
                      }
                      bloc.add(FetchCurrentExchangeRate(currencyCode));
                    }
                  },
                  text: 'EXCHANGE RESULT',
                  color: AppColors.branded,
                  colorText: AppColors.white,
                  sizeText: 16,
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<CurrencyBloc, CurrencyState>(
                    buildWhen: (previous, current) =>
                        current is SuccessCurrencyState,
                    builder: (context, state) {
                      if (state is LoadingCurrencyState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SuccessCurrencyState) {
                        final currency = state.currency;
                        return Column(
                          children: [
                            const Divider(color: AppColors.grey),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                      'Exchange rate now',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.neutralDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      CustomTextFormatter.formatDateTime(
                                          currency.lastUpdatedAt.toString()),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.dark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${_controller.text}/BRL',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: AppColors.branded,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: AppColors.branded.withOpacity(0.15),
                              height: 72,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'R\$ ${currency.exchangeRate.toStringAsFixed(2)}', // Taxa de câmbio
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: AppColors.branded,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (state is ErrorExceptionCurrencyState) {
                        return Center(
                          child: Text(
                            '${state.error ?? 'Erro desconhecido'}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const Center(child: Text(''));
                    }),
                Visibility(
                  visible: visibilty,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "LAST 30 DAYS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded ? Icons.remove : Icons.add,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                              if (isExpanded) {
                                final currencyCode = _controller.text.trim();
                                if (currencyCode.isNotEmpty) {
                                  bloc.add(
                                      FetchDailyExchangeRate(currencyCode));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      if (!isExpanded)
                        const Divider(
                          color: AppColors.branded,
                          thickness: 2,
                        ),
                    ],
                  ),
                ),
                if (isExpanded)
                  BlocBuilder<CurrencyBloc, CurrencyState>(
                      buildWhen: (previous, current) =>
                          current is SuccessCurrencysState ||
                          current is ErrorExceptionCurrencysState,
                      builder: (context, state) {
                        if (state is LoadingCurrencysState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is SuccessCurrencysState) {
                          final currencys = state.currencys;

                          return Container(
                            color: AppColors.neutralGrey,
                            child: Column(
                              children: [
                                ListView.builder(
                                  itemCount: currencys.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final currency = currencys[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 0),
                                            blurRadius: 2,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              CustomTextFormatter.formatDate(
                                                  currency.date.toString()),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.branded,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'OPEN: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .neutralDark, // Cor do texto do rótulo
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    'R\$ ${currency.open.toStringAsFixed(4)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.neutralDark,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'HIGHT: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .neutralDark, // Cor do texto do rótulo
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    'R\$ ${currency.high.toStringAsFixed(4)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.neutralDark,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'CLOSE: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .neutralDark, // Cor do texto do rótulo
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    'R\$ ${currency.close.toStringAsFixed(4)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.neutralDark,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                // RichText(
                                                //   text: TextSpan(
                                                //     children: [
                                                //       const TextSpan(
                                                //         text: "CLOSE:",
                                                //         style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w500,
                                                //           color: AppColors
                                                //               .neutralDark, // Cor do texto do rótulo
                                                //           fontSize: 11,
                                                //         ),
                                                //       ),
                                                //       TextSpan(
                                                //         text:
                                                //             "R\$ ${currency.close.toStringAsFixed(4)}",
                                                //         style: const TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w600,
                                                //           color: AppColors
                                                //               .neutralDark,
                                                //           fontSize: 16,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                const Spacer(),
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'LOW: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .neutralDark, // Cor do texto do rótulo
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    'R\$ ${currency.low.toStringAsFixed(4)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.neutralDark,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                // RichText(
                                                //   text: TextSpan(
                                                //     children: [
                                                //       const TextSpan(
                                                //         text: "LOW: ",
                                                //         style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w500,
                                                //           color: AppColors
                                                //               .neutralDark,
                                                //           fontSize: 11,
                                                //         ),
                                                //       ),
                                                //       TextSpan(
                                                //         text:
                                                //             "R\$ ${currency.low.toStringAsFixed(4)}",
                                                //         style: const TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w600,
                                                //           color: AppColors
                                                //               .neutralDark,
                                                //           fontSize: 16,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  width: 95,
                                                  child: Text(
                                                    'CLOSE DIFF (%): ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.neutralDark,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                if (currency.closeDiff > 0)
                                                  const Text(
                                                    '+',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.green,
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                Text(
                                                  '${currency.closeDiff.toStringAsFixed(2)}%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: currency.closeDiff ==
                                                            0
                                                        ? AppColors.neutralDark
                                                        : currency.closeDiff < 0
                                                            ? AppColors.red
                                                            : AppColors.green,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                // RichText(
                                                //   text: TextSpan(
                                                //     children: [
                                                //       const TextSpan(
                                                //         text: "CLOSE DIFF (%): ",
                                                //         style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w500,
                                                //           color: AppColors
                                                //               .neutralDark,
                                                //           fontSize: 11,
                                                //         ),
                                                //       ),
                                                //       TextSpan(
                                                //         text:
                                                //             "R\$ ${CustomTextFormatter.calcularDiferencaPercentual(currency.open, currency.close)}",
                                                //         style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w600,
                                                //           color: CustomTextFormatter
                                                //                       .calcularDiferencaPercentual(
                                                //                           currency
                                                //                               .open,
                                                //                           currency
                                                //                               .close) <
                                                //                   0
                                                //               ? Colors.red
                                                //               : Colors.green,
                                                //           fontSize: 16,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                if (currency.closeDiff != 0)
                                                  Icon(
                                                    currency.closeDiff < 0
                                                        ? Icons
                                                            .keyboard_arrow_down_sharp
                                                        : Icons
                                                            .keyboard_arrow_up_sharp,
                                                    color:
                                                        currency.closeDiff < 0
                                                            ? AppColors.red
                                                            : AppColors.green,
                                                    size: 24,
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(
                                  color: AppColors.branded,
                                  thickness: 2,
                                  height: 0,
                                ),
                              ],
                            ),
                          );
                        } else if (state is ErrorExceptionCurrencysState) {
                          return Center(
                            child: Text(
                              '${state.error ?? 'Erro desconhecido'}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        return const Center(
                            child: Text('Nenhum dado disponível.'));
                      }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 40,
        color: AppColors.branded,
        child: const Center(
          child: Text(
            'Copyright 2022 - Action Labs',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
