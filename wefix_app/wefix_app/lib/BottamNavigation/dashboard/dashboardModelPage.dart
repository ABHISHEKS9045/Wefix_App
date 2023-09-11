import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Auth/Loginpage.dart';
import '../../DataApi/constant_apiUrl.dart';
import '../../Notification/NotificationScreen.dart';
import '../PDF/pdfModelPage.dart';
import '../apiErrorAlertdialog.dart';
import '../bottom_navigationmodelpage.dart';
import '../toast.dart';

class DashboardModelPage extends ChangeNotifier {
  Dio dio = Dio();
  String TAG = "DashboardModelPage";
  bool _isShimmer = false;
  bool get isShimmer => _isShimmer;
  List allProductList = [];
  List searchProductList = [];
  List vendorList = [];
  List historyList = [];
  List notificationList = [];
  var productDetails;
  List productImage = [];
  var profileDetails;
  var profileImage;
  var storelocation = [];
  var auctionData = [];
  var selectaddress = '';
  var shopId;
  var notificationCount;
  var notificationCountRemoved;

  var countNotiy;
  var districId;
  String? currentAddress = '';
  String imageUrl = '';
  String fristName = '';
  String email = '';
  String address = '';
  String userId = '';
  String id = '';
  String approvallimit = '';
  String rollid = '';

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

  updateAddress(String address) {
    selectaddress = address;
    currentAddress = '';
    notifyListeners();
  }

  loadProfileDetails(BuildContext context) async {
    showLoader();
    Dio dio = Dio();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ownerId = jsonDecode(prefs.getString('owner_id')!);
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();

      var response = await dio.get(getProfileUrl + ownerId!);
      final responseData = json.decode(response.toString());

      debugPrint("$TAG load profile data API response ========> $response");

      if (responseData['status'] == true) {
        profileDetails = responseData['data'];
        address = profileDetails[0]['street_address'].toString();
        userId = profileDetails[0]['id'].toString();
        id = profileDetails[0]['id'].toString();
        imageUrl = profileDetails[0]['image'];
        fristName = profileDetails[0]['first_name'];
        lastName = profileDetails[0]['last_name'];
        email = profileDetails[0]['email'];
        approvallimit = profileDetails[0]['approval_limit'];
        // rollid = profileDetails[0]['roleid'];

        if (profileDetails[0]['street_address'].toString() != null) {
          address = profileDetails[0]['street_address'].toString();
        }
        print("Adress profile data API response==========>$address");
        hideLoader();
      } else {
        hideLoader();
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      hideLoader();
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  editProfileDetails(BuildContext context, firstName, lastName, address, isUpdateImage, image) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ownerId = jsonDecode(prefs.getString('owner_id')!);
    try {
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(editProfileUrl),
      );
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
      print(
        "add_product_response$responseString",
      );
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

      Constants.showToast('Something went wrong..');
      toggleshemmerdismis();
    }
  }

