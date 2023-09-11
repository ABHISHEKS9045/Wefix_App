import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/PDF/pdf.dart';
import 'package:service/BottamNavigation/PDF/pdfModelPage.dart';
import 'package:service/BottamNavigation/apiErrorAlertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/const.dart';
import '../Serach/Searchpage.dart';
import 'AddVendorQuoteScreen2.dart';
import 'addVendorQuoteScreen.dart';
import 'fullScreenImage.dart';

class PaindingData extends StatefulWidget {
  const PaindingData({Key? key}) : super(key: key);

  @override
  State<PaindingData> createState() => _PaindingDataState();
}

class _PaindingDataState extends State<PaindingData> {
  bool isVendor = false;
  bool ismanager = false;
  int selectAll = 2;

  @override
  void initState() {
    super.initState();

    var list = Provider.of<PDFModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      if (roleId == '1') isVendor = true;
      if (roleId == '3') ismanager = true;

      await list.loadProposalCount(context);
      await list.loadProposalCountp(context);
      await list.loadConfirmedProposalList(context);
      await list.loadHistoryProposalList(context);
      await list.loadPendingProposalList(context);
    });
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PDFModelPage>(
      builder: (context, model, _) {
        return Scaffold(
            backgroundColor: HexColor("#F9F9F9"),
            appBar: AppBar(
              title: Container(
                color: colorWhite,
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 20,
                ),
                height: 48,
                child: Row(
                  children: [
                    Text(
                      "Pending Request ",
                      style: TextStyle(fontSize: 20, color: HexColor("#484848"), fontWeight: fontWeight600),
                    ),
                  ],
                ),
              ),
            ),
            body: ModalProgressHUD(
                inAsyncCall: model.is_loding,
                opacity: 0.7,
                child: RefreshIndicator(
                  color: colorTheme,
                  onRefresh: () async {
                    await model.loadPendingProposalList(context);
                  },
                  child: (model.pendingList.length == 0 || (searchController.text.isNotEmpty && model.searchPendingPropasalList.length == 0))
                      ? noDataFound(context)
                      :ListView.builder(
                      itemCount: searchController.text.isEmpty ? model.pendingList.length : model.searchPendingPropasalList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        var data = searchController.text.isEmpty ? model.pendingList[index] : model.searchPendingPropasalList[index];
                        return
                          Container(
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
                                          child: Image.network(
                                            data['thumbnail_image'].toString(),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Image(
                                                image: AssetImage('assets/images/wefix_logo.png'),
                                                fit: BoxFit.cover,
                                              );
                                            },
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
                                  margin: const EdgeInsets.only(top: 5),
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
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                width: 40,
                                                height: 40,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    data['vendor_image'].toString(),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (a, b, c) => const Image(
                                                      image: AssetImage('assets/images/empty_user.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                isVendor
                                                    ? data['first_name'] == "null"
                                                    ? " "
                                                    : "${data['first_name']} ${data['last_name']}"
                                                    : data['vendor_name'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: HexColor("#1A1D1F"),
                                                  fontWeight: fontWeight600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(data['schedule'] == "0")
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
                                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                                            ],
                                          )
                                              : const Center(
                                              child: Text(
                                                'Please wait for district manager to accept proposal.',
                                                style: TextStyle(color: Colors.black),
                                              )))
                                          : ismanager
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
                                                        Text((data['time'] ??= '8:00-9:00 AM') + "" + (data['date'] ??= '09 Dec'), style: Theme.of(context).textTheme.headline6),
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
                                            'Please wait for vendor to accept proposal.',
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

                )));
      },
    );
  }
}

Future<void> number(String number) async {
  final Uri _url = Uri.parse("tel://$number");
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
