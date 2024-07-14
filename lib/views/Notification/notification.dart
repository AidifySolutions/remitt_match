import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';

class AppNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: noNotificationContainer(),
      ),
    );
  }
  Widget noNotificationContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/no_recipient.png',
          width: 200,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.resizeWidth(10.26),
              vertical: SizeConfig.resizeHeight(8.21)),
          alignment: Alignment.center,
          child: Text(
            'Currently You don\'t have notifications',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.resizeFont(12.31)),
          ),
        ),
      ],
    );
  }
}
