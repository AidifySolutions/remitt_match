import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/forgot_password_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/forgot_password/reset_password.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
 // StreamSubscription? _sub;
  late TextEditingController _emailController;
  //String? deepLinkURL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    //initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordProvider>(
      create: (context) => ForgotPasswordProvider(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
        body: Stack(
          children: [
            Image.asset('assets/login-background-img.png'),
            buildHeader(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        SizeConfig.resizeHeight(25.81)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      buildFormField(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> initUniLinks() async {
  //   // ... check initialUri
  //
  //   // Attach a listener to the stream
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     print("url");
  //   }, onError: (err) {
  //     // Handle exception by warning the user their action did not succeed
  //   });
  //
  //   // NOTE: Don't forget to call _sub.cancel() in dispose()
  // }

  Container buildHeader() {
    return Container(
        padding: EdgeInsets.only(
          left: SizeConfig.resizeWidth(9.35),
          right: SizeConfig.resizeWidth(9.35),
          top: SizeConfig.resizeHeight(15),
          bottom: SizeConfig.resizeHeight(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forget',
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(22.43),
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              'Password',
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(22.43),
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Container buildFormField() {
    print(SizeConfig.resizeHeight(38.466));
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
        top: Platform.isAndroid
            ? SizeConfig.resizeWidth(7)
            : SizeConfig.resizeWidth(1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your email address and we will send a password reset link to your email address.',
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(10.8),
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(8.21),
            ),
            FmInputFields(
              title: 'Email *',
              obscureText: false,
              textEditingController: _emailController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onValidation: (value) {
                if (value.isEmpty) {
                  return 'Required';
                } else if (!Helper.isValidEmail(value)) {
                  return 'Invalid email address';
                }
              },
              autoFocus: false,
              maxLines: 1,
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(10.26),
            ),
            Consumer<ForgotPasswordProvider>(
                builder: (context, response, child) {
              if (response.forgotPassword.status == Status.LOADING) {
                return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              } else if (response.forgotPassword.status == Status.ERROR) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _showDialog(response.forgotPassword.message.toString(),
                      'Close', Icons.error);
                });
              } else if (response.forgotPassword.status == Status.COMPLETED) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  response.forgotPassword.data?.customerData != null
                      ? _showDialog('Reset password email sent successfully.',
                          'Close', Icons.check_circle)
                      : _showDialog(
                          response.forgotPassword.data?.message.toString() == '' ? 'please enter correct email address': response.forgotPassword.data!.message.toString(),
                          'Close',
                          Icons.error);
                });
              }
              return FmSubmitButton(
                  text: 'Continue',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<ForgotPasswordProvider>()
                          .sendForgotPassword(_emailController.text.toLowerCase().trim());
                    }
                  },
                  showOutlinedButton: false);
            }),
            SizedBox(
              height: SizeConfig.resizeHeight(38.466),
            )
          ],
        ),
      ),
    );
  }

  _showDialog(String title, String buttonText, IconData icon) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                //context.read<ForgotPasswordProvider>().reset();
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => Login()));
              });

        });
  }
}
