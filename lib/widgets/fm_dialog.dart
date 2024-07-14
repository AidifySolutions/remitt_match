import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';

class FmDialogWidget extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback voidCallback;
  final String? secondButtonText;
  final VoidCallback? secondButtonCallback;
  final String? titleHeading;
  FmDialogWidget(
      {
      required this.title,
      required this.message,
      required this.buttonText,
      required this.voidCallback,
      this.iconData,
      this.secondButtonText,
      this.secondButtonCallback,
      this.titleHeading,
      });

  @override
  _FmDialogWidgetState createState() => _FmDialogWidgetState();
}

class _FmDialogWidgetState extends State<FmDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: SizeConfig.resizeHeight(9.35)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible:
                      widget.titleHeading != null && widget.titleHeading != '',
                  child: Text(
                    widget.titleHeading ?? '',
                    style: TextStyle(
                      color: FiatColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.resizeFont(11.54),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: widget.iconData != null,
                  child: Icon(
                    widget.iconData,
                    size: SizeConfig.resizeWidth(14),
                    color: Theme.of(context).accentColor,
                  ),
                ),
                if (widget.title.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.resizeWidth(8),
                        right: SizeConfig.resizeWidth(8),
                        top: SizeConfig.resizeWidth(5.61),
                        bottom: SizeConfig.resizeHeight(5.61)),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.resizeFont(11.22),
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (widget.message.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.resizeWidth(8),
                        right: SizeConfig.resizeWidth(8),
                        top: SizeConfig.resizeWidth(5.61),
                        bottom: SizeConfig.resizeHeight(5.61)),
                    child: Text(
                      widget.message,
                      style: TextStyle(
                          fontSize: SizeConfig.resizeFont(11.22),
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.resizeWidth(20.5),
                    right: SizeConfig.resizeWidth(20.5),
                  ),
                  child: FmSubmitButton(
                      text: widget.buttonText,
                      onPressed: () => widget.voidCallback(),
                      showOutlinedButton: false),
                ),
                buildContainer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildContainer() {
    if (widget.secondButtonText != null) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: SizeConfig.resizeHeight(4.11),
            bottom: SizeConfig.resizeWidth(9.2)),
        child: InkWell(
          child: Text(
            widget.secondButtonText ?? '',
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(9.24),
                fontWeight: FontWeight.bold),
          ),
          onTap: () => widget.secondButtonCallback!(),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.resizeHeight(4.11),
            bottom: SizeConfig.resizeWidth(9.2)),
      );
    }
  }
}
