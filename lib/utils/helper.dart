import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Helper {
  static bool isValidEmail(String email) {
    var pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return false;
    else
      return true;
  }

  static String getEnumValue(String enumValue) {
    return enumValue.split('.').last;
  }

  static getToken(BuildContext context) {
    return Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.token
        ?.accessToken
        .toString();
  }

  static int calculateDays(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static String dateTimeFormat(String? date) {
    try {
      var parseDate = DateTime.parse(date ?? '');
      var formattedTime = parseDate.toLocal();
      var formattedDateTime =
          new DateFormat('dd MMM yyyy,').add_jm().format(formattedTime);
      return '$formattedDateTime';
    } on Exception catch (e) {
      print(e);
      return '';
    }
  }
}
