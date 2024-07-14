import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../identity_verification/liveness_check.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  late CustomerData? _customer;
  late FToast _fToast;

  @override
  void initState() {
    super.initState();
    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    _fToast = FToast();
    _fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: _buildQrView(context),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 230.0
        : 380.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).accentColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (_customer?.id.toString() == scanData.code) {
        controller.pauseCamera();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LivenessCheck()),
        );
      } else {
        controller.pauseCamera();
        _showDialog(context);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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

  _showDialog(BuildContext screenContext) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
              buttonText: 'Exit',
              iconData: Icons.error,
              title: 'Invalid QR code',
              message:
                  'Please login with the same account as on fiat match portal',
              voidCallback: () {
                Navigator.pop(context);
                Navigator.pop(screenContext);
              });
        });
  }
}
