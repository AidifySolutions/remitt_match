import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/provider/channel_detail_provider.dart';
import 'package:fiat_match/provider/new/city_provider.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/document_provider.dart';
import 'package:fiat_match/provider/new/email_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/provider/new/otp_provider.dart';
import 'package:fiat_match/provider/new/payment_plan_provider.dart';
import 'package:fiat_match/provider/new/province_provider.dart';
import 'package:fiat_match/provider/new/rate_provider.dart';
import 'package:fiat_match/provider/new/trade_payment_provider%20copy.dart';
import 'package:fiat_match/provider/new/trade_provider.dart';
import 'package:fiat_match/provider/new/transaction_history_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/provider/notification_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/shared_pref.dart';
import 'package:fiat_match/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPref.init();
  runApp(MyApp());

//  SystemChrome.setSystemUIOverlayStyle(
//    SystemUiOverlayStyle(
//        statusBarColor: Colors.red,
//        statusBarIconBrightness: Brightness.light),
//  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fiat Match',
        theme: ThemeData(
          appBarTheme: buildAppBarTheme(),
          fontFamily: 'Poppins',
          primaryColor: Color(0xffffffff),
          accentColor: Color(0xff2FBF71),
          textTheme: buildTextTheme(),
          inputDecorationTheme: buildInputDecorationTheme(),
          bottomNavigationBarTheme: buildBottomNavigationBarThemeData(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SplashScreen(),
        ),
      ),
    );
  }

  List<SingleChildWidget> providers() {
    return [
      // ChangeNotifierProvider<CustomerProvider>(
      //     create: (context) => CustomerProvider()),
      ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(context)),
      ChangeNotifierProvider<CountryProvider>(
          create: (context) => CountryProvider(context)),
      ChangeNotifierProvider<RecipientProvider>(
          create: (context) => RecipientProvider(context)),
      ChangeNotifierProvider<CurrencyProvider>(
          create: (context) => CurrencyProvider(context)),
      ChangeNotifierProvider<ChannelDetailProvider>(
          create: (context) => ChannelDetailProvider(context)),
      ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(context)),
      ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(context)),
      ChangeNotifierProvider<EmailProvider>(
          create: (context) => EmailProvider(context)),
      ChangeNotifierProvider<OtpProvider>(
          create: (context) => OtpProvider(context)),
      ChangeNotifierProvider<DocumentProvider>(
          create: (context) => DocumentProvider(context)),
      ChangeNotifierProvider<UserOffersProvider>(
          create: (context) => UserOffersProvider(context)),
      // ChangeNotifierProvider<TradeProvider>(
      //     create: (context) => TradeProvider(context)),
      ChangeNotifierProvider<MidMarketRateProvider>(
          create: (context) => MidMarketRateProvider(context)),
      ChangeNotifierProvider<RatingProvider>(
          create: (context) => RatingProvider(context)),
      ChangeNotifierProvider<PaymentPlanProvider>(
          create: (context) => PaymentPlanProvider(context)),
      ChangeNotifierProvider<TransactionHistoryProvider>(
          create: (context) => TransactionHistoryProvider(context)),
      ChangeNotifierProvider<ProvinceProvider>(
          create: (context) => ProvinceProvider(context)),
      ChangeNotifierProvider<CityProvider>(
          create: (context) => CityProvider(context)),
      ChangeNotifierProvider<TradingProvider>(
          create: (context) => TradingProvider(context)),
      ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(context)),
      ChangeNotifierProvider<TradePaymentProvider>(
          create: (context) => TradePaymentProvider(context)),
    ];
  }

  TextTheme buildTextTheme() {
    return TextTheme(
      bodyText2: TextStyle(
        color: Color(0xff4F4F4F),
      ),
    );
  }

  AppBarTheme buildAppBarTheme() {
    return AppBarTheme(
      foregroundColor: Color(0xff30067F),
      backgroundColor: Color(0xffffffff),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      elevation: 3,
    );
  }

  BottomNavigationBarThemeData buildBottomNavigationBarThemeData() {
    return BottomNavigationBarThemeData(
        unselectedItemColor: Color(0xff30067F),
        selectedItemColor: Color(0xff00A6FB),
        backgroundColor: Color(0xffffffff));
  }

  InputDecorationTheme buildInputDecorationTheme() {
    return InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(
          color: Color(0xffC4C4c4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(
          color: Color(0xff30067F),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }
}
