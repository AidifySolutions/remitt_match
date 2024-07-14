import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/document_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'document_upload.dart';
import 'liveness_check.dart';

class IdentityVerification extends StatefulWidget {
  @override
  _IdentityVerificationState createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerification> {
  late CustomerData? _customer;
  late DocumentProvider _documentProvider;

  @override
  void initState() {
    super.initState();
    _documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    _documentProvider.reset();
    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_customer?.livenessStatus?.status ==
          Helper.getEnumValue(livenessStatus.Incomplete.toString())) {
        _documentProvider.getDocuments(_customer?.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(9.35)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDescription(),
              buildIdentityStatus(),
              SizedBox(
                height: SizeConfig.resizeHeight(2.34),
              ),
              Consumer<DocumentProvider>(builder: (context, response, child) {
                if (response.document.status == Status.LOADING) {
                  return Column(
                    children: [
                      FmHomeScreenLoader(),
                      FmHomeScreenLoader(),
                    ],
                  );
                } else if (response.document.status == Status.COMPLETED) {
                  bool? _isBackPhotoId = (response.document.data?.any(
                      (element) =>
                          element.type ==
                          documentTypeToInt(DocumentType.BackPhotoId)));
                  bool? _isFrontPhotoId = (response.document.data?.any(
                      (element) =>
                          element.type ==
                          documentTypeToInt(DocumentType.FrontPhotoId)));

                  return screenLayout(_isFrontPhotoId! && _isBackPhotoId!);
                } else {
                  return screenLayout(false);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Expanded screenLayout(bool isDocumentUploaded) {
    return Expanded(
      child: Column(
        children: [
          buildVerificationCard('Upload Photo ID',
              'Upload a photo of the front and back pages of your government issued ID card.'),
          SizedBox(
            height: SizeConfig.resizeHeight(3.74),
          ),
          buildVerificationCard('Selfie with liveness check',
              'Perform random facial challenges to verify your identity.'),
          Expanded(child: SizedBox()),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.resizeHeight(9.35)),
            child: _customer?.livenessStatus?.status ==
                        Helper.getEnumValue(
                            livenessStatus.Incomplete.toString()) ||
                    _customer?.livenessStatus?.status ==
                        Helper.getEnumValue(livenessStatus.Rejected.toString())
                ? FmSubmitButton(
                    text: 'Begin Verification',
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => isDocumentUploaded
                                ? LivenessCheck()
                                : DocumentUpload()),
                      );
                      Navigator.pop(context);
                    },
                    showOutlinedButton: false)
                : Container(),
          ),
        ],
      ),
    );
  }

  Card buildVerificationCard(String title, String description) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(8.42),
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(2.34),
            ),
            Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(8.42),
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildIdentityStatus() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.resizeHeight(2.34)),
      child: Row(
        children: [
          Text(
            'Status: ',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(8.42),
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            '${_customer?.livenessStatus?.status}',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: getStatusColor(),
                fontSize: SizeConfig.resizeFont(8.42),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Padding buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.resizeHeight(3.74)),
      child: Text(
        'The following documents need to be submitted for your identity verification.',
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.resizeFont(8.42),
            fontWeight: FontWeight.w400),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Identity Verification'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Color getStatusColor() {
    if (_customer?.livenessStatus?.status ==
        Helper.getEnumValue(livenessStatus.Verified.toString())) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
