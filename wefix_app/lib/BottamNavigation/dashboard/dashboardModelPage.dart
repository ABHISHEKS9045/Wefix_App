import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Auth/Loginpage.dart';
import '../../DataApi/constant_apiUrl.dart';
import 'package:http/http.dart' as http;

import '../PDF/pdf.dart';
import '../apiErrorAlertdialog.dart';
import '../toast.dart';

class DashboardModelPage extends ChangeNotifier {

  String TAG = "DashboardModelPage";

  bool _isShimmer = false;
  bool get isShimmer => _isShimmer;

  List allProductList = [];
  // List storelocation = [];

  List searchProductList = [];
  List vendorList = [];
  List historyList = [];
  List notificationList = [];
  var productDetails;
  List productImage = [];
  var profileDetails = [];
  var profileImage;
  var storelocation=[];
  var auctionData=[];
  var selectaddress = '';
  String? currentAddress = '';
  String imageUrl = '';
  String fristName = '';
  String email = '';
  String address = '';
  String userId = '';
  String lastName = '';
  int _activeindex = 0;
  int get activeindex => _activeindex;
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

  CarouselController buttonCarouselController = CarouselController();
  toggleshemmerShow() {
    _isShimmer = true;
    notifyListeners();
  }

  toggleshemmerdismis() {
    _isShimmer = false;
    notifyListeners();
  }

  valueset(index) {
    _activeindex = index;
    notifyListeners();
  }