  loadNotificationList(context) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    print("OwenerIdNotification====================>$roleId");

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '4') {
        response = await dio.get(notificationUrl + ownerId);
      } else if (roleId == "1") {
        response = await dio.get("$baseUrl/owner/vendor_all_notifications?vendor_id=$ownerId");
      } else if (roleId == '3') {
        response = await dio.get("http://134.209.229.112:7071/owner/DM_Notifications?owner_id=$ownerId&roleid=$roleId");
      } else {
        response = await dio.get("$baseUrl/owner/DM_Notifications?owner_id=$ownerId&roleid=$roleId");
      }

      final responseData = json.decode(response.toString());
      if (responseData['status'] == true) {
        notificationList = responseData['data'];
        toggleshemmerdismis();
        notifyListeners();
      } else {
        notificationList = [];
        toggleshemmerdismis();
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadSearchNotificationList(BuildContext context, String text) async {
    toggleshemmerShow();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();

    Dio dio = Dio();
    try {
      var response;
      if (roleId == '4') {
        response = await dio.get("$searchNotificationUrl$ownerId&search=$text");
      } else {
        response = await dio.get("$searchVendorNotificationUrl$ownerId&search=$text");
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

  loadDashboardProductList(BuildContext context) async {
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
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadHistoryList(BuildContext context, productId) async {
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
      response = await dio.get(historyURL, queryParameters: params);
      // if (roleId == '4' || roleId == '3' || roleId == '2' || roleId == '1') {
      //   response = await dio.get(historyURL, queryParameters: {
      //     'product_id': productId,
      //     'vendor_id': ownerId,
      //   });
      // }
      // var response = await dio.get(historyURL,queryParameters: params);
      final responseData = json.decode(response.toString());

      if (responseData['status'] == true) {
        historyList = responseData['data'];

        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  var productImagelength = 0;

  getProductDetails(BuildContext context, id) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get(productDetailUrl + id.toString());
      final responseData = json.decode(response.toString());
      debugPrint("$TAG productDetailsproduct details response =======> $response");
      if (responseData['status'] == true) {
        productDetails = responseData['data'][0];
        shopId = productDetails['shop_id'];
        districId = productDetails['district_id'];
        debugPrint("$TAG productDetailsshopId districId============> $districId");

        toggleshemmerdismis();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  loadSearchProductList(BuildContext context, String searchText) async {
    toggleshemmerShow();
    Dio dio = Dio();
    try {
      debugPrint("searchproductUrl   searchText ========> ${searchproductUrl + searchText}");

      var response = await dio.get(searchproductUrl + searchText);
      debugPrint("load Search Product List response ======> $response");
      final responseData = json.decode(response.toString());
      if (responseData['status'] == true) {
        allProductList = responseData['data'];
        print("search product pages =========> $allProductList");
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

  loadVendorList(BuildContext context, productId) async {
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
        // var messages = responseData["message"];
        // Constants.showToast(messages);
      }
    } catch (e) {
      toggleshemmerdismis();
      print('Error: ${e.toString()}');
    }
  }

  searchVendorList(BuildContext context, productId, text) async {
    toggleshemmerShow();

    Dio dio = Dio();
    try {
      var response = await dio.get("$searchVendorListURL$productId&search=$text");
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

  addOrder(BuildContext context, owner_id, product_id, description, vendor_id, vendor_name, images) async {
    toggleshemmerShow();
    try {
      var request = http.MultipartRequest("POST", Uri.parse('http://134.209.229.112:7071/owner/add_order'));
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
      };
      request.fields['owner_id'] = jsonDecode(owner_id);
      request.fields['product_id'] = product_id.toString();
      request.fields['description'] = description.toString();
      request.fields['vendor_id'] = vendor_id.toString();
      request.fields['vendor_name'] = vendor_name.toString();
      request.fields['shop_id'] = shopId.toString();
      request.fields['district_id'] = districId.toString();
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
      print("add_product_response$responseString");
      var data = jsonDecode(responseString);
      print(data);
      if (data['status'] == true) {

        Constants.showToast('proposal  request sent to successfully..');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      toggleshemmerdismis();
    } catch (e) {
      print(e);
      Constants.showToast( 'Something went wrong..');
      toggleshemmerdismis();
    }
  }

  LogOutApi(BuildContext context, userId) async {
    showLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    String url = "${baseUrl}/owner/user_logout";

    try {
      var response = await dio.post(url, data: {"id": userId});
      final responseData = json.decode(response.toString());
      print("$TAG=========== User data login ===============$userId");
      if (responseData['status'] == true) {
        var message = responseData["message"].toString();
        await prefs.clear();
        await prefs.setBool("isLoggedIn", false);
        hideLoader();
        var messages = responseData["message"];
        Constants.showToast(messages);
        if (context.mounted) {
          Provider.of<BottomnavbarModelPage>(context, listen: false).togglebottomindexreset();
          Provider.of<PDFModelPage>(context, listen: false).resetAllFields();
        }
        notifyListeners();

        Get.offUntil(
          MaterialPageRoute(
            builder: (context) {
              return const Loginpage();
            },
          ),
          (route) {
            return false;
          },
        );
      } else {
        hideLoader();
        var messages = responseData["message"];
        Constants.showToast(messages);
        if (context.mounted) {
          apiErrorAlertdialog(context, messages);
        }
      }
    } catch (e) {
      hideLoader();
      if (e is DioError) print('Error: ${e.toString()}');
    }
  }

  StoreLocationData(BuildContext context) async {
    showLoader();
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId = jsonDecode(prefs.getString('owner_id')!);
    String roleId = jsonDecode(prefs.getString('roleid')!).toString();
    try {
      var response = await dio.get('$baseUrl/owner/shop_list_by_location?id=$ownerId&roleid=$roleId');
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
        var messages = responseData["message"];
        Constants.showToast(messages);
      }
    } catch (e) {
      hideLoader();

      print('Error: ${e.toString()}');
    }
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('userId')!;
  }

  dataNotificationCount(BuildContext context) async {
    showLoader();

    Dio dio = Dio();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ownerId = jsonDecode(prefs.getString('owner_id')!);
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      var response;
      if (roleId == "1") {
        response = await dio.get('$baseUrl/owner/count_notifications/$ownerId/$roleId');
      } else if (roleId == "4") {
        response = await dio.get('$baseUrl/owner/count_notifications/$ownerId/$roleId');
      } else if(roleId == "3"){
        response = await dio.get('$baseUrl/owner/count_notifications/$ownerId/$roleId');
      }
      else{
        response = await dio.get('$baseUrl/owner/count_notifications/$ownerId/$roleId');
      }
      final responseData = json.decode(response.toString());
      debugPrint("notificationCount response =======> $response");
      if (responseData['status'] == true) {
        notificationCount = responseData['data'][0];
        countNotiy = notificationCount['count'];
        debugPrint("countNotiy response =======> $countNotiy");

        hideLoader();
        print(countNotiy);
        toggleshemmerdismis();
        notifyListeners();

      } else {
        hideLoader();
        var messages = responseData["message"];
        Constants.showToast(messages);

      }
    } catch (e) {
      hideLoader();
      print('Error: ${e.toString()}');
    }
  }


  dataNotificationCountRemoved(BuildContext context) async {
    showLoader();
    Dio dio = Dio();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ownerId = jsonDecode(prefs.getString('owner_id')!);
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      var response;
      if (roleId == "1") {
        response = await dio.get('$baseUrl/owner/click_notifications/$ownerId/$roleId');
      } else if (roleId == "4") {
        response = await dio.get('$baseUrl/owner/click_notifications/$ownerId/$roleId');
      } else if(roleId == "3"){
        response = await dio.get('$baseUrl/owner/click_notifications/$ownerId/$roleId');
      }
      else{
        response = await dio.get('$baseUrl/owner/click_notifications/$ownerId/$roleId');
      }
      final responseData = json.decode(response.toString());
      debugPrint("countNotiyRemoved1 response =======> $response");
      if (responseData['status'] == false) {
        notificationCountRemoved = responseData['data'];



        debugPrint("countNotiyRemoved2 response =======> $notificationCountRemoved");
        hideLoader();
        print(countNotiy);
        toggleshemmerdismis();
        notifyListeners();
      } else {
        hideLoader();
        var messages = responseData["message"];
        Constants.showToast(messages);

      }
    } catch (e) {
      hideLoader();
      print('Error: ${e.toString()}');
    }
  }


}
