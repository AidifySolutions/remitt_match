import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomerCare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(10.26),
            right: SizeConfig.resizeWidth(10.26),
            top: SizeConfig.resizeWidth(10.26),
            bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/customer_care_image.png',
              width: SizeConfig.resizeWidth(51.28),
              height: SizeConfig.resizeHeight(38.46),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(8.21),
            ),
            Text(
              'If you need any help we are always available. If you need help or would like to get in touch with us, you can reach out. We are here for you.',
              style: TextStyle(
                  color: Colors.black, fontSize: SizeConfig.resizeFont(12.31)),
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(4.11),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Call:',
                        style: TextStyle(
                            fontSize: SizeConfig.resizeFont(10.8),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).appBarTheme.foregroundColor),
                      ),
                      Text(
                        '+123 456 7890',
                        style: TextStyle(
                            fontSize: SizeConfig.resizeFont(10.8),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).appBarTheme.foregroundColor),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: SizeConfig.resizeFont(10.8),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).appBarTheme.foregroundColor),
                      ),
                      Text(
                        'itachi@fiatmatch.com',
                        style: TextStyle(
                            fontSize: SizeConfig.resizeFont(10.8),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).appBarTheme.foregroundColor),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Customer Care',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }
}
