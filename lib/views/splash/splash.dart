import 'dart:async';

import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/shared_pref.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/registration/registration.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../onbording/onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = false;
    Timer(Duration(seconds: 1), () async {
      setState(() {
        _visible = true;
      });
      Provider.of<CountryProvider>(context, listen: false).getCountry();
      Provider.of<CurrencyProvider>(context, listen: false).getCurrency();
    });
  }

  Future goToNewScreen() async {
    bool visitedSecondTime =
        SharedPref.getValue(Constants.keyVisitedSecondTime) ?? false;
    if (visitedSecondTime) {
//      Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(
//            builder: (BuildContext context) => AccountSetupPage()),
//      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Login()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/splash_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Consumer2<CountryProvider, CurrencyProvider>(
                builder: (context, countryResponse, currencyResponse, child) {
              if (countryResponse.country.status == Status.COMPLETED &&
                  currencyResponse.currency.status == Status.COMPLETED) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  goToNewScreen();
                });
                return _logo();
              } else if (countryResponse.country.status == Status.ERROR ||
                  currencyResponse.currency.status == Status.ERROR) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _showSnackBar(countryResponse.country.message.toString());
                });
                return _logo();
              } else if (countryResponse.country.status == Status.LOADING ||
                  currencyResponse.currency.status == Status.LOADING) {
                return _logo();
              } else {
                return _logo();
              }
            }),
          ),
        ),
      ),
    );
  }

  _logo() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      child: Image(
        image: AssetImage('assets/splash_logo.png'),
        fit: BoxFit.contain,
        width: SizeConfig.resizeWidth(68.37),
        height: SizeConfig.resizeHeight(43.59),
      ),
    );
  }

  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          Provider.of<CountryProvider>(context, listen: false).getCountry();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
