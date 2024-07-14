import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/change_password_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/aes_utils.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangePasswordProvider>(
      create: (context) => ChangePasswordProvider(context),
      child: Scaffold(
          appBar: buildAppBar(),
          body: Container(
            padding: EdgeInsets.only(
                left: SizeConfig.resizeWidth(10.26),
                right: SizeConfig.resizeWidth(10.26),
                top: SizeConfig.resizeWidth(10.26),
                bottom: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FmInputFields(
                    title: 'Current Password *',
                    obscureText: true,
                    textEditingController: _currentPasswordController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isRegistrationPage: false,

                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(4.11),
                  ),
                  FmInputFields(
                    title: 'New Password *',
                    obscureText: true,
                    textEditingController: _newPasswordController,
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
                  Consumer<ChangePasswordProvider>(
                      builder: (context, response, child) {
                    if (response.changePassword.status == Status.LOADING) {
                      return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator());
                    } else if (response.changePassword.status == Status.ERROR) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _showErrorDialog(
                            response.changePassword.message.toString(),
                            'Cancel',
                            Icons.error_outline);
                      });
                    } else if (response.changePassword.status ==
                        Status.COMPLETED) {
                      if (response.changePassword.data?.customerData != null) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (Route<dynamic> route) => false);
                        });
                      } else {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          _showErrorDialog(
                              response.changePassword.message.toString(),
                              'Cancel',
                              Icons.error_outline);
                        });
                      }
                    }
                    return FmSubmitButton(
                        text: 'Update',
                        onPressed: () {
                          print('Submit button');
                          if (_formKey.currentState!.validate()) {
                            _showDialog(
                                context,
                                'You will be logged out and required to log in with your new password. Do you wish to continue?',
                                'Continue',
                                Icons.error_outline,
                                'Cancel');
                          }
                        },
                        showOutlinedButton: false);
                  })
                ],
              ),
            ),
          )),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Change Password ',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  _showDialog(BuildContext context, String title, String buttonText,
      IconData icon, String secondButtonText) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              secondButtonText: secondButtonText,
              secondButtonCallback: () {
                Navigator.pop(dialogContext);
              },
              buttonText: buttonText,
              voidCallback: () async {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  final Map<String, dynamic> data = new Map<String, dynamic>();
                  data['oldPassword'] = AesUtils.aesEncryptedText(_currentPasswordController.text);
                  data['password'] = AesUtils.aesEncryptedText(_newPasswordController.text);
                  data['resetPurpose'] = 'Change';
                  String email = dialogContext
                          .read<LoginProvider>()
                          .authentication
                          .data
                          ?.customerData
                          ?.email ??
                      '';
                  context
                      .read<ChangePasswordProvider>()
                      .sendChangePassword(email, '', data);
                });
                Navigator.pop(dialogContext);
              });
        });
  }

  _showErrorDialog(String title, String buttonText, IconData icon) {
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
