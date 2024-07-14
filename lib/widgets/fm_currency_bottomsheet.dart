import 'package:fiat_match/models/currency.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FmCurrencyBottomSheet extends StatefulWidget {
  final Function(String?) onTap;
  final String title;
  final String disableCurrency;
  FmCurrencyBottomSheet({required this.onTap, required this.title, required this.disableCurrency});

  @override
  _FmCurrencyBottomSheetState createState() => _FmCurrencyBottomSheetState();
}

class _FmCurrencyBottomSheetState extends State<FmCurrencyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.resizeFont(13)),
              ),
            ),
            Consumer<CurrencyProvider>(
              builder: (context, response, child) {
                if (response.currency.status == Status.COMPLETED) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: response.currency.data?.currencies?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        //enabled: response.currency.data?.currencies?[index].name != widget.disableCurrency,
                        onTap: () => widget
                            .onTap(response.currency.data?.currencies?[index].name),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'flags/${response.currency.data?.currencies?[index].code.toString().toLowerCase()}.png',
                            width: 36,
                          ),
                        ),
                        title: Text(
                            '${response.currency.data?.currencies?[index].name}'),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
