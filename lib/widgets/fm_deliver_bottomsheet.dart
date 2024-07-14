import 'package:fiat_match/models/channel_detail.dart';
import 'package:flutter/material.dart';

class FmDeliveryBottomSheetItem extends StatefulWidget {
  final ChannelDetails channel;

  FmDeliveryBottomSheetItem({required this.channel});

  @override
  _FmDeliveryBottomSheetState createState() => _FmDeliveryBottomSheetState();
}

class _FmDeliveryBottomSheetState extends State<FmDeliveryBottomSheetItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Material(
          child: ListTile(
            title: Text(widget.channel.channelType!),
          )),
    );
  }
}
