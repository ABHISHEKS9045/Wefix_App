import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../QRCode/scanner.dart';
import '../../common/button.dart';
import '../../common/const.dart';
import '../../common/textfield.dart';
import '../PDF/addVendorQuoteScreen.dart';
import 'AllProduct/product.dart';
import 'AllProduct/vendorlist.dart';



Widget qrbtn() {
  return Button(
      buttonName: "QR Code",
      btnHeight: 50.0,
      btnWidth: 155.0,
      borderRadius: BorderRadius.circular(18.0),
      onPressed: () {
        Get.to(() => AddProductScanQRPage());
      });
}

Widget productbtn() {
  return Button(
      buttonName: "All product",
      btnHeight: 50.0,
      btnWidth: 143.0,
      borderRadius: BorderRadius.circular(18.0),
      onPressed: () {
        Get.to(() => ProductPage(
              isForSearch: false,
              searchText: '',
            ));
      });
}

Widget schedulecall() {
  return Button(
      buttonName: "Schedule Call",
      btnHeight: 50.0,
      btnWidth: 143.0,
      borderRadius: BorderRadius.circular(10.0),
      onPressed: () {
        Get.to(
          () => AddVendorQuoteScreen(),
        );
      });
}

Widget Qrcode(model) {
  return Container(
    margin: EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    padding: EdgeInsets.only(right: 40, left: 20, top: 20, bottom: 20),
    decoration: BoxDecoration(color: HexColor("#6759FF"), borderRadius: BorderRadius.all(Radius.circular(15.0))),
    child: InkWell(
      onTap: () {
        Get.to(() => AddProductScanQRPage());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          sizedboxwidth(5.0),
          Text("QR code", style: TextStyle(fontSize: 16, fontWeight: fontWeight600, color: Colors.white)),
        ],
      ),
    ),
  );
}


