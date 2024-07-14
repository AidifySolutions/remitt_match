import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/otp_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneVerification extends StatefulWidget {
  final String customerId;
  final bool resendSMS;

  PhoneVerification({required this.customerId, required this.resendSMS});

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  late OtpProvider _otpProvider;
  late String _errorMessage;
  late Color _borderColor;

  @override
  void initState() {
    super.initState();
    _listenOtp();
    _otpProvider = Provider.of<OtpProvider>(context, listen: false);
    _otpProvider.resetPhoneVerified();
    _otpProvider.resetOtpSent();
    _errorMessage = "";
    _borderColor = Color(0xff30067F);
  }

  _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.resizeWidth(9.35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontSize: SizeConfig.resizeFont(16.83),
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.resizeHeight(5.61),
                  bottom: SizeConfig.resizeHeight(7.48),
                ),
                child: Text(
                  'An OTP has been sent to your registered phone number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.resizeFont(8.42),
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                'OTP',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: SizeConfig.resizeFont(8.5),
                    ),
              ),
              SizedBox(
                height: SizeConfig.resizeHeight(1),
              ),
              TextFieldPinAutoFill(
                decoration: buildInputDecoration(),
                currentCode: _otpProvider.otpCode,
                onCodeChanged: (code) {
                  _otpProvider.setOtpCode(code);
                  if (code.length == 6) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _otpProvider.validatePhone(widget.customerId, code);
                  }
                },
                onCodeSubmitted: (code) {
                  print('code submitted: $code');
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.resizeHeight(2),
                  bottom: SizeConfig.resizeHeight(8),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Consumer<OtpProvider>(builder: (context, response, child) {
                if (response.phoneVerified.status == Status.LOADING) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.resizeHeight(8),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  );
                } else if (response.phoneVerified.status == Status.COMPLETED) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showDialog(Icons.check_circle, 'OTP verified', 'Continue',
                        proceedToNextScreen: true);
                    response.resetPhoneVerified();
                  });
                  return buildProceedButton();
                } else if (response.phoneVerified.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showDialog(Icons.error,
                        response.phoneVerified.message.toString(), 'Close');
                    response.resetPhoneVerified();
                  });
                  return buildProceedButton();
                } else {
                  return buildProceedButton();
                }
              }),
              Consumer<OtpProvider>(builder: (context, response, child) {
                if (response.otpSent.status == Status.LOADING) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.resizeHeight(8),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  );
                } else if (response.otpSent.status == Status.COMPLETED) {
                  response.resetOtpSent();
                  return buildResendButton();
                } else if (response.otpSent.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showDialog(Icons.error,
                        response.otpSent.message.toString(), 'Close');
                    response.resetOtpSent();
                  });
                  return buildResendButton();
                } else {
                  return buildResendButton();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorMaxLines: 3,
      isDense: true,
      counterText: '',
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(
          color: _borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.5),
        borderSide: BorderSide(
          color: _borderColor,
        ),
      ),
    );
  }

  Padding buildProceedButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.resizeHeight(5),
      ),
      child: FmSubmitButton(
          text: 'Proceed',
          onPressed: () {
            if (_otpProvider.otpCode.isEmpty) {
              setState(() {
                _errorMessage = "Required";
                _borderColor = Colors.red;
              });
            } else if (_otpProvider.otpCode.length != 6) {
              setState(() {
                _errorMessage = "Invalid OTP";
                _borderColor = Colors.red;
              });
            } else {
              _errorMessage = "";
              _otpProvider.validatePhone(
                  widget.customerId, _otpProvider.otpCode);
              _borderColor = Theme.of(context).appBarTheme.foregroundColor!;
            }
          },
          showOutlinedButton: false),
    );
  }

  buildResendButton() {
    return FmSubmitButton(
        text: 'Resend',
        onPressed: () {
          _otpProvider.resendSms(widget.customerId, SmsType.PhoneVerification);
        },
        showOutlinedButton: true);
  }

  _showDialog(IconData iconData, String title, String buttonText,
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
                if (proceedToNextScreen) {
                  goToNewScreen(Login());
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

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }
}
