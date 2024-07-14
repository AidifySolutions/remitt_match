import 'dart:io';

import 'package:fiat_match/models/authentication.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/aes_utils.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/forgot_password/forgot_password.dart';
import 'package:fiat_match/views/home/landing_new.dart';
import 'package:fiat_match/views/registration/email_confirmation.dart';
import 'package:fiat_match/views/registration/phone_verification.dart';
import 'package:fiat_match/views/registration/registration.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_phone_field.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_verification.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneNumberController;
  late LoginProvider _loginProvider;

  late List<Country> _country;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();

    _loginProvider = Provider.of<LoginProvider>(context, listen: false);
    _loginProvider.reset();

    _country =
        Provider.of<CountryProvider>(context, listen: false).country.data!;
    _selectedCountry = _country[0];

    // _emailController.text = 'wajiha.umar@unikrew.com';
    // _passwordController.text = 'wajiha123';
    // _emailController.text = 'fizza.syed@unikrew.com';
    // _passwordController.text = 'Unikrew@123';

    // _emailController.text = 'rao.noman082@gmail.com';
    // _passwordController.text = 'abc12345';
    //
    // _emailController.text = 'ahmed.ali@unikrew.com';
    // _passwordController.text = 'fiat@1234';

    // _emailController.text = 'maryamakram783@gmail.com';
    // _passwordController.text = 'Xuzzle@123';

    // _emailController.text = 'maryam.akram@unikrew.com';
    // _passwordController.text = 'Xuzzle&123';

    //
    // _emailController.text = 'Faisal.mansoor@unikrew.com';
    // _passwordController.text = 'sit@1234';

    // _emailController.text = 'hasanaamirb@gmail.com';
    // _passwordController.text = 'hasan123';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SizeConfig().init(context);
    return Scaffold(
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
                    buildForgotPassword(),
                    buildButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildFormField() {
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
            Consumer<LoginProvider>(builder: (context, response, child) {
              if (response.logInWithMobile) {
                return FmPhoneFields(
                    title: 'Phone No.',
                    textEditingController: _phoneNumberController,
                    textInputAction: TextInputAction.done,
                    autoFocus: false,
                    maxLines: 1,
                    country: _country,
                    initialValue: _selectedCountry,
                    isLoginPage: true,
                    selectedCountry: (value) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    });
              } else {
                return FmInputFields(
                    title: 'Email',
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
                    isLoginUsernameField: true);
              }
            }),
            SizedBox(
              height: SizeConfig.resizeHeight(5.61),
            ),
            FmInputFields(
                title: 'Password',
                obscureText: true,
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onValidation: (value) {
                  if (value.isEmpty) {
                    return 'Required';
                  }
                },
                autoFocus: false,
                maxLines: 1),
          ],
        ),
      ),
    );
  }

  Container buildForgotPassword() {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
        top: SizeConfig.resizeHeight(5.61),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: Text(
          'Forgot password',
          textAlign: TextAlign.center,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: SizeConfig.resizeFont(8.5),
          ),
        ),
      ),
    );
  }

  Container buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
        top: SizeConfig.resizeHeight(15),
        bottom: SizeConfig.resizeHeight(6),
      ),
      child: Text(
        'Log in',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(22.43),
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
    );
  }

  Container buildButtons() {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.resizeWidth(9.35),
        right: SizeConfig.resizeWidth(9.35),
        top: SizeConfig.resizeHeight(7.58),
        bottom: SizeConfig.resizeHeight(14.95),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<LoginProvider>(builder: (context, response, child) {
            if (response.authentication.status == Status.LOADING) {
              return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            } else if (response.authentication.status == Status.COMPLETED) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                navigateToNewScreen(response.authentication.data);
                response.authentication.status = Status.INITIAL;
              });
              return buildLoginButton();
            } else if (response.authentication.status == Status.ERROR) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showErrorDialog(
                    response.authentication.message.toString(), 'Close');
                response.reset();
              });
              return buildLoginButton();
            } else {
              return buildLoginButton();
            }
          }),
          SizedBox(
            height: SizeConfig.resizeHeight(5.61),
          ),
          FmSubmitButton(
              text: 'Sign up',
              onPressed: () {
                goToNewScreen(Registration());
              },
              showOutlinedButton: true),
        ],
      ),
    );
  }

  FmSubmitButton buildLoginButton() {
    // print(
    //   AesUtils.aesEncryptedText(_passwordController.text.toString()),
    // );
    return FmSubmitButton(
        text: 'Log in',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).requestFocus(new FocusNode());
            _loginProvider.authenticate(
                _emailController.text.toString().toLowerCase().trim(),
                AesUtils.aesEncryptedText(_passwordController.text.toString()),
                _selectedCountry.dialCode.toString(),
                _phoneNumberController.text.toString(),
                _selectedCountry.code.toString(),
                _loginProvider.logInWithMobile
                    ? LoginType.Mobile
                    : LoginType.Username);
          }
        },
        showOutlinedButton: false);
  }

  navigateToNewScreen(Authentication? authentication) {
    if (!authentication!.customerData!.isEmailVerified) {
      goToNewScreen(EmailConfirmation(
        customerId: authentication.customerData!.id.toString(),
        resendEmail: false,
      ));
    } else if (!authentication.customerData!.isPhoneVerified) {
      goToNewScreen(PhoneVerification(
        customerId: authentication.customerData!.id.toString(),
        resendSMS: true,
      ));
    } else {
      goToNewScreen(LoginVerification(
          customerId: authentication.customerData!.id.toString(),
          resendSMS: false));
    // goToNewScreen(LandingNewPage());
    }
  }

  goToNewScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  _showErrorDialog(String title, String buttonText) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: Icons.error,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                Navigator.pop(dialogContext);
              });
        });
  }
}
