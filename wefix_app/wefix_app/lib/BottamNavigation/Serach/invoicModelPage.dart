import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DataApi/constant_apiUrl.dart';
import '../apiErrorAlertdialog.dart';
import 'invoicDetailsPage.dart';

class invoicModelPage extends ChangeNotifier {

  Dio dio = Dio();
  String TAG = "invoicModelPage";

  List _invoicDetails = [];

  List get invoicDetails => _invoicDetails;

  var invoicDetailsclicks;


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
  String fristname = '';
  String lastname = '';

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
  List allInvoiceList = [];

  clearValues(){
    priceController.clear();
    grandTotalController.clear();
    qtyController.clear();
    trackController.clear();
    labourController.clear();
    notesController.clear();
    subTotalController1.clear();
    taxController.clear();
    extraController.clear();
    _invoicDetails.isEmpty;


  }
  InvoiceListing(BuildContext context) async {
    invoicDetails.clear();
    showLoader();
    // toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);

    try {
      var response = await Dio().get("http://134.209.229.112:7071/owner/get_invoice?id=$ownerId&roleid=$roleId");
      final responseData = json.decode(response.toString());
      debugPrint(" allInvoiceListresponse ======> $response");



      if (responseData['status'] == true) {
        _invoicDetails = responseData['data'];

        hideLoader();

        print("invoiceData<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$invoicDetails");

        // toggleshemmerdismis();
        notifyListeners();
      } else {
        hideLoader();

        // toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      hideLoader();

      // toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadSearchInvoiceList(String searchQuery) async {
    invoicDetails.clear();
    showLoader();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    try {


      // debugPrint("searchproductUrl   searchText ========> ${searchproductUrl + searchText}");
      var url ="http://134.209.229.112/wefix_stagging/api/report?product=${searchQuery}&roleid=$roleId";
      print(url);
      var response = await dio.get(url);
      debugPrint("load Search allInvoiceListresponse ======> $response");
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        _invoicDetails = responseData['data'];
        hideLoader();

        notifyListeners();
        print("search allInvoiceList pages len =========> ${invoicDetails.length}");

        notifyListeners();
      } else {
        hideLoader();


        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      hideLoader();


      print('Error: ${e.toString()}');
    }
  }


  InvoicelistingClick(BuildContext context, Id) async {
    showLoader();

    Dio dio = Dio();
    var url = '$baseUrl/owner/click_invoice?id=$Id';
    print("Url=>=================$url");
    try {
      var response = await dio.get(
        "http://134.209.229.112:7071/owner/click_invoice?id=$Id",
      );
      final responseData = json.decode(response.toString());

      debugPrint("$TAG  response Data invoicess==========> $responseData");

      if (responseData['status'] == true) {
        invoicDetailsclicks = responseData['data'][0];


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

  TextEditingController notesController = TextEditingController();

  TextEditingController qtyController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController subTotalController1 = TextEditingController();
  TextEditingController trackController = TextEditingController();
  TextEditingController labourController = TextEditingController();
  TextEditingController extraController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  TextEditingController grandTotalController = TextEditingController();
  TextEditingController totalController = TextEditingController();



  String grandTotal = "";
  String totalPrice = "";
  double finalTax = 0.0;
  String orderAmount = "";

  void setSubTotal(String value  ) {
    subTotalController1.text = value;
    notifyListeners();
    calculation();
  }

  void setOrderAmount(String amount) {
    orderAmount = amount;
    totalPrice = amount;
    notifyListeners();
  }

  void updateSubTotal() {
    int qty = 0;
    int price = 0;

    if (qtyController.text.toString() != "null" && qtyController.text.toString() != "") {
      qty = int.parse(qtyController.text.toString());
    }
    if (priceController.text.toString() != "null" && priceController.text.toString() != "") {
      price = int.parse(priceController.text.toString());
    }

    int finalAmount = qty * price;

    setOrderAmount(finalAmount.toStringAsFixed(2));
    setSubTotal(finalAmount.toStringAsFixed(2));
  }

  void calculation() {
    // trackController.clear();
    // labourController.clear();
    // extraController.clear();
    // taxController.clear();
    double subTotal = 0.0;
    double truckCharge = 0.0;
    double labourCharge = 0.0;
    double extraCharge = 0.0;
    double taxTotal = 0.0;

    if (subTotalController1.text.toString() != "null" && subTotalController1.text.toString() != "") {
      subTotal = double.parse(subTotalController1.text.toString().trim());
    }
    if (trackController.text.toString() != "null" && trackController.text.toString() != "") {
      truckCharge = double.parse(trackController.text.toString().trim());
    }
    if (labourController.text.toString() != "null" && labourController.text.toString() != "") {
      labourCharge = double.parse(labourController.text.toString().trim());
    }
    if (extraController.text.toString() != "null" && extraController.text.toString() != "") {
      extraCharge = double.parse(extraController.text.toString().trim());
    }
    if (taxController.text.toString() != "null" && taxController.text.toString() != "") {
      taxTotal = double.parse(taxController.text.toString().trim());
    }

    double total = subTotal + truckCharge + labourCharge + extraCharge;
    finalTax = (total * taxTotal) / 100;
    double finalAmount = finalTax + total;
    grandTotal = finalAmount.toStringAsFixed(2);
    grandTotalController.text = grandTotal;

    notifyListeners();
  }




  generateInvoice(BuildContext context, String orderId, id, String notes,String qty,String price,String tarck ,String extra ,String labour) async {
    showLoader();
    Dio dio = Dio();
    Map<String, dynamic> data = {
      "order_id": orderId.toString(),
      "order_amount": orderAmount,
      'total': grandTotalController.text.split('.').first,
      'tax': finalTax.toString().split('.').first,
      'qty': qty,
      'track_charge': tarck,
      'extra_charge': extra,
      "price": price,
      "title":'',
      'labour_charge': labour,
      'invoice_notes': "x ",
      'total_amount': grandTotalController.text.split('.').first,
      'sub_total': subTotalController1.text.split('.').first,
    };



    var url = '${baseUrl}/owner/generate_invoice';
    print("URL: $url");
    print("Form Data: $data");

    try {
      var response = await dio.post(url, data: data);
      final responseData = json.decode(response.toString());


      print('$TAG generateInvoice responseData ================> $response');

      if (responseData['status'] == true) {


        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => invoicDetailsPage(
                Id: id,
              ),
            ));

        hideLoader();
        clearValues();

        notifyListeners();
      } else {
        hideLoader();


        print('Error generate invoice: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      hideLoader();

      if (e is DioError) {
        apiErrorAlertdialog(context, e.toString());
      }
      // toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  // checkField(BuildContext context, String orderId, id, String notes) {
  //   if (grandTotalController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Please enter your total amount!');
  //   } else if (qtyController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Please enter your qty!');
  //   } else if (trackController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: 'Please enter  track amount!');
  //   } else if (priceController.text == '') {
  //     Fluttertoast.showToast(msg: 'Please enter your labour charges!');
  //   }
  //   else {
  //     generateInvoice(context,  orderId, id,  notes);
  //   }
  // }


  void totalSub(){

  }
}
