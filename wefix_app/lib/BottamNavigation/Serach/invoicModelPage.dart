import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class invoicModelPage extends ChangeNotifier {

  String TAG = "invoicModelPage";

  List _invoicDetails = [];
  List get invoicDetails => _invoicDetails;

  List invoicDetailsclicks = [];


  String orderId = '';
  String vendorName = '';
  String address = '';
  String phone = '';
  String date = '';
  String status = '';
  String image = '';
  String productname = '';
  String? qty;
  String? price;
  String? total;
  String? SubTotal;
  String? trackcharge;
  String? labourcharge;
  String? extracharge;
  String? tax;
  String? orderamount;


  bool _is_loding = false;
  bool get is_loding => _is_loding;
  showLoader() {
    _is_loding = true;
    notifyListeners();
  }

  hideLoader() {
    _is_loding = false;
    notifyListeners();
  }

  InvoiceListing(context) async {
    showLoader();
    // toggleshemmerShow();

    Dio dio = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);

    try {
      var response = await dio.get("http://209.97.156.170:7071/owner/get_invoice?id=$ownerId&roleid=$roleId");
      final responseData = json.decode(response.toString());
      // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$responseData");

      if (responseData['status'] == true) {
        _invoicDetails = responseData['data'];

        hideLoader();

        // print("invoiceData<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$invoicDetails");

        // toggleshemmerdismis();
        notifyListeners();
      } else {
        // toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      // toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  InvoicelistingClick(context, Id) async {
    showLoader();


    Dio dio = Dio();

    try {
      var response = await dio.get(
        "http://209.97.156.170:7071/owner/click_invoice?id=$Id",
      );
      final responseData = json.decode(response.toString());


      debugPrint("$TAG  response Data ==========> $responseData");

      if (responseData['status'] == true) {
        invoicDetailsclicks = responseData['data'];

        orderId = invoicDetailsclicks[0]['order_id'];
        vendorName = invoicDetailsclicks[0]['vendor_name'];
        address = invoicDetailsclicks[0]['address'];
        phone = invoicDetailsclicks[0]['phone'];
        date = invoicDetailsclicks[0]['date'];
        status = invoicDetailsclicks[0]['order_status'];
        image =invoicDetailsclicks[0]['thumbnail_image'];
        productname = invoicDetailsclicks[0]['product_name'];

        qty = invoicDetailsclicks[0]['qty'] == null ? "0" : invoicDetailsclicks[0]['qty'].toString();
        price = invoicDetailsclicks[0]['price'] == null ? "0" : invoicDetailsclicks[0]['price'].toString();
        total = invoicDetailsclicks[0]['total'] == null ? "0" : invoicDetailsclicks[0]['total'].toString();
        SubTotal = invoicDetailsclicks[0]['sub_total'] == null ? "0" : invoicDetailsclicks[0]['sub_total'].toString();
        trackcharge = invoicDetailsclicks[0]['track_charge'] == null ? "0" : invoicDetailsclicks[0]['track_charge'].toString();
        labourcharge =invoicDetailsclicks[0]['labour_charge'] == null ? "0" : invoicDetailsclicks[0]['labour_charge'].toString();
        extracharge = invoicDetailsclicks[0]['extra_charge'] == null ? "0" : invoicDetailsclicks[0]['extra_charge'].toString();
        tax = invoicDetailsclicks[0]['tax'] == null ? "0" : invoicDetailsclicks[0]['tax'].toString();
        orderamount = invoicDetailsclicks[0]['order_amount'] == null ? "0" : invoicDetailsclicks[0]['order_amount'].toString();
        debugPrint("$TAG  response Amount ========= ==========> $orderamount");
        notifyListeners();
        hideLoader();
        notifyListeners();
      } else {
        hideLoader();
        notifyListeners();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      hideLoader();
      notifyListeners();
      // toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }
}
