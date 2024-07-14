import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'add_new_recipient.dart';

class Recipients extends StatefulWidget {
  @override
  _RecipientsState createState() => _RecipientsState();
}

class _RecipientsState extends State<Recipients> {
  late FToast _fToast;
  late RecipientProvider _recipientProvider;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
    _recipientProvider = Provider.of<RecipientProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _recipientProvider.getAllRecipients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 4,
          ),
          Consumer<RecipientProvider>(
            builder: (context, response, child) {
              if (response.recipients.status == Status.COMPLETED) {
                return _recipientList(response.recipients.data!);
              } else if (response.recipients.status == Status.ERROR) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  // _showToast(response.recipients.message, Icons.error);
                  _showSnackBar(response.recipients.message ?? 'Something went wrong');
                  response.recipient.status = Status.INITIAL;
                });
                return Container();
              } else if (response.recipients.status == Status.LOADING) {
                return FmHomeScreenLoader();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _recipientList(ListBeneficiary recipient) {
    return recipient.beneficiaries!.length > 0
        ? Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.resizeWidth(4.11)),
              child: RefreshIndicator(
                onRefresh: () {
                  return _recipientProvider.getAllRecipients();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _recipientHeader(),
                      Divider(
                        height: 1,
                        color: FiatColors.fiatGrey,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: recipient.beneficiaries!.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return _listTile(recipient.beneficiaries![index]);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                Image.asset(
                  'assets/no_recipient.png',
                  width: 200,
                ),
                Text(
                  'You haven’t added any recipients yet.',
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  padding: EdgeInsets.only(top: 24),
                  width: SizeConfig.resizeWidth(30), // 88,
                  child: FmSubmitButton(
                    text: 'Add recipient',
                    onPressed: () {
                      goToNewScreen(AddNewRecipient(
                        recipient: null,
                      ));
                    },
                    showOutlinedButton: false,
                  ),
                ),
                Spacer(),
              ],
            ),
          );
  }

  Widget _recipientHeader() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 2.0),
      leading: Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text("Name",
                style: TextStyle(
                    fontSize: SizeConfig.resizeFont(9.24),
                    fontWeight: FontWeight.w600)),
          )),
      title: Text("Email",
          style: TextStyle(
              fontSize: SizeConfig.resizeFont(9.24),
              fontWeight: FontWeight.w600)),
      trailing: InkWell(
          onTap: () {
            goToNewScreen(AddNewRecipient(
              recipient: null,
            ));
          },
          child: Text(
            "Add new recipient",
            style: TextStyle(
                    fontSize: SizeConfig.resizeFont(9.24),
                    fontWeight: FontWeight.w600)
                .copyWith(color: Theme.of(context).accentColor),
          )),
    );
  }

  Widget _listTile(Beneficiaries recipient) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '${recipient.firstName} ${recipient.lastName}',
                style: TextStyle(
                    fontSize: SizeConfig.resizeFont(9.24),
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(2),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  '${recipient.email}',
                  style: TextStyle(
                      fontSize: SizeConfig.resizeFont(9.24),
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                )),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {
                  goToNewScreen(AddNewRecipient(
                    recipient: recipient,
                  ));
                },
                child: SizedBox(
                    height: SizeConfig.resizeWidth(4.11),
                    width: SizeConfig.resizeWidth(4.11),
                    child: Image.asset(
                      'assets/edit.png',
                    ))),
            SizedBox(
              width: SizeConfig.resizeWidth(6.61),
            ),
            Consumer<RecipientProvider>(builder: (context,response,child){
              if(response.paymentChannel.status == Status.LOADING){
                return Container(width: 15 , height: 15,child: CircularProgressIndicator(strokeWidth: 2,));
              } else if (response.paymentChannel.status == Status.ERROR) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _showSnackBar(response.paymentChannel.message ?? 'Something went wrong');
                 response.paymentChannel.status = Status.INITIAL;
                });
              }
              return InkWell(
                  onTap: () async {
                    _showDeleteDialogDialog(context, recipient);
                  },
                  child: SizedBox(
                      height: SizeConfig.resizeWidth(4.11),
                      width: SizeConfig.resizeWidth(4.11),
                      child: Image.asset(
                        'assets/delete.png',
                      )));
            })

          ],
        ));
  }

  _showDeleteDialogDialog(BuildContext _context, Beneficiaries recipient) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
              iconData: Icons.info,
              title: 'Delete',
              buttonText: 'Continue',
              secondButtonText: 'Cancel',
              secondButtonCallback: () => Navigator.pop(context, true),
              message:
                  'Are you sure you want to delete ${recipient.firstName} ${recipient.lastName} from your list of recipients?',
              voidCallback: () async {
                try {
                  if (recipient.channel!.isNotEmpty)
                     // _recipientProvider.deleteChannel(
                     //    recipient.id!, recipient.channel!.first.id!);

                   _recipientProvider.deleteRecipient(recipient.id!);
                } catch (exp) {
                  print(exp);
                } finally {
                  Navigator.of(context).pop();
                }
              });
        });
  }

  goToNewScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  _showToast(String? msg, IconData icon) {
    _fToast.showToast(
      child: FmToast(
        message: msg,
        icon: icon,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
