import 'package:flutter/material.dart';

class FmDropdown extends StatefulWidget {
  final TextEditingController textEditingController;
  final VoidCallback onTap;
  final String label;
  final Function(String) onValidation;

  FmDropdown(
      {required this.textEditingController,
      required this.onTap,
      required this.label,
      required this.onValidation});

  @override
  _FmDropdownState createState() => _FmDropdownState();
}

class _FmDropdownState extends State<FmDropdown> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      onTap: () => widget.onTap(),
      textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.disabled,
      showCursor: true,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        errorMaxLines: 3,
        isDense: true,
        labelText: widget.label,
        suffixIcon: Icon(Icons.arrow_drop_down),
        hintStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        labelStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      validator: (value) => widget.onValidation(value!),
    );
  }
}
