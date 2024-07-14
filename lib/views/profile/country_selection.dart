import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountrySelection extends StatefulWidget {
  @override
  _CountrySelectionState createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  late CustomerData? _customer;
  late CustomerProvider _customerProvider;

  late String _selectedCountry;
  late List<Country> _country;

  @override
  void initState() {
    super.initState();

    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    _customerProvider.reset();

    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;

    _country = Provider.of<CountryProvider>(context, listen: false)
        .country
        .data!
        .where((element) => element.forAddress == true)
        .toList();

    _selectedCountry = (_customer?.country != null
        ? _country
            .firstWhere((element) =>
                element.code.toString() == _customer?.country.toString())
            .code
        : "")!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(9.35),
            right: SizeConfig.resizeWidth(9.35),
            bottom: SizeConfig.resizeWidth(9.35),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.resizeHeight(3.74),
                  ),
                  child: Text(
                    'Fiat Match is currently operating in the following countries. If your country is not listed let us know. We will notify you when its available.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.resizeFont(8.42),
                        fontWeight: FontWeight.w400),
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: _country.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      onTap: () {
                        setState(() {
                          _selectedCountry = _country[index].code.toString();
                        });
                      },
                      title: Text(
                        _country[index].name.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.resizeFont(8.42),
                            color: Colors.black),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'flags/' +
                              _country[index].code.toString().toLowerCase() +
                              '.png',
                          width: SizeConfig.resizeWidth(6),
                        ),
                      ),
                      trailing: _selectedCountry == _country[index].code
                          ? Icon(
                              Icons.check_circle,
                              size: SizeConfig.resizeWidth(6),
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              size: SizeConfig.resizeWidth(6),
                              color: Theme.of(context).accentColor,
                            ),
                    );
                  },
                ),
              ),
              Consumer<CustomerProvider>(builder: (context, response, child) {
                if (response.customer.status == Status.LOADING) {
                  return Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                } else if (response.customer.status == Status.COMPLETED) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                  return buildSaveButton();
                } else if (response.customer.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showDialog(response.customer.message.toString(), 'close');
                    response.reset();
                  });
                  return buildSaveButton();
                } else {
                  return buildSaveButton();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  FmSubmitButton buildSaveButton() {
    return FmSubmitButton(
        text: 'Save',
        onPressed: () {
          if (_selectedCountry.isNotEmpty) {
            _customerProvider.updateCustomer(_customer?.id, _getRequestBody());
          } else {
            _showDialog('Select a country', 'close');
          }
        },
        showOutlinedButton: false);
  }

  Map<String, dynamic> _getRequestBody() {
    var body = {
      "title": _customer?.title,
      "firstName": _customer?.firstName,
      "lastName": _customer?.lastName,
      "bio": _customer?.bio,
      "nickName": _customer?.nickName,
      "dateOfBirth": _customer?.dateOfBirth,
      "phoneNumber": _customer?.phoneNumber,
      "email": _customer?.email,
      "address1": _customer?.address1,
      "address2": _customer?.address2,
      "city": _customer?.city,
      "occupation": _customer?.occupation,
      "employment": _customer?.employment,
      "incomeSource": _customer?.incomeSource,
      "country": _selectedCountry,
    };

    return body;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Select your country'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  _showDialog(String title, String buttonText, {bool closeScreen = false}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: Icons.error,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                Navigator.pop(dialogContext);
                if (closeScreen) {
                  Navigator.pop(context);
                }
              });
        });
  }
}
