import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/email_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/registration/phone_verification.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailConfirmation extends StatefulWidget {
  final String customerId;
  final bool resendEmail;

  EmailConfirmation({required this.customerId, required this.resendEmail});

  @override
  _EmailConfirmationState createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  late EmailProvider _emailProvider;
  late CustomerProvider _customerProvider;

  @override
  void initState() {
    super.initState();
    _emailProvider = Provider.of<EmailProvider>(context, listen: false);
    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    _emailProvider.reset();
    _customerProvider.reset();

    if (widget.resendEmail) {
      _emailProvider.resendEmail(widget.customerId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Email Confirmation',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: SizeConfig.resizeFont(16.83),
                    fontWeight: FontWeight.w700),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.resizeWidth(17.17),
                    right: SizeConfig.resizeWidth(17.17),
                    top: SizeConfig.resizeHeight(5.61)),
                width: SizeConfig.resizeWidth(49.82),
                height: SizeConfig.resizeHeight(49.82),
                child: Image.asset('assets/email_confirmation.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.resizeWidth(20.65),
                  vertical: SizeConfig.resizeHeight(7.48),
                ),
                child: Text(
                  'Click the link in your email to confirm your account. If you can’t find the email, check your spam folder or click the link below to resend.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.resizeFont(8.42),
                      fontWeight: FontWeight.w400),
                ),
              ),
              Consumer<CustomerProvider>(builder: (context, response, child) {
                if (response.customer.status == Status.LOADING) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.resizeHeight(10),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  );
                } else if (response.customer.status == Status.COMPLETED) {
                  if (response.customer.data!.customerData!.isEmailVerified) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _showErrorDialog(
                          Icons.check_circle, 'Email verified', 'Continue',
                          proceedToNextScreen: true);
                      response.reset();
                    });
                  } else {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _showErrorDialog(Icons.error,
                          'You have not verified your email', 'Close');
                      response.reset();
                    });
                  }
                  return buildIHaveCompletedButton();
                } else if (response.customer.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showErrorDialog(Icons.error,
                        response.customer.message.toString(), 'Close');
                    response.reset();
                  });
                  return buildIHaveCompletedButton();
                } else {
                  return buildIHaveCompletedButton();
                }
              }),
              Consumer<EmailProvider>(builder: (context, response, child) {
                if (response.emailSent.status == Status.LOADING) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.resizeHeight(10),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  );
                } else if (response.emailSent.status == Status.COMPLETED) {
                  response.reset();
                  return buildResendEmailButton();
                } else if (response.emailSent.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showErrorDialog(Icons.error,
                        response.emailSent.message.toString(), 'Close');
                    response.reset();
                  });
                  return buildResendEmailButton();
                } else {
                  return buildResendEmailButton();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildIHaveCompletedButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
        bottom: SizeConfig.resizeHeight(7.48),
      ),
      child: FmSubmitButton(
          text: 'I have completed',
          onPressed: () {
            _customerProvider.getCustomer(widget.customerId.toString());
          },
          showOutlinedButton: false),
    );
  }

  Padding buildResendEmailButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
//        bottom: SizeConfig.resizeHeight(7.48),
      ),
      child: FmSubmitButton(
          text: 'Resend email',
          onPressed: () {
            _emailProvider.resendEmail(widget.customerId.toString());
          },
          showOutlinedButton: true),
    );
  }

  _showErrorDialog(IconData iconData, String title, String buttonText,
      {bool proceedToNextScreen = false}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: iconData,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                Navigator.pop(dialogContext);
                if(proceedToNextScreen){
                  goToNewScreen(PhoneVerification(
                    customerId: widget.customerId,
                    resendSMS: false,
                  ));
                }
              });
        });
  }

  goToNewScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
