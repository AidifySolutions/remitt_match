import 'dart:io';

import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/reset_password_provider.dart';
import 'package:fiat_match/utils/aes_utils.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResetPasswordProvider>(
      create: (context) => ResetPasswordProvider(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
        body: Stack(
          children: [
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

  Container buildHeader() {
    return Container(
        padding: EdgeInsets.only(
          left: SizeConfig.resizeWidth(9.35),
          right: SizeConfig.resizeWidth(9.35),
          top: SizeConfig.resizeHeight(15),
          bottom: SizeConfig.resizeHeight(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reset',
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
    print('height--${SizeConfig.resizeHeight(18)}');
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
          child: Consumer<ResetPasswordProvider>(
              builder: (context, response, child) {
            if (response.isPasswordResetSuccess) {
              return buildSuccessContainer();
            } else {
              return buildResetForm();
            }
          })),
    );
  }

  Container buildSuccessContainer() {
    return Container(
      child: Column(
        children: [
          Text(
            'Password reset',
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(18.47),
                fontWeight: FontWeight.w700,
                color: Theme.of(context).appBarTheme.foregroundColor),
          ),
          Text(
            'Successful',
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(18.47),
                fontWeight: FontWeight.w700,
                color: Theme.of(context).appBarTheme.foregroundColor),
          ),
          SizedBox(height: SizeConfig.resizeHeight(10.26)),
          Icon(CupertinoIcons.check_mark_circled,
              size: SizeConfig.resizeWidth(24.62),
              color: Theme.of(context).colorScheme.secondary),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.resizeWidth(14.7),
                vertical: SizeConfig.resizeWidth(10.26)),
            child: Text(
              'Your password reset was successful, please head to the log in page and sign in with your new password.',
              style: TextStyle(fontSize: 12.31, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          FmSubmitButton(
              text: 'Go to Log in',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false);
              },
              showOutlinedButton: false),
          SizedBox(height: SizeConfig.resizeHeight(18))
        ],
      ),
    );
  }

  Container buildResetForm() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Type your new password.',
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(10.8),
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
          SizedBox(
            height: SizeConfig.resizeHeight(8.21),
          ),
          FmInputFields(
            title: 'New password *',
            obscureText: true,
            textEditingController: _newPassword,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onValidation: (value) {
              if (value.isEmpty) {
                return 'Required';
              } else if (value.length < 8) {
                return 'Min. 8 Characters required';
              }
            },
            autoFocus: false,
            maxLines: 1,
            isRegistrationPage: true,
          ),
          SizedBox(
            height: SizeConfig.resizeHeight(10.26),
          ),
          Consumer<ResetPasswordProvider>(builder: (context, response, child) {
            if (response.resetPassword.status == Status.LOADING) {
              return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            } else if (response.resetPassword.status == Status.ERROR) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showDialog(response.resetPassword.message.toString(), 'Cancel',
                    Icons.error_outline);
              });
            } else if (response.resetPassword.status == Status.COMPLETED) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                if (response.resetPassword.data?.customerData == null) {
                  _showDialog(response.resetPassword.data!.message.toString(),
                      'Close', Icons.error);
                }
              });
            }
            return FmSubmitButton(
                text: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    resetNewPassword(context);
                  }
                },
                showOutlinedButton: false);
          }),
          SizedBox(
            height: SizeConfig.resizeHeight(38.466),
          )
        ],
      ),
    );
  }

  void resetNewPassword(BuildContext context) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oldPassword'] = '';
    data['password'] = AesUtils.aesEncryptedText(_newPassword.text);
    data['resetPurpose'] = 'Forget';
    String code = '000216';

    print("Pwd" + AesUtils.aesEncryptedText(_newPassword.text));

    context.read<ResetPasswordProvider>().sendResetPassword('', code, data);
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
              });
        });
  }
}
