import 'dart:io';

import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LivenessCheck extends StatefulWidget {
  @override
  _LivenessCheckState createState() => _LivenessCheckState();
}

class _LivenessCheckState extends State<LivenessCheck> {
  static const platform = const MethodChannel('com.fiatmatch.android/liveness');
  bool _isLoading = false;
  late CustomerRepository _customerRepository;
  late CustomerData? _customer;
  late bool isAlive;

  @override
  void initState() {
    super.initState();
    _customerRepository = CustomerRepository(context);
    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              left: SizeConfig.resizeWidth(9.35),
              right: SizeConfig.resizeWidth(9.35),
              bottom: SizeConfig.resizeWidth(9.35)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDescription(),
              SizedBox(
                height: SizeConfig.resizeHeight(3.74),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, bottom: 22, top: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: iconTile(
                                'assets/hat.png', 'Avoid wearing\nhats', true),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: iconTile('assets/glasses.png',
                                'Avoid wearing\nglasses', true),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 22, bottom: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: iconTile('assets/facial_filter.png',
                                'Avoid using\nfilters', true),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: iconTile('assets/light.png',
                                'Use enough\nlightening', false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              _isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : FmSubmitButton(
                      text: 'Begin Verification',
                      onPressed: () {
                        _launchSDK();
                      },
                      showOutlinedButton: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconTile(String asset, String title, bool showCrossIcon) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              asset,
              height: 40,
            ),
            Visibility(
                visible: showCrossIcon,
                child: Positioned(
                    right: -10, child: Image.asset('assets/cross.png'))),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: SizeConfig.resizeFont(8.42),
          ),
        ),
      ],
    );
  }

  Future<void> _launchSDK() async {
    if (await _checkPermissions()) {
      try {
        final String result = await platform.invokeMethod('launchSDK');
        if (result.isNotEmpty) {
          String statusCode = result.split('|||').first.toString();
          String selfieData = result.split('|||').last;
          await _handleResponse(statusCode, selfieData);
        } else {
          _showDialog('Please try again', Icons.error, 'Retry', retry: true);
        }
      } on PlatformException catch (e) {
        _showDialog(e.toString(), Icons.error, 'Retry', retry: true);
      }
    } else {
      _showDialog('Camera Permission Required', Icons.error, 'Retry',
          retry: true);
    }
  }

  _handleResponse(String statusCode, String image) async {
    if (statusCode == '101') {
      await _uploadDocument(image);
      await _updateLiveness(true);
    } else if (statusCode == '102') {
      _showDialog('Liveness Failed', Icons.error, 'Retry', retry: true);
    } else if (statusCode == '103') {
      _showDialog('Failed to complete the challenge within time limit',
          Icons.error, 'Retry',
          retry: true);
    } else if (statusCode == '104') {
      _showDialog(
          'Face lost during liveness verification', Icons.error, 'Retry',
          retry: true);
    } else {
      _showDialog('Please try again', Icons.error, 'Retry', retry: true);
    }
  }

  Future<void> _uploadDocument(String document) async {
    try {
      setLoader(true);
      await _customerRepository.uploadDocument(
          document,
          2,
          '${_customer?.id.toString()}-${Helper.getEnumValue(DocumentType.Selfie.toString())}',
          _customer?.id.toString());
      setLoader(false);
    } catch (e) {
      setLoader(false);
      _showDialog(e.toString(), Icons.error, 'Close');
    }
  }

  Future<void> _updateLiveness(bool isAlive) async {
    try {
      setLoader(true);
      await _customerRepository.updateLiveness(
          isAlive, _customer?.id.toString());
      setLoader(false);
      _showDialog('Liveness Completed', Icons.check_circle, 'Continue',
          goToNewScreen: true);
    } catch (e) {
      setLoader(false);
      _showDialog(e.toString(), Icons.error, 'Close');
    }
  }

  Future<bool> _checkPermissions() async {
    //because it is define in ios info.plist
    if(Platform.isIOS){
      return true;
    }
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus == PermissionStatus.granted ? true : false;
    } else {
      return true;
    }
  }

  setLoader(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  _showSuccessDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: Icons.check_circle,
              title: 'Liveness Completed',
              message: 'Your verifications is being submitted for review',
              buttonText: 'Continue',
              voidCallback: () async {});
        });
  }

  _showDialog(String title, IconData icon, String buttonText,
      {bool retry = false, bool goToNewScreen = false}) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                if (retry) {
                  _launchSDK();
                } else if (goToNewScreen) {
                  Navigator.pop(dialogContext);
                }
                Navigator.pop(context);
              });
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Facial Verification'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Padding buildDescription() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.resizeHeight(3.74)),
      child: Text(
        'Please consider the following before beginning the verification.',
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.resizeFont(8.42),
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
