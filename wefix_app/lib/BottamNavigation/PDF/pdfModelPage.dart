import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DataApi/constant_apiUrl.dart';
import 'package:http/http.dart' as http;

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
        if (amount < 1000) {
          Fluttertoast.showToast(msg: 'Request send to  owner');
        } else {
          Fluttertoast.showToast(msg: 'Request send to District Manager');
        }
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong..');
      }
      // Get.to(() => pdfpage());
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Something went wrong..');
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
        Fluttertoast.showToast(msg: 'Schedule has been Submitted');
        notifyListeners();

        if (context.mounted) {
          Navigator.of(context).pop({"result": true});
        }
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong..');
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
      var response = await dio.post("http://209.97.156.170:7071/owner/order_reject?order_id=${model['order_id']}&cancelled_by=1");

      final responseData = json.decode(response.toString());
      debugPrint("$TAG============================>$response");

      if (responseData['status'] == true) {
        Fluttertoast.showToast(msg: 'Order Rejected');
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
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
      if (roleId == "4") response = await dio.post('http://209.97.156.170:7071/owner/owner_order_accepted?order_id=${model['order_id']}');
      if (roleId == "3") response = await dio.post('http://209.97.156.170:7071/owner/Dmanager_order_accepted?order_id=${model['order_id']}');

      // var response = await dio.post('http://209.97.156.170:7071/owner/owner_order_accepted?order_id=${model['order_id']}');
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        Fluttertoast.showToast(msg: 'Order Accepted');
        loadConfirmedProposalList(context);
        loadPendingProposalList(context);
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

  rejectOrderOwner(context, model) async {
    toggleshemmerShow();
    Dio dio = Dio();

    try {
      var response = await dio.post("http://209.97.156.170:7071/owner/order_reject?order_id=${model['order_id']}&cancelled_by=1");
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        Fluttertoast.showToast(msg: 'Order Rejected');
        loadPendingProposalList(context);
        loadConfirmedProposalList(context);
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

  loadSearchProposalList(context, searchText) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '4') {
        response = await dio.get(ownerSearchProposalHistoryUrl, queryParameters: {'owner_id': ownerId, 'search': searchText});
      } else {
        response = await dio.get(vendorSearchProposalHistoryUrl, queryParameters: {'vendor_id': ownerId, 'search': searchText});
      }
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        searchHistoryPropasalList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        searchHistoryPropasalList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
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

        toggleshemmerdismis();
        notifyListeners();
      } else {
        searchPendingPropasalList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadProposalCount(context) async {
    showLoader();
    // toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == "3") response = await dio.get("http://209.97.156.170:7071/owner/Count_Manager_OrderStatus?order_status=confirmed");
      if (roleId == "1" || roleId == "4") response = await dio.get('$proposalCountUrl$ownerId/confirmed');
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        print('object');
        proposalCount = responseData['data'];
        countConfimed = proposalCount[0]['count'];
        hideLoader();
        print('cccccddddddddddddddddddsasssssssssss$countConfimed');
        toggleshemmerdismis();
        notifyListeners();
      } else {
        // proposalCount = {
        //   "pending_count": 0,
        //   "confirmed_count": 0,
        // };
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      // proposalCount = {
      //   "pending_count": 0,
      //   "confirmed_count": 0
      // };
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadProposalCountp(context) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == "3") response = await dio.get("http://209.97.156.170:7071/owner/Count_Manager_OrderStatus?order_status=pending");
      if (roleId == "1" || roleId == "4") response = await dio.get('$proposal1CountUrl$ownerId/pending');
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        print('aaaaa');
        proposalCountp = responseData['data'];
        countPending = proposalCountp[0]['count'];
        print('ddddffffffffffffffffff$countPending');
        toggleshemmerdismis();
        notifyListeners();
      } else {
        // proposalCount = {
        //   "pending_count": 0,
        //   "confirmed_count": 0,
        // };
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      // proposalCount = {
      //   "pending_count": 0,
      //   "confirmed_count": 0
      // };
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadConfirmedProposalList(context) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var url = '';
      var response;
      if (roleId == "3") response = await dio.get(DManegerConfirmUrl);
      if (roleId == '4') response = await dio.get(ProposalConfirmUrl + ownerId);

      if (roleId == '1') response = await dio.get(VendorProposalConfirmUrl + ownerId);
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        confirmedList = responseData['data'];
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

  loadPendingProposalList(context) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    Dio dio = Dio();
    try {
      var response;
      if (roleId == "3") response = await dio.get(DManegerPendingUrl);
      if (roleId == '4') response = await dio.get(ProposalPendingUrl + ownerId);

      if (roleId == "1") response = await dio.get(VendorProposalPendingUrl + ownerId);
      final responseData = json.decode(response.toString());

      debugPrint("$TAG response  print pending data================> $response");

      if (responseData['status'] == true) {
        pendingList = responseData['data'];
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

  loadHistoryProposalList(context) async {
    toggleshemmerShow();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == "3") response = await dio.get(DMProposalHistoryUrl);
      if (roleId == '4') {
        response = await dio.get(ProposalHistoryUrl + ownerId);
      } else {
        response = await dio.get(VendorProposalHistoryUrl + ownerId);
      }

      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        historyList = responseData['data'];
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
}
