import 'dart:io';

import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/utils/aes_utils.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/registration/email_confirmation.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_phone_field.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late List<Country> _country;
  late Country _selectedCountry;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late CustomerProvider _customerProvider;

  late bool _termsAndCondition1;
  late bool _termsAndCondition2;

  @override
  void initState() {
    super.initState();
    _country =
        Provider.of<CountryProvider>(context, listen: false).country.data!;
    _selectedCountry = _country[0];

    _firstNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _termsAndCondition1 = false;
    _termsAndCondition2 = false;

    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    _customerProvider.reset();
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
                  children: [
                    buildFormField(),
                    buildTermsAndCondition(),
                    buildButtons()
                  ],
                ),
              ),
            ),
          ),
        ],
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
        'Sign Up',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(22.43),
            fontWeight: FontWeight.w700,
            color: Colors.white),
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
          children: [
            FmInputFields(
                title: 'Name',
                obscureText: false,
                textEditingController: _firstNameController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onValidation: (value) {
                  if (value.isEmpty) {
                    return 'Required';
                  } else if (value.length <= 2) {
                    return 'Minimum 2 characters are required';
                  }
                },
                autoFocus: false,
                maxLines: 1),
            SizedBox(
              height: SizeConfig.resizeHeight(5.61),
            ),
            buildFormPhoneField(),
            SizedBox(
              height: SizeConfig.resizeHeight(5.61),
            ),
            FmInputFields(
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
                maxLines: 1),
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
                } else if (value.length < 8) {
                  return 'Min. 8 characters required';
                }
              },
              autoFocus: false,
              maxLines: 1,
              isRegistrationPage: true,
            ),
          ],
        ),
      ),
    );
  }

  Container buildFormPhoneField() {
    return Container(
      child: Column(
        children: [
          FmPhoneFields(
              title: 'Phone Number',
              textEditingController: _phoneNumberController,
              textInputAction: TextInputAction.done,
              autoFocus: false,
              maxLines: 1,
              country: _country,
              initialValue: _selectedCountry,
              selectedCountry: (value) {
                setState(() {
                  _selectedCountry = value;
                });
              })
        ],
      ),
    );
  }

  Container buildTermsAndCondition() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.resizeWidth(15.89),
          right: SizeConfig.resizeWidth(15.89),
          top: SizeConfig.resizeHeight(7.48)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _termsAndCondition1 = !_termsAndCondition1;
                    });
                  },
                  child: Icon(
                    _termsAndCondition1
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: Theme.of(context).textTheme.bodyText2!.color,
                    size: SizeConfig.resizeWidth(4),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.resizeWidth(3.74),
              ),
              RichText(
                text: TextSpan(
                    text: 'I agree to the ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: SizeConfig.resizeFont(8.5)),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: SizeConfig.resizeFont(8.5),
                            decoration: TextDecoration.underline),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: SizeConfig.resizeFont(8.5)),
                      ),
                      TextSpan(
                        text: 'Conditions.',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: SizeConfig.resizeFont(8.5),
                            decoration: TextDecoration.underline),
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.resizeHeight(3.74),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _termsAndCondition2 = !_termsAndCondition2;
                    });
                  },
                  child: Icon(
                    _termsAndCondition2
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: Theme.of(context).textTheme.bodyText2!.color,
                    size: SizeConfig.resizeWidth(4),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.resizeWidth(3.74),
              ),
              Flexible(
                child: Text(
                  'I agree to have my information taken and used by this platform.',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: SizeConfig.resizeFont(8.5),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildButtons() {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.resizeHeight(9.35),
        right: SizeConfig.resizeHeight(9.35),
        top: SizeConfig.resizeHeight(9.97),
        bottom: SizeConfig.resizeHeight(14.95),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<CustomerProvider>(builder: (context, response, child) {
            if (response.customer.status == Status.LOADING) {
              return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            } else if (response.customer.status == Status.COMPLETED) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                goToNewScreen(EmailConfirmation(
                  customerId:
                      response.customer.data!.customerData!.id.toString(),
                  resendEmail: false,
                ));
                response.reset();
              });
              return buildRegistrationButton();
            } else if (response.customer.status == Status.ERROR) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showErrorDialog(response.customer.message.toString(), 'Close');
                response.reset();
              });
              return buildRegistrationButton();
            } else {
              return buildRegistrationButton();
            }
          }),
          SizedBox(
            height: SizeConfig.resizeHeight(5.61),
          ),
          FmSubmitButton(
              text: 'Log in',
              onPressed: () {
                goToNewScreen(Login());
              },
              showOutlinedButton: true),
        ],
      ),
    );
  }

  FmSubmitButton buildRegistrationButton() {
    return FmSubmitButton(
        text: 'Sign up',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if(_termsAndCondition1 && _termsAndCondition2){
              _customerProvider.createNewCustomer(
                  _firstNameController.text.toString(),
                  _phoneNumberController.text.toString(),
                  _selectedCountry.dialCode.toString(),
                  _selectedCountry.code.toString(),
                  _emailController.text.toString().toLowerCase().trim(),
                 AesUtils.aesEncryptedText(_passwordController.text.toString()));
            }else{
              _showErrorDialog('Please agree to all the Terms and Conditions', 'close');
            }
          }
        },
        showOutlinedButton: false);
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
