import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/Auth/Loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DataApi/Home/ProfileApi.datr.dart';
import '../../common/const.dart';
import '../dashboard/dashboardModelPage.dart';
import '../toast.dart';
import 'EditProfileScreen.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(milliseconds: 700));

      await list.loadProfileDetails(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModelPage>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: HexColor("#F9F9F9"),
        appBar: AppBar(
          title: Container(
            color: HexColor("#F9F9F9"),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/tag.png", fit: BoxFit.contain),
                    sizedboxwidth(10.0),
                    Text(
                      "Profile",
                      style: TextStyle(fontSize: 25, color: HexColor("#1A1D1F"), fontWeight: fontWeight600),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            model: model,
                          ),
                        ));

                    await model.loadProfileDetails(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: HexColor("#EFEFEF"),
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Edit Profile", style: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#6759FF"))),
                        sizedboxwidth(10.0),
                        Icon(
                          Icons.edit,
                          size: 17,
                          color: HexColor("#6759FF"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ModalProgressHUD(
            inAsyncCall: model.is_loding,
            opacity: 0.7,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    model.imageUrl == ''
                                        ? const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: ClipOval(child: Icon(Icons.person_outline_rounded)),
                                          )
                                        : SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: ClipOval(
                                              child: Image.network(
                                                model.imageUrl.toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                sizedboxwidth(8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text((model.fristName ??= '') + '' + (model.lastName ??= ''), style: Theme.of(context).textTheme.headline6),
                                    sizedboxheight(4.0),
                                    Text(model.email, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Address",
                                    style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                color: HexColor("#F5F5F5"),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.address ??= '',
                                      style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "E-mail",
                                    style: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(10),
                                color: HexColor("#F5F5F5"),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.email,
                                      style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Password",
                                style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(10),
                                color: HexColor("#F5F5F5"),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "********",
                                      style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    Constants.showToast('Logout Successfully');
                    await prefs.clear();
                    Get.off(const Loginpage());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: HexColor("#6759FF"),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Text("Logout", style: TextStyle(fontSize: 18, fontWeight: fontWeight600, color: Colors.white)),
                  ),
                )
              ],
            )),
      );
    });

  }
}
