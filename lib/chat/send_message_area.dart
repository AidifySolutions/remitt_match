import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessageArea extends StatefulWidget {
  @override
  _SendMessageAreaState createState() => _SendMessageAreaState();
}

class _SendMessageAreaState extends State<SendMessageArea> {
  late ChatProvider _chatProvider;
  late TextEditingController _message;

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 0,
              color: FiatColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextFormField(
                controller: _message,
                textAlignVertical: TextAlignVertical.center,
                maxLines: 5,
                minLines: 1,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: "Type a message",
                  suffixIcon: _sendBtn(context),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendBtn(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
      onTap: () {
        if(_message.text.trim() != '') {
          _chatProvider.sendMessage(_message.text.toString(),
              _chatProvider.roomId, MessageType.Content, null, null, null);
          _message.clear();
        }
      },
      child: Icon(
        Icons.send,
        size: SizeConfig.resizeWidth(5),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