  loadProfileDetails(context) async {
    showLoader();
    Dio dio = Dio();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ownerId = jsonDecode(prefs.getString('owner_id')!);
      var response = await dio.get(getProfileUrl + ownerId!);
      final responseData = json.decode(response.toString());
      if (responseData['status'] == true) {
        profileDetails = responseData['data'];
        imageUrl = profileDetails[0]['image'];
        fristName = profileDetails[0]['first_name'];
        lastName = profileDetails[0]['last_name'];
        email = profileDetails[0]['email'];
        address = profileDetails[0]['street_address'];
        userId =profileDetails[0]['id'];
        print("profileDetails<<<<<<<<<<<<<<<<<<<<<$profileDetails");
        hideLoader();
      } else {
        hideLoader();
        print('Error: ${responseData["message"]}');

      }
    } catch (e) {
      hideLoader();
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  editProfileDetails(context, firstName, lastName, address, isUpdateImage, image) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ownerId = jsonDecode(prefs.getString('owner_id')!);
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(editProfileUrl),);
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
      };

      request.fields['id'] = ownerId!;
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName.toString();
      request.fields['address'] = address.toString();

      request.headers.addAll(headers);
      if (isUpdateImage) {
        var pic = await http.MultipartFile('image', File(image.path).readAsBytes().asStream(), File(image.path).lengthSync(), filename: image.path.split("/").last);

        request.files.add(pic);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("add_product_response" + responseString.toString(),);
      var data = jsonDecode(responseString);
      print(data);
      if (data['status'] == true) {
        Constants.showToast('Profile updated successfully..');
        await prefs.setString(
          'address',
          json.encode(
            address,
          ),
        );
        await prefs.setString(
          'first_name',
          json.encode(
            firstName,
          ),
        );
        await prefs.setString(
          'last_name',
          json.encode(
            lastName,
          ),
        );
        Navigator.of(context).pop();
      }
      toggleshemmerdismis();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Something went wrong..');
      toggleshemmerdismis();
    }
  }

  loadNotificationList(context) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '4') {
        response = await dio.get(notificationUrl + ownerId);
      }
      if(roleId== '1' ) {
        response = await dio.get(vendorNotificationUrl + ownerId);
      }
      if (roleId == '3') {
        response = await dio.get("http://209.97.156.170:7071/owner/DM_Notifications");
      }
      final responseData = json.decode(response.toString());
      if (responseData['status'] == true) {
        notificationList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        notificationList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadSearchNotificationList(context, text) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '4') {
        response = await dio.get(searchNotificationUrl + ownerId + "&search=" + text);
      } else {
        response = await dio.get(searchVendorNotificationUrl + ownerId + "&search=" + text);
      }
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        notificationList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        notificationList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadDashboardProductList(context) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get(AllproductUrl);
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        allProductList = responseData['data'];
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

  loadHistoryList(context, productId) async {
    toggleshemmerShow();

    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    try {
      var response;
      Map<String, dynamic> params = {
        'product_id': productId,
        'owner_id': ownerId,
      };

      if (roleId == '4') {
        response = await dio.get(historyURL, queryParameters: params);
      } else {
        response = await dio.get(vendorHistoryURL, queryParameters: {
          'product_id': productId,
          'vendor_id': ownerId,
        });
      }
      // var response = await dio.get(historyURL,queryParameters: params);
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

  var productImagelength = 0;
  getProductDetails(context, id) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get(productDetailUrl + id.toString());
      final responseData = json.decode(response.toString());
      debugPrint("$TAG product details response =======> $response");
      if (responseData['status'] == true) {
        productDetails = responseData['data'][0];
        debugPrint("$TAG productDetails ============> $productDetails");

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

  loadSearchProductList(context, searchText) async {
    toggleshemmerShow();
    Dio dio = Dio();
    try {
      var response = await dio.get(searchproductUrl + searchText);
      final responseData = json.decode(response.toString());
      if (responseData['status'] == true) {
        allProductList = responseData['data'];
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<search product pages$allProductList");
        toggleshemmerdismis();
        notifyListeners();
      } else {
        allProductList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadVendorList(context, productId) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get(Vendorslist + productId.toString());
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        vendorList = responseData['data'];
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

  searchVendorList(context, productId, text) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get(searchVendorListURL + productId.toString() + "&search=" + text);
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        vendorList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        vendorList = [];
        toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  addOrder(context, owner_id, product_id, description, vendor_id, vendor_name, images) async {
    toggleshemmerShow();
    try {
      var request = http.MultipartRequest("POST", Uri.parse('http://209.97.156.170:7071/owner/add_order'));
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
      };
      request.fields['owner_id'] = jsonDecode(owner_id);
      request.fields['product_id'] = product_id.toString();
      request.fields['description'] = description.toString();
      request.fields['vendor_id'] = vendor_id.toString();
      request.fields['vendor_name'] = vendor_name.toString();
      request.headers.addAll(headers);
      for (var i = 0; i < images.length; i++) {
        var pic = await http.MultipartFile('image', File(images[i].path).readAsBytes().asStream(), File(images[i].path).lengthSync(), filename: images[i].path.split("/").last);

        request.files.add(pic);
        //
        //
      }

      var response = await request.send();
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("add_product_response" + responseString.toString());
      var data = jsonDecode(responseString);
      print(data);
      if (data['status'] == true) {
        Fluttertoast.showToast(msg: 'Praposal request sent to successfully..');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      toggleshemmerdismis();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Something went wrong..');
      toggleshemmerdismis();
    }
  }

  LogOutApi(context) async {
    // var device_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Dio dio = Dio();
    var response = await dio.post(
      "http://209.97.156.170:7071/owner/user_logout$userId",
    );

    final responseData = json.decode(response.toString());
    var message = responseData["message"].toString();

    try {
      if (responseData['message'] == 'User Logout Sucessfully ...') {
        await prefs.setBool("isLoggedIn", false);
        print('status:- ${prefs.getBool('isLoggedIn')}');

        Future.delayed(Duration(seconds: 1));
        Get.offAll(() => Loginpage());
        Fluttertoast.showToast(msg: 'Logout Successfully');

        // showFlutterToast('Logout Successfully');
        notifyListeners();
      } else {
        // toggleshemmerdismis();
        print('Error: ${responseData["message"]}');
        apiErrorAlertdialog(context, message);
      }
    } catch (e) {
      if (e is DioError) print('Error: ${e.toString()}');
    }
  }

  StoreLocationData(context) async {
    showLoader();
    Dio dio = Dio();
    try {
      var response = await dio.get('http://209.97.156.170:7071/owner/shop_list_by_location');
      final responseData = json.decode(response.toString());
      debugPrint("Store details response =======> $response");
      if (responseData['status'] == true) {
        storelocation = responseData['data'];
        hideLoader();
        print(storelocation);
        toggleshemmerdismis();
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



}
