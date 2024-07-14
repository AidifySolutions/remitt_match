import 'package:flutter/material.dart';

class FmInputFields extends StatefulWidget {
  final String title;
  final String hint;
  final bool obscureText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String) onValidation;
  final bool autoFocus;
  final int maxLines;
  final bool isEditable;

  FmInputFields(
      {required this.title,
      required this.hint,
      required this.obscureText,
      required this.textEditingController,
      required this.textInputType,
      required this.textInputAction,
      required this.onValidation,
      required this.autoFocus,
      required this.maxLines,
      this.isEditable = true});

  @override
  _FmInputFieldsState createState() => _FmInputFieldsState();
}

class _FmInputFieldsState extends State<FmInputFields> {
  bool _passwordVisibility = false;
  IconData? _suffixIcon;
  Color? _suffixIconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(widget.hint),
      controller: widget.textEditingController,
      textAlign: TextAlign.start,
      obscureText: widget.obscureText && !_passwordVisibility,
      textInputAction: widget.textInputAction,
      autovalidateMode: AutovalidateMode.disabled,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      enabled: widget.isEditable,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        errorMaxLines: 3,
        isDense: true,
        labelText: widget.title,
        hintText: widget.hint,
        hintStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        labelStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        suffixIcon: widget.obscureText && !_passwordVisibility
            ? _passwordToggle(Icons.visibility_off)
            : widget.obscureText && _passwordVisibility
                ? _passwordToggle(Icons.visibility)
                : Icon(_suffixIcon, color: _suffixIconColor),
      ),
      keyboardType: widget.textInputType,
      validator: (value) => widget.onValidation(value!),
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
          color: Colors.grey,
        ));
  }
}
