import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:service/common/const.dart';

import '../BottamNavigation/dashboard/dashboardModelPage.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(milliseconds: 600));

      await list.loadNotificationList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModelPage>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Notificationsearch(context, model),
          ),
          body: model.isShimmer
              ? Center(
                  child: CircularProgressIndicator(
                    color: HexColor("#6759FF"),
                  ),
                )
              : SingleChildScrollView(child: Consumer<DashboardModelPage>(
                  builder: (context, model, _) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await model.loadNotificationList(context);
                      },
                      child: Container(
                        color: HexColor("#F9F9F9"),
                        child: Column(
                          children: [
                            Column(children: []),
                            const SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.asset("assets/icons/tag.png", fit: BoxFit.contain),
                                  sizedboxwidth(10.0),
                                  Text(
                                    "Notification",
                                    style: TextStyle(fontSize: 28, color: HexColor("#1A1B2D"), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            model.notificationList.length != 0
                                ? Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.builder(
                                        itemCount: model.notificationList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          var data = model.notificationList[index];
                                          return Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300, width: 1), color: Color(0xFFF7F7FF)),
                                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: ClipOval(
                                                    child: data['thumbnail_image'] != null
                                                        ? Image.network(
                                                            data['thumbnail_image'],
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (a, b, c) => const Image(
                                                              image: AssetImage('assets/images/frame.png'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : const Image(
                                                            image: AssetImage('assets/images/frame.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                sizedboxwidth(10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(data['message'] ??= '', style: TextStyle(fontSize: 17, color: HexColor("#1A1D1F"), fontWeight: fontWeight600)),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(data['first_name'] ??= '', style: TextStyle(fontSize: 18, color: HexColor("#6F767E"))),
                                                          sizedboxwidth(5.0),
                                                          Text(data['last_name'] ??= '', style: TextStyle(fontSize: 18, color: HexColor("#6F767E"))),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                : Stack(children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                            decoration: BoxDecoration(color: colorWhite, borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                                            width: 550.0,
                                            height: 600.0,
                                            child: Column(
                                              children: [
                                                sizedboxheight(20.0),
                                                InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      child: Center(
                                                          child: Column(
                                                        children: [
                                                          const SizedBox(height: 120),
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10),
                                                            height: 200,
                                                            width: 200,
                                                            child: Image.asset("assets/icons/noty.png"),
                                                          ),

                                                          // Icon(Icons.notifications,size: 200, color: HexColor("#6759FF"),),
                                                          const SizedBox(height: 30),
                                                          const Text(
                                                            "No Notifications!",
                                                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Container(
                                                            alignment: Alignment.center,
                                                            child: Center(
                                                              child: Text(
                                                                "You dont have any notification yet.",
                                                                style: TextStyle(fontSize: 20, color: HexColor("#B0B0B0")),
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(height: 5),
                                                          Text(
                                                            " Please place order",
                                                            style: TextStyle(fontSize: 20, color: HexColor("#B0B0B0")),
                                                          ),
                                                          const SizedBox(height: 20),
                                                        ],
                                                      )),
                                                    )
                                                    // //

                                                    ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ]),
                          ],
                        ),
                      ),
                    );
                  },
                )));
    });
  }

  Widget Notificationsearch(context, model) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: TextField(
        controller: searchController,
        onSubmitted: (text) async {
          await model.loadSearchNotificationList(context, searchController.text);
        },
        // obscureText: true,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,

          filled: true, //<-- SEE HERE
          fillColor: HexColor("#F5F5F5"),
          hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Search Notification',
          prefixIcon: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          suffixIcon: TextButton(
            onPressed: () async {
              await model.loadSearchNotificationList(context, searchController.text);
            },
            // icon: Icon(Icons.visibility, size: 20.0, color: model.isTapVissible ? colorredlightbtn :Colors.black45 ),

            child: Container(
              margin: const EdgeInsets.only(left: 20),
              height: 35,
              width: 35,
              child: Image.asset("assets/icons/searchgroup.png"),
            ),
          ),
        ),
      ),
    );
  }
}
