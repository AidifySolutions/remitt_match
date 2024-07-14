import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/widgets/fm_phone_bottomsheet.dart';
import 'package:flutter/material.dart';

class FmPhoneFields extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final int maxLines;
  final List<Country> country;
  final Country initialValue;
  final Function(Country) selectedCountry;
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
      this.fillColor = false});

  @override
  _FmPhoneFieldsState createState() => _FmPhoneFieldsState();
}

class _FmPhoneFieldsState extends State<FmPhoneFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.disabled,
      autofocus: false,
      maxLines: 1,
      maxLength: widget.maxLines,
      decoration: InputDecoration(
          filled: widget.fillColor,
          fillColor:
              Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.09),
          counterText: '',
          errorMaxLines: 3,
          isDense: true,
          labelText: 'Phone Number',
          hintText: widget.initialValue.sampleNumber,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
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
          prefixStyle: TextStyle(fontSize: 16)),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else if (value.length !=
            int.parse(widget.initialValue.length.toString())) {
          return 'Invalid Phone';
        }
      },
    );
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
