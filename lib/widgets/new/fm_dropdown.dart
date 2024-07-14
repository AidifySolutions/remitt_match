import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';

class FmDropdown extends StatefulWidget {
  final String title;
  final TextEditingController textEditingController;
  final Function(String) onValidation;
  final int maxLines;
  final bool fillColor;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final Color trailingIconColor;

  FmDropdown(
      {required this.title,
      required this.textEditingController,
      required this.onValidation,
      required this.maxLines,
      required this.onTap,
      this.trailingIcon = Icons.keyboard_arrow_down_outlined,
      this.trailingIconColor = Colors.black,
      this.fillColor = false});

  @override
  _FmDropdownState createState() => _FmDropdownState();
}

class _FmDropdownState extends State<FmDropdown> {
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
      autovalidateMode: AutovalidateMode.disabled,
      autofocus: false,
      readOnly: true,
      maxLines: widget.maxLines,
      decoration: buildInputDecoration(),
      validator: (value) => widget.onValidation(value!),
      showCursor: false,
      onTap: () => widget.onTap(),
    );
  }

  Text label(BuildContext context) {
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: SizeConfig.resizeFont(9.24),
          ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorMaxLines: 3,
      filled: widget.fillColor,
      fillColor: Theme.of(context).primaryColor,
      isDense: true,
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 0),
      suffixIconConstraints: BoxConstraints(minHeight: 18, minWidth: 18),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 3),
        child: Icon(
          widget.trailingIcon,
          size: 24,
          color: widget.trailingIconColor,
        ),
      ),
    );
  }
}
