import 'package:fiat_match/models/onboarding_content.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/shared_pref.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/views/registration/registration.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: currentIndex % 2 != 0
          ? Theme.of(context).primaryColor
          : Theme.of(context).appBarTheme.foregroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            width: SizeConfig.resizeWidth(76.93),
                            // 300dp
                            height: SizeConfig.resizeWidth(76.93),
                            // 300dp
                            image: AssetImage(contents[i].image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(10.26)), //40
                      child: Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: i % 2 == 1 ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.resizeFont(18.47)), //24
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(10.26)), //40
                      child: Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: i % 2 == 1 ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.resizeFont(9.24)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: SizeConfig.resizeWidth(10.26)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.resizeWidth(10.26),
                vertical: SizeConfig.resizeWidth(10.26)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: SizeConfig.resizeWidth(22.57), // 88,
                  child: FmSubmitButton(
                    text: 'Skip',
                    onPressed: () => redirectToNewScreen(Registration()),
                    showOutlinedButton: true,
                  ),
                ),
                Container(
                  width: SizeConfig.resizeWidth(22.57), // 88,
                  child: FmSubmitButton(
                    text: currentIndex == contents.length - 1
                        ? 'Sign up'
                        : 'Next',
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        redirectToNewScreen(Registration());
                      } else {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    showOutlinedButton: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: SizeConfig.resizeWidth(1.03), //4,
      width: currentIndex == index
          ? SizeConfig.resizeWidth(4.11)
          : SizeConfig.resizeWidth(2.06),
      margin: EdgeInsets.only(right: SizeConfig.resizeWidth(2.06)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == 1
            ? Theme.of(context)
                .appBarTheme
                .foregroundColor //Theme.of(context).colorScheme.secondary
            : Colors.white,
      ),
    );
  }

  redirectToNewScreen(Widget newScreen) async {
    await SharedPref.setValueBool(Constants.keyVisitedSecondTime, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => newScreen),
    );
  }
}
