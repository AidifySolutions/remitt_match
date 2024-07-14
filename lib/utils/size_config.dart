import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
  }

  static double resizeWidth(double percent){
    return (_screenWidth/100)*percent;
  }

  static double resizeHeight(double percent){
    return (_screenWidth/100)*percent;
  }

  static double resizeFont(doublePercent){
    return doublePercent * (_screenWidth/3) /100;
  }

}