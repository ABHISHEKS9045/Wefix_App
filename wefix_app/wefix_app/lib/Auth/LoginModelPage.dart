import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/toast.dart';
import 'package:service/DataApi/constant_apiUrl.dart';
import 'package:service/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottamNavigation/apiErrorAlertdialog.dart';
import '../BottamNavigation/bottom_navigationmodelpage.dart';
import '../BottamNavigation/bottom_navigationpage.dart';

class LoginModelPage extends ChangeNotifier {
  String TAG = "LoginModelPage";
  bool _isShimmer = false;
  bool get isShimmer => _isShimmer;
  int _bottombarzindex = 0;
  int get bottombarzindex => _bottombarzindex;
  toggleShimmerShow() {
    _isShimmer = true;
    notifyListeners();
  }


  toggleshemmerdismis() {
    _isShimmer = false;
    notifyListeners();
  }

  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  loginSubmit(context) async {
    if (loginEmail.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill email');
      return;
    } else if (loginPassword.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill password');
      return;
    }
    toggleShimmerShow();
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "email": loginEmail.text,
      "password": loginPassword.text,
      "device_id": deviceToken,
    });
    debugPrint('$TAG Login Submit params =========> ${formData.fields}');
    try {
      var response = await dio.post("$baseUrl/owner/Signin", data: formData);
      final responseData = response.data;
      debugPrint('$TAG response data  ===========> $responseData');
      if (responseData['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'email',
          json.encode(
            responseData['data']['email'],
          ),
        );
        await prefs.setString(
          'image',
          json.encode(
            responseData['data']['image'],
          ),
        );
        await prefs.setString(
          'first_name',
          json.encode(
            responseData['data']['first_name'],
          ),
        );
        await prefs.setString(
          'last_name',
          json.encode(
            responseData['data']['last_name'],
          ),
        );
        await prefs.setString(
          'password',
          json.encode(
            responseData['data']['password'],
          ),
        );
        await prefs.setString(
          'roleid',
          json.encode(
            responseData['data']['roleid'],
          ),
        );

        await prefs.setString(
          'owner_id',
          json.encode(
            responseData['data']['id'].toString(),
          ),
        );

        await prefs.setString(
          'address',
          json.encode(
            responseData['data']['address'],
          ),
        );
        await prefs.setString(
          'userId',
          json.encode(
            responseData['data']['id'],
          ),
        );
        await prefs.setBool("isLoggedIn", true);

        Get.offAll(() => BottomNavBarPage(),);
        Constants.showToast('Login Successful');
        toggleshemmerdismis();
        loginEmail.clear();
        loginPassword.clear();
        notifyListeners();
      } else {
        toggleshemmerdismis();
        debugPrint('Error: ${responseData["message"]}');

        var messages = ' The email address you entered isn\'t connected to an account. create your account and then log in';
        apiErrorAlertdialog(context, messages);
      }
    } catch (e) {
      if (e is DioError) Fluttertoast.showToast(msg: e.response!.data['message']);
      toggleshemmerdismis();

      debugPrint('Error: ${e.toString()}');
    }
  }
}
