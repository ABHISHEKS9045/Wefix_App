import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../DataApi/constant_apiUrl.dart';
import '../toast.dart';

class PDFModelPage extends ChangeNotifier {
  String TAG = "PDFModelPage";

  bool _isShimmer = false;
  bool get isShimmer => _isShimmer;
  List confirmedList = [];
  List pendingList = [];
  List historyList = [];
  List searchConfirmedPropasalList = [];
  List searchPendingPropasalList = [];
  List searchHistoryPropasalList = [];
  var proposalCount;
  int countConfimed = 0;
  int countPending = 0;
  var proposalCountp;
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

  toggleshemmerShow() {
    _isShimmer = true;
    notifyListeners();
  }

  toggleshemmerdismis() {
    _isShimmer = false;
    notifyListeners();
  }
  resetAllFields() {
    confirmedList = [];
    pendingList = [];
    historyList = [];
    searchConfirmedPropasalList = [];
    searchPendingPropasalList = [];
    searchHistoryPropasalList = [];


    countConfimed = 0;
    countPending = 0;

    notifyListeners();
  }
  acceptOrderVendor(context, model, note, price, date, time, imageList) async {
    int amount = int.parse(price);
    try {
      var request = http.MultipartRequest("POST", Uri.parse(acceptOrderAPI));
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
      };

      request.fields['order_id'] = model['order_id'].toString();
      request.fields['order_amount'] = price;
      request.fields['date'] = date;
      request.fields['time'] = time;
      request.fields['note'] = note;

      request.headers.addAll(headers);
      for (var i = 0; i < imageList.length; i++) {
        var pic = await http.MultipartFile('images', File(imageList[i].path).readAsBytes().asStream(), File(imageList[i].path).lengthSync(), filename: imageList[i].path.split("/").last);
        request.files.add(pic);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(
        "add_product_response$responseString",
      );
      var data = jsonDecode(responseString);
      print(data);

      if (data['status'] == true) {


        if (amount < 5000) {
          Constants.showToast( 'your order hase been auto accepted');
        } else {
          Constants.showToast( 'Request send to District Manager');
        }
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
        Navigator.of(context).pop();
      } else {


        Constants.showToast('Something went wrong..');
      }
      // Get.to(() => pdfpage());
    } catch (e) {
      print(e);
      Constants.showToast( 'Something went wrong..');
    }
  }

