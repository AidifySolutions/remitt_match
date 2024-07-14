import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/identity_verification/liveness_check.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DocumentUpload extends StatefulWidget {
  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  XFile? _frontPage;
  XFile? _backPage;
  final picker = ImagePicker();
  late bool _isLoading;
  late CustomerRepository _customerRepository;
  late CustomerData? _customer;
  late bool _showFrontIdCardErrorMessage;
  late bool _showBackIdCardErrorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _customerRepository = CustomerRepository(context);
    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    _showFrontIdCardErrorMessage = false;
    _showBackIdCardErrorMessage = false;
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
              uploadCard(
                  'assets/card_front.png', 'Upload front of ID card', true),
              SizedBox(
                height: SizeConfig.resizeHeight(1.41),
              ),
              Visibility(
                  visible: _showFrontIdCardErrorMessage,
                  child: buildErrorMessage()),
              SizedBox(
                height: SizeConfig.resizeHeight(3.74),
              ),
              uploadCard(
                  'assets/card_back.png', 'Upload back of ID card', false),
              SizedBox(
                height: 8,
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    'File should not exceed 2 MB',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: SizeConfig.resizeFont(8.42)),
                  ),
                ),
                Visibility(
                    visible: _showBackIdCardErrorMessage,
                    child: buildErrorMessage()),
              ]),
              Expanded(child: Container()),
              _isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : FmSubmitButton(
                      text: 'Submit',
                      onPressed: () {
                        if (_frontPage != null && _backPage != null) {
                          _uploadDocument();
                        } else {
                          _showDialog(
                              'Please upload document', Icons.error, 'Close');
                        }
                      },
                      showOutlinedButton: false),
              SizedBox(
                height: SizeConfig.resizeHeight(9.35),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text buildErrorMessage() {
    return Text('File exceeds 2MB',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.resizeFont(8.42),
        ),
        textAlign: TextAlign.end);
  }

  Widget uploadCard(String asset, String text, bool isFrontPage) {
    return InkWell(
      onTap: () {
        _modalBottomSheetMenu(isFrontPage: isFrontPage);
      },
      child: Container(
        height: SizeConfig.resizeHeight(41.13),
        child: Stack(
          children: [
            _frontPage != null && isFrontPage
                ? setImage(_frontPage)
                : _backPage != null && !isFrontPage
                    ? setImage(_backPage)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.grey.shade300,
                        ),
                      ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  asset,
                  width: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                height: SizeConfig.resizeHeight(9.35),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.resizeFont(8.42),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setImage(XFile? file) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image.file(
          File(file!.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _modalBottomSheetMenu({required bool isFrontPage}) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      browseImage(isFrontPage, ImageSource.camera);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text(
                      'Take Photo',
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      browseImage(isFrontPage, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.upload),
                    title: Text(
                      'Upload Photo',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future browseImage(bool isFrontPage, ImageSource src) async {
    final pickedFile =
        await picker.pickImage(source: src, maxWidth: 800, maxHeight: 600);
    if (pickedFile != null && isFrontPage) {
      print('Name of the file: ${pickedFile.path}');
      _frontPage = pickedFile;
    } else if (pickedFile != null && !isFrontPage) {
      _backPage = pickedFile;
    }
    setState(() {});
  }

  Future<void> _uploadDocument() async {
    try {
      final frontPageBytes = await _frontPage?.readAsBytes();
      final backPageBytes = await _backPage?.readAsBytes();

      final frontPageSizeInKb = frontPageBytes!.lengthInBytes / 1024;
      final frontPageSizeInMb = frontPageSizeInKb / 1024;

      final backPageSizeInKb = backPageBytes!.lengthInBytes / 1024;
      final backPageSizeInMb = backPageSizeInKb / 1024;

      if (frontPageSizeInMb > 2 || backPageSizeInMb > 2) {
        setState(() {
          _showFrontIdCardErrorMessage = frontPageSizeInMb > 2;
          _showBackIdCardErrorMessage = backPageSizeInMb > 2;
        });
      } else {
        setLoader(true);
        await _customerRepository.uploadDocument(
            base64.encode(frontPageBytes),
            0,
            '${_customer?.id.toString()}-${Helper.getEnumValue(DocumentType.FrontPhotoId.toString())}',
            _customer?.id.toString());

        await _customerRepository.uploadDocument(
            base64.encode(backPageBytes),
            1,
            '${_customer?.id.toString()}-${Helper.getEnumValue(DocumentType.BackPhotoId.toString())}',
            _customer?.id.toString());

        _frontPage = null;
        _backPage = null;

        setLoader(false);
        _showDialog('Upload Successful', Icons.error, 'Close',
            gotoNextScreen: true);
      }
    } catch (e) {
      setLoader(false);
      _showDialog(e.toString(), Icons.error, 'Close');
    }
  }

  setLoader(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  _showDialog(String title, IconData icon, String buttonText,
      {bool gotoNextScreen = false}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                Navigator.pop(context);
                if (gotoNextScreen) {
                  _gotoNewScreen();
                }
              });
        });
  }

  _gotoNewScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LivenessCheck()),
    );
    Navigator.pop(context);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Document Upload'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Padding buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.resizeHeight(1.87)),
      child: Text(
        'Upload government-issued ID Card',
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: SizeConfig.resizeFont(8.42),
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
