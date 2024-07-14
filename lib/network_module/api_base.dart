import 'package:flutter/foundation.dart';

class ApiBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "https://teennkidz.com/fiatmatch";
    } else {
      return "https://teennkidz.com/fiatmatch";
    }
  }
}
