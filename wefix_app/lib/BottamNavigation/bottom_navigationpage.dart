// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../DataApi/Home/Postorderapi.dart';
import '../DataApi/Home/Product_model.dart';
import '../DataApi/Home/ProfileApi.datr.dart';
import '../DataApi/Home/categoryPossition.dart';
import '../DataApi/Home/histrylist.dart';
import '../DataApi/Home/listvendor.dart';
import '../DataApi/Home/notffmodel.dart';
import '../DataApi/Home/proposal_api.dart';
import 'bottom_navigationmodelpage.dart';
import 'bottom_navigationwidgetpage.dart';

class BottomNavBarPage extends StatefulWidget {
  BottomNavBarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> backdb(model) async {
    if (model.bottombarzindex != 0) {
      model.togglebottomindexreset();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return WillPopScope(
        onWillPop: () {
          return model.bottombarzindex == 0 ? onWillPop(context) : backdb(model);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: model.bottombarScreens[model.bottombarzindex],
            bottomNavigationBar: bottomNavBarPagewidget(context, model),
          ),
        ),
      );
    });
  }
}
