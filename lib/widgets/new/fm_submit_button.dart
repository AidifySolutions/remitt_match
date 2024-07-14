import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:flutter/material.dart';

class FmSubmitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showOutlinedButton;
  final bool showWhiteBorder;

  FmSubmitButton(
      {required this.text,
      required this.onPressed,
      required this.showOutlinedButton,
      this.showWhiteBorder = false});

  @override
  _FmSubmitButtonState createState() => _FmSubmitButtonState();
}

class _FmSubmitButtonState extends State<FmSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.onPressed();
      },
      child: Text(
        widget.text,
      ),
      style: TextButton.styleFrom(
        side: BorderSide(
            color: widget.showWhiteBorder
                ? FiatColors.white
                : Theme.of(context).colorScheme.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: TextStyle(
            fontSize: SizeConfig.resizeFont(9.24), fontWeight: FontWeight.w500),
        primary: widget.showOutlinedButton
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor,
        backgroundColor: widget.showOutlinedButton
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondary,
        minimumSize: Size(
          double.infinity,
          SizeConfig.resizeHeight(11.22),
        ),
      ),
    );
  }
}
