import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:service/QRCode/rrscan.dart';

class AddProductScanQRPage extends StatefulWidget {
  const AddProductScanQRPage({Key? key}) : super(key: key);

  @override
  _AddProductScanQRPageState createState() => _AddProductScanQRPageState();
}

class _AddProductScanQRPageState extends State<AddProductScanQRPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String TAG = "_AddProductScanQRPageState";
  bool showLoader = false;
  String token = "";
  String scannedId = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan QR Code",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade500,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: _buildQrView(context),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 300.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      formatsAllowed: const [BarcodeFormat.qrcode],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) {
      debugPrint(TAG + " _onQRViewCreated scanData code ======> ${scanData.code}");
      if (scanData.code != null && scanData.code.toString() != "") {
        setState(() {
          scannedId = scanData.code.toString();
          result = scanData;
          if (Platform.isAndroid) {
            this.controller!.pauseCamera();
          }
        });
        checkQRCode(scanData.code.toString());
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void checkQRCode(String qrId) {
    setState(() {
      showLoader = true;
    });
  }
}
