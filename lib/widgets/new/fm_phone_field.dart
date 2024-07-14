import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm_phone_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FmPhoneFields extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final int maxLines;
  final List<Country> country;
  final Country initialValue;
  final Function(Country) selectedCountry;
  late bool isLoginPage;
  late bool fillColor;

  FmPhoneFields(
      {required this.title,
      required this.textEditingController,
      required this.textInputAction,
      required this.autoFocus,
      required this.maxLines,
      required this.country,
      required this.initialValue,
      required this.selectedCountry,
      this.isLoginPage = false,
      this.fillColor = false});

  @override
  _FmPhoneFieldsState createState() => _FmPhoneFieldsState();
}

class _FmPhoneFieldsState extends State<FmPhoneFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(context),
        SizedBox(
          height: SizeConfig.resizeHeight(1),
        ),
        TextFormField(
          controller: widget.textEditingController,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.disabled,
          autofocus: false,
          maxLines: widget.maxLines,
          maxLength: widget.initialValue.length,
          decoration: buildInputDecoration(context),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Required';
            } else if (value.length !=
                int.parse(widget.initialValue.length.toString())) {
              return 'Invalid Phone';
            }
          },
        ),
      ],
    );
  }

  Row label(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: SizeConfig.resizeFont(9.24),
                ),
          ),
        ),
        Visibility(
          visible: widget.isLoginPage,
          child: Consumer<LoginProvider>(builder: (context, response, child) {
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
                    color: Theme.of(context).appBarTheme.foregroundColor),
              ),
            );
          }),
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
        counterText: '',
        errorMaxLines: 3,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        isDense: true,
        filled: widget.fillColor,
        fillColor:
            Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.09),
        hintStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        labelStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        prefixIcon: InkWell(
          onTap: () {
            _phoneCodeBottomSheet();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    'flags/${widget.initialValue.code?.toLowerCase()}.png',
                    width: 30),
                SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        prefixText: '+${widget.initialValue.dialCode} ',
        prefixStyle: TextStyle(fontSize: 16));
  }

  void _phoneCodeBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return FmPhoneBottomSheet(
              country: widget.country,
              initialValue: widget.initialValue,
              selectedCountry: widget.selectedCountry);
        });
  }
}
