import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FmInputFields extends StatefulWidget {
  final String title;
  final bool obscureText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String) onValidation;
  final bool autoFocus;
  final int maxLines;
  late bool isRegistrationPage;
  late bool isLoginUsernameField;
  late bool fillColor;
  late bool isMandatory;
  late bool showObscureTextVisiblityIcon;

  FmInputFields(
      {required this.title,
      required this.obscureText,
      required this.textEditingController,
      required this.textInputType,
      required this.textInputAction,
      required this.onValidation,
      required this.autoFocus,
      required this.maxLines,
      this.isRegistrationPage = false,
      this.isLoginUsernameField = false,
      this.fillColor = false,
      this.isMandatory = false,
      this.showObscureTextVisiblityIcon = true});

  @override
  _FmInputFieldsState createState() => _FmInputFieldsState();
}

class _FmInputFieldsState extends State<FmInputFields> {
  bool _passwordVisibility = false;
  IconData? _suffixIcon;
  Color? _suffixIconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(context),
        SizedBox(
          height: SizeConfig.resizeHeight(1),
        ),
        buildTextFormField(),
      ],
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      controller: widget.textEditingController,
      textAlign: TextAlign.start,
      obscureText: widget.obscureText && !_passwordVisibility,
      textInputAction: widget.textInputAction,
      autovalidateMode: AutovalidateMode.disabled,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      decoration: buildInputDecoration(),
      keyboardType: widget.textInputType,
      validator: (value) => widget.onValidation(value!),
    );
  }

  Row label(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: widget.title,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: SizeConfig.resizeFont(9.24),
                  ),
              children: <TextSpan>[
                TextSpan(text: widget.isMandatory ? '*' : '')
              ]
            ),
          ),
        ),
        widget.obscureText && widget.isRegistrationPage
            ? Text(
                'Min. 8 Characters',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: SizeConfig.resizeFont(5.61),
                    ),
              )
            : widget.isLoginUsernameField
                ? Consumer<LoginProvider>(builder: (context, response, child) {
                    return InkWell(
                      onTap: () {
                        response.setLogInWithMobile(!response.logInWithMobile);
                      },
                      child: Text(
                        response.logInWithMobile
                            ? 'Log in via Name'
                            : 'Log in via Phone No.',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: SizeConfig.resizeFont(8.42),
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor),
                      ),
                    );
                  })
                : Container(),
      ],
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorMaxLines: 3,
      filled: widget.fillColor,
      fillColor:
          Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.09),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      suffixIcon: widget.showObscureTextVisiblityIcon ? widget.obscureText && !_passwordVisibility
          ? _passwordToggle(Icons.visibility)
          : widget.obscureText && _passwordVisibility
              ? _passwordToggle(Icons.visibility_off)
              : null : null,
    ); 
  }

  _passwordToggle(IconData icon) {
    return InkWell(
        onTap: () {
          setState(() {
            _passwordVisibility = !_passwordVisibility;
          });
        },
        child: Icon(
          icon,
          color: Colors.black,
        ));
  }
}
