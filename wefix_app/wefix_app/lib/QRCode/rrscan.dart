import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../BottamNavigation/dashboard/AllProduct/productlist.dart';
import '../common/const.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _buildQrView(context),
          ),
          Container(
            child: Center(
              child: (result != null)
                  ? InkWell(
                      onTap: () {
                        debugPrint("result ==============> ${result?.code.toString()}");
                        if (result != null && result!.code != null) {
                          String id = result!.code!.replaceAll("http://134.209.229.112/wefix_stagging/product-details?id=", "");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                productId: id,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        color: HexColor("#6759FF"),
                        alignment: Alignment.center,
                        height: 60,
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ))
                  : Container(alignment: Alignment.center, height: 60, child: Text('Scan a code')),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 350) ? 300.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) {
      if (scanData.code != null && scanData.code.toString() != "") {
        setState(() {
          result = scanData;
          result = scanData;
          if (Platform.isAndroid) {
            this.controller!.pauseCamera();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
