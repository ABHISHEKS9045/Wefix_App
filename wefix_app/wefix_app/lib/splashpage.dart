import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/Loginpage.dart';
import 'BottamNavigation/bottom_navigationpage.dart';
import 'common/const.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginStatus = prefs.getBool('isLoggedIn');
    if (loginStatus == true) {
      Get.offAll(() => BottomNavBarPage());
    } else if (loginStatus == false) {
      Get.offAll(() => const Loginpage(),);
    }
  }

  @override
  void initState() {

    super.initState();
    getValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: deviceWidth(context, 1.0),
        height: deviceheight(context, 1.0),
        child: Center(child:    Container(
          height: 100,
          width: 100,

          child:    Image.asset(
            'assets/images/wefix_logo.png',
            fit: BoxFit.cover,
          ),),)


      ),
    );
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status =  prefs.getBool('isLoggedIn') ?? false;
    // print("header   ${prefs.getString("headerToken")}");
    Timer(
      const Duration(seconds: 1),
          () {

        status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => const Loginpage());
      },
    );
  }

}
