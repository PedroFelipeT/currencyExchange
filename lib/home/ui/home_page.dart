import 'package:currency_exchange_app/shared/constants/app_images.dart';
import 'package:currency_exchange_app/shared/widgets/custom_bottom.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/theme/app_colors.dart';
import '../controller/currency_controller.dart';
import '../model/currency_exchange_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                  inputDecorationTheme: const InputDecorationTheme(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.grey,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                child: TextFormField(
                  controller: _controller,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insert a currency';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10,
                    ),
                    hintText: _controller.text.isEmpty
                        ? "Enter the currency code"
                        : null,
                    hintStyle: const TextStyle(
                      color: AppColors.neutralDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: AppColors.grey.withOpacity(0.35),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.branded,
                        width: 2,
                      ),
                    ),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    labelText: FocusScope.of(context).hasFocus ||
                            _controller.text.isNotEmpty
                        ? 'Enter the currency code'
                        : null,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: AppColors.branded,
                      fontWeight: FontWeight.w400,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  style: const TextStyle(color: AppColors.neutralDark),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomBottom(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var data = await CurrencyDataSource(dio: dio)
                      .getCurrentExchangeRate(_controller.text);
                  CurrencyExchange currency = CurrencyExchange.fromJson(data);
                  currency.toString();
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
            Visibility(
              child: Column(
                children: [
                  const Divider(
                    color: AppColors.grey,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Exchange rate now',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.neutralDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '09/03/2022 - 15h09',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.dark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'USD/BRL',
                        style: TextStyle(
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
                    child: const Center(
                      child: Text(
                        'R\$ 5,00',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.branded,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
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