  acceptOrderVendor11(BuildContext context, model, String date, String time) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'order_id': model['order_id'].toString(),
        'date': date,
        'time': time,
      });

      debugPrint("$TAG formData =======> ${formData.fields}");

      var response = await dio.post(acceptOrderAPI, data: formData);
      var data = json.decode(response.toString());
      debugPrint("$TAG response ========> $data");

      if (data['status'] == true) {

        Constants.showToast('Schedule has been Submitted');
        notifyListeners();

        if (context.mounted) {
          Navigator.of(context).pop({"result": true});
        }
      } else {
        Constants.showToast('Something went wrong..');

        notifyListeners();
      }
      // Get.to(() => pdfpage());
    } catch (e) {
      print(e);


      Fluttertoast.showToast(msg: 'Something went wrong..');
      notifyListeners();
    }
  }

  rejectOrderVendor(context, model) async {
    toggleshemmerShow();
    Dio dio = Dio();

    try {
      var response = await dio.post("$baseUrl/owner/order_reject?order_id=${model['order_id']}&cancelled_by=1");

      final responseData = json.decode(response.toString());
      debugPrint("$TAG============================>$response");

      if (responseData['status'] == true) {
        Fluttertoast.showToast(msg: 'Order Rejected');
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
        loadProposalCountp(context);
        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  acceptOrderOwner(context, model) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == "4") response = await dio.post('$baseUrl/owner/owner_order_accepted?order_id=${model['order_id']}');
      if (roleId == "3") response = await dio.post('$baseUrl/owner/Dmanager_order_accepted?order_id=${model['order_id']}');

      // var response = await dio.post('http://134.209.229.112:7071/owner/owner_order_accepted?order_id=${model['order_id']}');
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {

        Constants.showToast('Order Accepted');
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
        loadProposalCountp(context);
        var messages = responseData["message"];
        Constants.showToast(messages);

        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  rejectOrderOwner(context, model) async {
    toggleshemmerShow();
    Dio dio = Dio();

    try {
      var response = await dio.post("$baseUrl/owner/order_reject?order_id=${model['order_id']}&cancelled_by=1");
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        Fluttertoast.showToast(msg: 'Order Rejected');
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
        loadProposalCountp(context);
        var messages = responseData["message"];
        Fluttertoast.showToast(msg: messages);
        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadSearchProposalList(context, searchText) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if(roleId == '4'){
        response = await dio.get(ownerSearchProposalHistoryUrl, queryParameters: {'owner_id': ownerId, 'search': searchText});
      }
      else if(roleId == '1'){
        response = await dio.get(vendorSearchProposalHistoryUrl, queryParameters: {'vendor_id': ownerId, 'search': searchText});
      }
      else if(roleId == '3'){
        response = await dio.get(vendorSearchProposalHistoryUrl, queryParameters: {'vendor_id': ownerId, 'search': searchText});
      }
      else {
        response = await dio.get(vendorSearchProposalHistoryUrl, queryParameters: {'vendor_id': ownerId, 'search': searchText});
      }
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        searchHistoryPropasalList = responseData['data'];
        toggleshemmerdismis();
        var messages = responseData["message"];
        Fluttertoast.showToast(msg: messages);
        notifyListeners();
      } else {
        searchHistoryPropasalList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }
    } catch (e) {

      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  searchConfirmedProposalList(context, searchText) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();

    try {
      var response;
      Map<String, dynamic> params = {
        'status': 'confirmed',
        'search': searchText,
        'owner_id': ownerId,
      };
      if (roleId == '4') {
        response = await dio.get(ownerSearchProposalUrl, queryParameters: params);
      } else {
        response = await dio.get(vendorSearchProposalUrl, queryParameters: params);
      }

      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        searchConfirmedPropasalList = responseData['data'];

        toggleshemmerdismis();
        notifyListeners();
      } else {
        searchConfirmedPropasalList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  searchPendingProposalList(context, searchText) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();

    try {
      var response;
      Map<String, dynamic> params = {'status': 'pending', 'search': searchText, 'owner_id': ownerId};
      if (roleId == '4')
        response = await dio.get(ownerSearchProposalUrl, queryParameters: params);
      else
        response = await dio.get(vendorSearchProposalUrl, queryParameters: params);

      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        searchPendingPropasalList = responseData['data'];
        dataCleanCount();
        toggleshemmerdismis();
        notifyListeners();
      } else {
        searchPendingPropasalList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();

      print('Error: ${e.toString()}');
    }
  }

  loadProposalCount(context) async {
    showLoader();
    dataCleanCount();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    Dio dio = Dio();
    try {
      var response;
      if (roleId == "1") {
        response = await dio.get('$proposalCountUrl$ownerId/confirmed');
      } else if (roleId == "4") {
        response = await dio.get('$proposalCountUrl$ownerId/confirmed');
      } else if (roleId == "3") {
        var url = "$baseUrl/owner/Count_Manager_OrderStatus?owner_id=$ownerId&roleid=$roleId";
        print("url: $url");
        response = await dio.get(url);
      } else {
        response = await dio.get("$baseUrl/owner/Count_Manager_OrderStatus?owner_id=$ownerId&roleid=$roleId");
      }
      final responseData = json.decode(response.toString());
      print('proposalcountConfimed11======$responseData');

      if (responseData['status'] == true) {
        print('object');
        proposalCount = responseData['data'];
        print('proposalcountConfimed1======$proposalCount');

        if (roleId == '1' || roleId == '4') {
          countConfimed = proposalCount[0]['count'];
        } else if (roleId == '3' || roleId == '2') {
          countConfimed = proposalCount['confirmed'];
        }
        // var messages = responseData["message"];
        // Constants.showToast(messages);
        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        // var messages = responseData["message"];
        // Constants.showToast(messages);
        print('Error: ${responseData["message"]}');

      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }
  dataCleanCount(){
    proposalCountp.clear();
    proposalCount.clear();
  }
  loadProposalCountp(context) async {


    showLoader();
    dataCleanCount();


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    Dio dio = Dio();
    try {


      var response;
      if (roleId == "1") {
        response = await dio.get('http://134.209.229.112:7071/owner/count_order_status/$ownerId/pending');
      } else if (roleId == "4") {
        response = await dio.get('$baseUrl/owner/count_order_status/$ownerId/pending');
      } else if (roleId == "3") {
        var url = "$baseUrl/owner/Count_Manager_OrderStatus?owner_id=$ownerId&roleid=$roleId";
        print("url: $url");
        response = await dio.get(url);
      } else {
        response = await dio.get("http://134.209.229.112:7071/owner/Count_Manager_OrderStatus?owner_id=$ownerId&roleid=$roleId");
      }

      final responseData = json.decode(response.toString());
      print("orderdatapendingcountPending=========>$responseData");

      if (responseData['status'] == true) {
        proposalCountp = responseData['data'];
        if (roleId == '1') {

          countPending = proposalCountp[0]['count'];
        } else if( roleId == '4'){
          countPending = proposalCountp[0]['count'];
        }
        else if (roleId == '2') {
          // proposalCountp = responseData['data'];
          countPending = proposalCountp['pending'];
        }
        else{
          countPending = proposalCountp['pending'];
        }
        toggleshemmerdismis();
        dataCleanCount();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }

    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadConfirmedProposalList(context) async {
    toggleshemmerShow();
    confirmedList.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    print("ownerIdManager============>$ownerId");
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {

      var url = '';
      var response;
      if (roleId == '1') {
        response = await dio.get("http://134.209.229.112:7071/owner/get_vendor_Proposal?vendor_id=$ownerId&order_status=confirmed");
      } else if (roleId == '4') {
        response = await dio.get("http://134.209.229.112:7071/owner/get_Proposal?order_status=Confirmed&owner_id=$ownerId");
      } else if (roleId == '3') {
        response = await dio.get("http://134.209.229.112:7071/owner/get_pending_Proposal?order_status=Confirmed&owner_id=$ownerId&roleid=$roleId");
      } else {
        response = await dio.get("http://134.209.229.112:7071/owner/get_pending_Proposal?order_status=Confirmed&owner_id=$ownerId&roleid=$roleId");
      }

      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {

        confirmedList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadPendingProposalList(context) async {
    pendingList.clear();
    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    Dio dio = Dio();
    var url = '';

    try {
      var response;
      if (roleId == '1') {
        url = "http://134.209.229.112:7071/owner/get_vendor_Proposal?vendor_id=$ownerId&order_status=pending";
        response = await dio.get(url);
      } else if (roleId == '4') {
        url = "http://134.209.229.112:7071/owner/get_Proposal?order_status=pending&owner_id=$ownerId";
        response = await dio.get(url);
      } else if (roleId == '3') {
        url = "http://134.209.229.112:7071/owner/get_pending_Proposal?order_status=pending&owner_id=$ownerId&roleid=$roleId";
        response = await dio.get(url);
      } else {
        url = "http://134.209.229.112:7071/owner/get_pending_Proposal?order_status=pending&owner_id=$ownerId&roleid=$roleId";
        response = await dio.get(url);
      }
      final responseData = json.decode(response.toString());

      print("url");

      debugPrint("$TAG loadPendingProposalList ================> $url");
      debugPrint("$TAG response  print pending data================> $response");

      if (responseData['status'] == true) {
        pendingList = responseData['data'];
        hideLoader();
        // toggleshemmerdismis();
        notifyListeners();
      } else {
        hideLoader();
        // toggleshemmerdismis();

        print('Error: ${responseData["message"]}');
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }
    } catch (e) {
      hideLoader();
      // toggleshemmerdismis();
    }
  }

  loadHistoryProposalList(context) async {
    toggleshemmerShow();


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '3') response = await dio.get("${ProposalHistoryUrl + ownerId}&roleid=$roleId");

      if (roleId == '2') response = await dio.get("${ProposalHistoryUrl + ownerId}&roleid=$roleId");
      if (roleId == '4') response = await dio.get(ProposalHistoryUrl + ownerId);
      if (roleId == '1') response = await dio.get(VendorProposalHistoryUrl + ownerId);

      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        historyList = responseData['data'];

        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        // var messages = responseData["message"];
        // Constants.showToast(messages);
        print('Error: ${responseData["message"]}');

      }
    } catch (e) {

      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }
}
