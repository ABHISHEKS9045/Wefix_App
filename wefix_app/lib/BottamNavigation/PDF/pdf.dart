import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/PDF/fullScreenImage.dart';
import 'package:service/BottamNavigation/PDF/pdfModelPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../QRCode/rrscan.dart';
import '../../common/button.dart';
import '../../common/const.dart';
import '../Serach/Searchpage.dart';
import 'AddVendorQuoteScreen2.dart';
import 'addVendorQuoteScreen.dart';

class pdfpage extends StatefulWidget {
  int? tabIndex = 2;
  pdfpage({super.key, this.tabIndex});

  @override
  State<pdfpage> createState() => _pdfpageState();
}

class _pdfpageState extends State<pdfpage> {
  bool isVendor = false;
  bool ismanager = false;
  int selectAll = 2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectAll = widget.tabIndex ??= 2;
    });
    var list = Provider.of<PDFModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      if (roleId == '1') isVendor = true;

      //
      await list.loadPendingProposalList(context);
      await list.loadConfirmedProposalList(context);
      await list.loadProposalCount(context);
      await list.loadProposalCountp(context);
      await list.loadHistoryProposalList(context);
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<PDFModelPage>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: HexColor("#F9F9F9"),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Container(height: 60, margin: const EdgeInsets.only(top: 10), child: loginsearch112(context, model)),
        ),
        body: Consumer<PDFModelPage>(builder: (context, model, _) {
          return model.isShimmer
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: HexColor("#6759FF"),
                  ),
                )
              : Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 55,
                          color: Colors.white,
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Button(
                                  btnColor: selectAll == 1 ? HexColor('#EFEEFF') : colorWhite,
                                  btnstyle: TextStyle(color: selectAll == 1 ? HexColor('#535763') : HexColor('#535763'), fontSize: 15.0),
                                  btnWidth: deviceWidth(context, 0.34),
                                  buttonName: "Confirm(${model.countConfimed ?? '0'})",
                                  btnHeight: 40.0,
                                  onPressed: () {
                                    setState(() {
                                      selectAll = 1;
                                    });
                                  }),
                              Button(
                                  btnColor: selectAll == 2 ? HexColor('#EFEEFF') : colorWhite,
                                  btnstyle: TextStyle(color: selectAll == 2 ? HexColor('#535763') : HexColor('#535763'), fontSize: 16.0),
                                  btnWidth: deviceWidth(context, 0.34),
                                  buttonName: "Pending(${model.countPending ?? '0'})",
                                  btnHeight: 40.0,
                                  onPressed: () {
                                    setState(() {
                                      selectAll = 2;
                                    });
                                  }),
                              Button(
                                  btnColor: selectAll == 3 ? HexColor('#EFEEFF') : colorWhite,
                                  btnstyle: TextStyle(color: selectAll == 3 ? HexColor('#535763') : HexColor('#535763'), fontSize: 16.0),
                                  btnWidth: deviceWidth(context, 0.25),
                                  buttonName: "History",
                                  btnHeight: 40.0,
                                  onPressed: () {
                                    setState(() {
                                      selectAll = 3;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        sizedboxwidth(10.0),
                        Image.asset("assets/icons/tag.png"),
                        sizedboxwidth(10.0),
                        if (!isVendor) Text('Proposal', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 30, fontWeight: fontWeight600)),
                        if (isVendor) Text('Schedule ', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 28, fontWeight: fontWeight600)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: showTab(model))
                  ],
                );
        }),
      );
    });
  }

  Widget showTab(model) {
    if (selectAll == 1) {
      //Confirm Proposal
      return RefreshIndicator(
          onRefresh: () async {
            await model.loadConfirmedProposalList(context);
          },
          child: Column(
            children: [
              Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        //height: MediaQuery.of(context).size.height,
                        child: (model.confirmedList.length == 0 || (searchController.text.isNotEmpty && model.searchConfirmedPropasalList.length == 0))
                            ? Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 200),
                                child: const Text(
                                  'No data found!!',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                ))
                            : ListView.builder(
                                itemCount: searchController.text.isEmpty ? model.confirmedList.length : model.searchConfirmedPropasalList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = searchController.text.isEmpty ? model.confirmedList[index] : model.searchConfirmedPropasalList[index];
                                  return Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 1, right: 10, left: 10),
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: ClipOval(
                                                            child: data['thumbnail_image'] != null
                                                                ? Image.network(
                                                                    data['thumbnail_image'],
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                : Image.asset('assets/images/frame.png'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    sizedboxwidth(8.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data['product_name'], style: TextStyle(fontSize: 16, color: HexColor("#1A1D1F"))),
                                                        sizedboxheight(4.0),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  data['time'],
                                                                  style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                                ),
                                                                sizedboxwidth(5.0),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      data['updatedAt'],
                                                      style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 2,
                                            thickness: 2,
                                            color: HexColor("#EFEFEF"),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Html(data: data['note'] ??= ''),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            margin: EdgeInsets.only(top: 1, right: 10, left: 10),
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: ClipOval(
                                                            child: data['vendor_image'] != null
                                                                ? Image.network(
                                                                    //"https://mactosys.com/Report/public/images/products/202212291753xiaomi-redmi-8a-0.jpg"
                                                                    data['vendor_image'],

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
                                                        )
                                                      ],
                                                    ),
                                                    sizedboxwidth(8.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          isVendor ? data['first_name'] + ' ' + data['last_name'] : data['vendor_name'],
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: HexColor("#1A1D1F"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 10, right: 10),
                                                      alignment: Alignment.center,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var res = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ScanQR(),
                                                              ));
                                                        },
                                                        child: const SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: Image(
                                                              image: AssetImage('assets/icons/bar.png'),
                                                            )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _launchUrl();
                                                      },
                                                      child: btnview1(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isVendor)
                                            Container(
                                              margin: const EdgeInsets.only(top: 1, right: 10, left: 10),
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.asset("assets/icons/Icon- Date.png"),
                                                          )
                                                        ],
                                                      ),
                                                      sizedboxwidth(12.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text((data['time'] ??= '') + ", " + (data['date'] ??= ''), style: Theme.of(context).textTheme.headline6),
                                                          sizedboxheight(6.0),
                                                          Row(
                                                            children: [
                                                              Text('Schedule', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if ((isVendor && data['image'] != null) || (!isVendor && data['images'] != null))
                                            Container(
                                              height: 80,
                                              width: MediaQuery.of(context).size.width,
                                              margin: const EdgeInsets.symmetric(horizontal: 15),
                                              child: ListView.builder(
                                                  itemCount: isVendor ? data['image'].length : data['images'].length,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    var url = isVendor ? data['image'][index] : data['images'][index];
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => FullScreenImage(url: url),
                                                            ));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                                        child: Container(
                                                          height: 40,
                                                          width: 70,
                                                          child: Image.network(
                                                            url,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: HexColor("#EFEEFF"),
                                              // borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: colorblack.withOpacity(0.1)),
                                              boxShadow: boxShadowcontainer(),
                                            ),
                                            margin: EdgeInsets.only(top: 20, right: 40, left: 40),
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                sizedboxwidth(15.0),
                                                Text(
                                                  "Price : ",
                                                  style: TextStyle(fontSize: 25, fontWeight: fontWeight500),
                                                ),
                                                sizedboxwidth(5.0),
                                                Text(
                                                  data['order_amount'].toString(),
                                                  style: TextStyle(fontSize: 25, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ) !=
                      null
                  ? Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        //height: MediaQuery.of(context).size.height,
                        child: (model.confirmedList.length == 0 || (searchController.text.isNotEmpty && model.searchConfirmedPropasalList.length == 0))
                            ? Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 200),
                                child: const Text(
                                  'No data found!!',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                ),
                              )
                            : ListView.builder(
                                itemCount: searchController.text.isEmpty ? model.confirmedList.length : model.searchConfirmedPropasalList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = searchController.text.isEmpty ? model.confirmedList[index] : model.searchConfirmedPropasalList[index];
                                  return Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 1, right: 10, left: 10),
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: ClipOval(
                                                            child: data['thumbnail_image'] != null
                                                                ? Image.network(
                                                                    data['thumbnail_image'],
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                : Image.asset('assets/images/frame.png'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    sizedboxwidth(8.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data['product_name'], style: TextStyle(fontSize: 14, color: HexColor("#1A1D1F"))),
                                                        sizedboxheight(4.0),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  data['order_id'].toString() == "null" ? "" : data['order_id'].toString(),
                                                                  style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                                ),
                                                                sizedboxwidth(5.0),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          data['time'].toString() == "null" ? "" : data['time'].toString(),
                                                          style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                        ),
                                                        Text(
                                                          data['date'].toString() == "null" ? "" : data['date'].toString(),
                                                          style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 2,
                                            thickness: 2,
                                            color: HexColor("#EFEFEF"),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 20),
                                            child: Html(data: data['note'] ??= ''),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            margin: EdgeInsets.only(top: 1, right: 10, left: 10),
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: ClipOval(
                                                            child: data['vendor_image'] != null
                                                                ? Image.network(
                                                                    data['vendor_image'],
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
                                                        )
                                                      ],
                                                    ),
                                                    sizedboxwidth(8.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          isVendor ? data['first_name'] + ' ' + data['last_name'] : data['vendor_name'],
                                                          style: TextStyle(fontSize: 14, color: HexColor("#1A1D1F")),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 10, right: 10),
                                                      alignment: Alignment.center,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          var res = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ScanQR(),
                                                              ));
                                                        },
                                                        child: const SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: Image(
                                                              image: AssetImage('assets/icons/bar.png'),
                                                            )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _launchUrl();
                                                      },
                                                      child: btnview1(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isVendor)
                                            Container(
                                              margin: EdgeInsets.only(top: 1, right: 10, left: 10),
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.asset("assets/icons/Icon- Date.png"),
                                                          )
                                                        ],
                                                      ),
                                                      sizedboxwidth(12.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text((data['time'] ??= '') + ", " + (data['date'] ??= ''), style: Theme.of(context).textTheme.headline6),
                                                          sizedboxheight(6.0),
                                                          Row(
                                                            children: [
                                                              Text('Schedule', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if ((isVendor && data['image'] != null) || (!isVendor && data['images'] != null))
                                            Container(
                                              height: 50,
                                              width: MediaQuery.of(context).size.width,
                                              margin: const EdgeInsets.symmetric(horizontal: 15),
                                              child: ListView.builder(
                                                  itemCount: isVendor ? data['image'].length : data['images'].length,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    var url = isVendor ? data['image'][index] : data['images'][index];
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => FullScreenImage(url: url),
                                                            ));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                                        child: SizedBox(
                                                          height: 40,
                                                          width: 70,
                                                          child: Image.network(
                                                            url,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: HexColor("#EFEEFF"),
                                              // borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: colorblack.withOpacity(0.1)),
                                              boxShadow: boxShadowcontainer(),
                                            ),
                                            margin: const EdgeInsets.only(top: 20, right: 40, left: 40),
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                sizedboxwidth(15.0),
                                                Text(
                                                  "Price : ",
                                                  style: TextStyle(fontSize: 25, fontWeight: fontWeight500),
                                                ),
                                                sizedboxwidth(5.0),
                                                Text(
                                                  data['order_amount'].toString(),
                                                  // "1800 ",
                                                  style: TextStyle(fontSize: 25, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    )
                  : Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 200),
                      child: const Text(
                        'No data found!!!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      )),
            ],
          ));
    } else if (selectAll == 2) {
      return RefreshIndicator(
        onRefresh: () async {
          await model.loadPendingProposalList(context);
        },
        child: (model.pendingList.length == 0 || (searchController.text.isNotEmpty && model.searchPendingPropasalList.length == 0))
            ? const Center(
                child: Text(
                  'No data found!!!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: searchController.text.isEmpty ? model.pendingList.length : model.searchPendingPropasalList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var data = searchController.text.isEmpty ? model.pendingList[index] : model.searchPendingPropasalList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15, right: 5, left: 5),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    width: deviceWidth(context, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipOval(
                                  child: data['thumbnail_image'] != null
                                      ? Image.network(
                                          data['thumbnail_image'],
                                          fit: BoxFit.cover,
                                        )
                                      : const Image(
                                          image: AssetImage('assets/images/Beauty.png'),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['product_name'].toString(), style: TextStyle(fontSize: 16, color: HexColor("#1A1D1F"), fontWeight: fontWeight600)),
                                sizedboxheight(4.0),
                                Row(
                                  children: [
                                    Text(data['order_id'].toString() == "null" ? "00/00 " : data['order_id'].toString(), style: TextStyle(fontSize: 14, color: HexColor("#6F767E"), fontWeight: fontWeight600)),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Text(data['time'].toString() == "null" ? "" : data['time'].toString(), style: TextStyle(fontSize: 14, color: HexColor("#6F767E"), fontWeight: fontWeight600)),
                                Text(data['date'].toString() == "null" ? "" : data['date'].toString(), style: TextStyle(fontSize: 14, color: HexColor("#6F767E"), fontWeight: fontWeight600)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Divider(
                            height: 1,
                            thickness: 2,
                            color: HexColor("#EFEFEF"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.zero,
                          child: Html(data: data['status'] == null ? (data['description'] ??= '') : (data['note'] ??= '')),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 40,
                                        height: 40,
                                        child: ClipOval(
                                          child: data['vendor_image'] != null
                                              ? Image.network(
                                                  data['vendor_image'],
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
                                      Text(
                                        isVendor
                                            ? data['first_name'] == "null"
                                                ? " "
                                                : data['first_name'] + data['last_name']
                                            : data['vendor_name'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: HexColor("#1A1D1F"),
                                          fontWeight: fontWeight600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final Uri _url = Uri.parse("tel://${data['phone']}");
                                      if (!await launchUrl(_url)) {
                                        throw Exception('Could not launch $_url');
                                      }
                                    },
                                    child: btnview1(),
                                  ),
                                ],
                              ),
                              sizedboxheight(10.0),
                              if ((data['status'] == null && data['image'] != null) || (data['status'] != null && data['images'] != null))
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: ListView.builder(
                                      itemCount: data['status'] == null ? data['image'].length : data['images'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index) {
                                        var url = data['status'] == null ? data['image'][index] : data['images'][index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FullScreenImage(url: data['image'][index]),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            child: Container(
                                              height: 50,
                                              width: 65,
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              sizedboxheight(10.0),
                              isVendor
                                  ? Container(
                                      child: data['schedule'] == null
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await model.rejectOrderVendor(context, data);
                                                    },
                                                    child: Container(
                                                      height: 45,
                                                      width: 150,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFEFEEFF)),
                                                      child: const Text(
                                                        'Reject',
                                                        style: TextStyle(color: Color(0xFF6759FF), fontSize: 20, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AddVendorQuoteScreen2(model: data),
                                                      ),
                                                    );

                                                    if (result != null) {
                                                      model.loadPendingProposalList(context);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: 140,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF6759FF)),
                                                    child: const Text(
                                                      '  Schedule Call',
                                                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : data['schedule'] == "0"
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AddVendorQuoteScreen(model: data),
                                                            ));
                                                      },
                                                      child: Container(
                                                        height: 45,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF6759FF)),
                                                        child: const Text(
                                                          ' Submit Quotation',
                                                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Searchpage(),
                                                            ));
                                                      },
                                                      child: Container(
                                                        height: 45,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF6759FF)),
                                                        child: const Text(
                                                          ' Submit Invoice',
                                                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const Center(
                                                  child: Text(
                                                  'Waiting for district Manager to accept proposal',
                                                  style: TextStyle(color: Colors.black),
                                                )))
                                  : data['schedule'] == "1"
                                      ? Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 1, right: 10, left: 10),
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.asset("assets/icons/Icon- Date.png"),
                                                          )
                                                        ],
                                                      ),
                                                      sizedboxwidth(12.0),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text((data['time'] ??= '8:00-9:00 AM') + ", " + (data['date'] ??= '09 Dec'), style: Theme.of(context).textTheme.headline6),
                                                          sizedboxheight(6.0),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  // model.astrologerListdb[index]['name'].toString(),
                                                                  data['order_id'].toString() == "null" ? "00/00" : data['order_id'].toString(),
                                                                  // 'AC ',
                                                                  style: TextStyle(fontSize: 14, color: HexColor("#6F767E"), fontWeight: fontWeight600)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: HexColor("#EFEEFF"),
                                                // borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: colorblack.withOpacity(0.1)),
                                                boxShadow: boxShadowcontainer(),
                                              ),
                                              margin: const EdgeInsets.only(top: 20, right: 40, left: 40),
                                              padding: const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  sizedboxwidth(15.0),
                                                  Text(
                                                    "Price : ",
                                                    style: TextStyle(fontSize: 25, fontWeight: fontWeight500),
                                                  ),
                                                  sizedboxwidth(5.0),
                                                  Text(
                                                    data['order_amount'].toString(),
                                                    style: TextStyle(fontSize: 25, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: InkWell(
                                                    onTap: () {
                                                      model.rejectOrderOwner(context, data);
                                                    },
                                                    child: Container(
                                                      height: 45,
                                                      width: 150,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFEFEEFF)),
                                                      child: const Text(
                                                        'Reject',
                                                        style: TextStyle(color: Color(0xFF6759FF), fontSize: 20, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    model.acceptOrderOwner(context, data);
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF6759FF)),
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      : const Center(
                                          child: Text(
                                          'Waiting for district Manager to accept proposal',
                                          style: TextStyle(color: Colors.black),
                                        )),
                              if (ismanager)
                                const Center(
                                    child: Text(
                                  'Waiting for vendor to accept proposal',
                                  style: TextStyle(color: Colors.black),
                                )),
                            ],
                          ),
                        ),
                        sizedboxheight(20.0)
                      ],
                    ),
                  );
                }),
      );
    } else {
      //History Proposal
      return RefreshIndicator(
        onRefresh: () async {
          await model.loadHistoryProposalList(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //height: MediaQuery.of(context).size.height,
          child: (model.historyList.length == 0 || (searchController.text.isNotEmpty && model.searchHistoryPropasalList.length == 0))
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 200),
                  child: Text(
                    'No data found!!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ))
              : ListView.builder(
                  itemCount: searchController.text.isEmpty ? model.historyList.length : model.searchHistoryPropasalList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    var data = searchController.text.isEmpty ? model.historyList[index] : model.searchHistoryPropasalList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 1, right: 10, left: 10),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: ClipOval(
                                                  child: data['thumbnail_image'] != null
                                                      ? Image.network(
                                                          data['thumbnail_image'],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset('assets/images/frame.png'),
                                                ),
                                              )
                                            ],
                                          ),
                                          sizedboxwidth(8.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data['product_name'], style: TextStyle(fontSize: 16, color: HexColor("#1A1D1F"), fontWeight: fontWeight400)),
                                              sizedboxheight(4.0),
                                              Row(
                                                children: [
                                                  Text(
                                                    data['date'].toString() == "null" ? "00/00" : data['date'].toString(),
                                                    style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            data['time'].toString() == "null" ? "00:00 AM" : data['time'].toString(),
                                            style: TextStyle(fontSize: 16, color: HexColor("#6F767E")),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: HexColor("#EFEFEF"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(child: Html(data: data['status'] == null ? (data['description'] ??= '') : (data['note'] ??= ''))),
                                Container(
                                  margin: EdgeInsets.only(top: 8, right: 10, left: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: ClipOval(
                                                  child: data['vendor_image'] != null
                                                      ? Image.network(
                                                          data['vendor_image'],
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (a, b, c) => const Image(
                                                            image: AssetImage('assets/images/frame.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Image(
                                                          image: AssetImage('assets/images/frame.png'),
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
                                              Text(isVendor ? data['first_name'] + ' ' + data['last_name'] : data['vendor_name'], style: TextStyle(fontSize: 17, color: HexColor("#1A1D1F"), fontWeight: fontWeight600)),
                                              sizedboxheight(6.0),
                                              Row(
                                                children: [
                                                  Text(data['order_id'], style: TextStyle(fontSize: 17, color: HexColor("#6F767E"))),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if ((data['status'] == null && data['image'] != null) || (data['status'] != null && data['images'] != null))
                                  Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(horizontal: 15),
                                    child: ListView.builder(
                                        itemCount: data['status'] == null ? data['image'].length : data['images'].length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          var url = data['status'] == null ? data['image'][index] : data['images'][index];
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => FullScreenImage(url: data['image'][index]),
                                                  ));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                              child: Container(
                                                height: 40,
                                                width: 60,
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if (data['status'] != null && data['status'] == "1")
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 1, right: 10, left: 10),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          borderRadius: BorderRadius.circular(15),
                                          // border: Border.all(color: colorblack.withOpacity(0.1)),
                                          // boxShadow: boxShadowcontainer(),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: Image.asset("assets/icons/Icon- Date.png"),
                                                    )
                                                  ],
                                                ),
                                                sizedboxwidth(12.0),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (data['time'] ??= '8:00-9:00 AM') + ", " + (data['date'] ??= '09 Dec'),
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                    sizedboxheight(6.0),
                                                    Row(
                                                      children: [
                                                        Text('Schedule', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: HexColor("#EFEEFF"),
                                          border: Border.all(color: colorblack.withOpacity(0.1)),
                                          boxShadow: boxShadowcontainer(),
                                        ),
                                        margin: EdgeInsets.only(top: 20, right: 40, left: 40),
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            sizedboxwidth(15.0),
                                            Text(
                                              "Price : ",
                                              style: TextStyle(fontSize: 25, fontWeight: fontWeight500),
                                            ),
                                            sizedboxwidth(5.0),
                                            Text(
                                              data['order_amount'].toString(),
                                              style: TextStyle(fontSize: 25, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      );
    }
  }

  Widget loginsearch112(context, model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: searchController,
        onSubmitted: (text) async {
          await model.loadSearchProposalList(context, searchController.text);
          await model.searchConfirmedProposalList(context, searchController.text);
          await model.searchPendingProposalList(context, searchController.text);
        },
        // obscureText: true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          filled: true, //<-- SEE HERE
          fillColor: HexColor("#F5F5F5"),
          hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Search Proposal',

          suffixIcon: TextButton(
            onPressed: () async {
              await model.loadSearchProposalList(context, searchController.text);
              await model.searchConfirmedProposalList(context, searchController.text);
              await model.searchPendingProposalList(context, searchController.text);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20),
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

Widget btnview1() {
  return InkWell(
    child: SizedBox(
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: HexColor("#6759FF"),
            border: Border.all(
              color: colorWhite,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.call,
              size: 18,
              color: colorWhite,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _launchUrl() async {
  final Uri _url = Uri.parse("tel://");
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
