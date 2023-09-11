import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/Auth/LoginModelPage.dart';
import 'package:service/Auth/loginwidget.dart';
import 'package:service/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottamNavigation/bottom_navigationpage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
    // checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginModelPage>(builder: (context, model, _) {
      return
      ModalProgressHUD(
        inAsyncCall: model.isShimmer,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(
          color: colorTheme,
        ),
        child:
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 100,
              width: 170,
              child: Center(
                child: Image.asset("assets/images/wefix_logo.png", fit: BoxFit.contain),
              ),
            ),

            loginChildrens(context,),
          ],
        ),
      ),);}),
    );
  }
}
