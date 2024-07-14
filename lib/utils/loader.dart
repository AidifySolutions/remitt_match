import 'package:fiat_match/utils/styles.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 80,
              width: 80,
              margin: EdgeInsets.all(5),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(FiatColors.fiatGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Divider divider() {
  return Divider(
    color: FiatColors.fiatGrey,
  );
}
