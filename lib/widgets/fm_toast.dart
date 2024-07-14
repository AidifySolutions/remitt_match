import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FmToast extends StatefulWidget {
  final String? message;
  final IconData? icon;

  FmToast({required this.message, required this.icon});

  @override
  _FmToastState createState() => _FmToastState();
}

class _FmToastState extends State<FmToast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              widget.message.toString(),
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}


