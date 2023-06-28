import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/PDF/pdf.dart';
import 'package:service/BottamNavigation/dashboard/AllProduct/vendorlist.dart';
import 'package:service/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/button.dart';
import '../dashboardModelPage.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    Key? key,
    this.image,
    this.product_name,
    this.description,
    this.image1,
    this.vname,
    this.vimage,
    this.productId,
    this.vdata,
    this.brand,
  }) : super(key: key);

  final image;
  final image1;
  final product_name;
  final description;
  final vname;
  final vimage;
  final vdata;
  final productId;
  final brand;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String TAG = "_ProductDetailsState";

  bool JanuarySelect = false;
  List imageList = ["assets/images/ac.png", "assets/images/ac.png"];

  bool Dmanager = false;

  @override
  void initState() {
    super.initState();
    var list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(milliseconds: 600));

      await list.getProductDetails(context, widget.productId);
      await list.loadHistoryList(context, widget.productId);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();

      if (roleId == '3') {
        Dmanager = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardModelPage>(
        builder: (context, model, _) {
          return model.isShimmer
              ? const Center(child: CircularProgressIndicator(),)
              : Container(
                  color: HexColor("#F9F9F9"),
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          if (model.productDetails != null && model.productDetails['images'] != null && model.productDetails['images'].length > 0) sliderBuilder(context, model),
                          if (model.productDetails != null && (model.productDetails['images'] == null || model.productDetails['images'].length == 0))
                            Stack(
                              children: [
                                SizedBox(
                                  width: deviceWidth(context, 1.0),
                                  height: 170,
                                  child: const Center(
                                    child: Text(
                                      "No Images Available",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.topLeft,
                                  height: 20.0,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10, top: 0),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Stack(children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 200, right: 20, left: 20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        sizedboxwidth(5.0),
                                        Image.asset("assets/icons/tag.png", fit: BoxFit.contain),
                                        sizedboxwidth(10.0),
                                        widget.product_name == null
                                            ? Text(
                                                model.productDetails['product_name '].toString() == "null" ? "No data " : model.productDetails['product_name '].toString(),
                                                // model.astrologerListdb[index]['user_avability'].toString(),
                                                //' Air Conditioner',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: fontWeight600,
                                                ),
                                              )
                                            : Text(
                                                "${widget.product_name}",
                                                // model.astrologerListdb[index]['user_avability'].toString(),
                                                //' Air Conditioner',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: fontWeight600,
                                                ),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      if (Dmanager)
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Container(
                            child: buildSvgImageFromXml("${model.productDetails['qrcode']}"),
                          ),
                        ),
                      if (!Dmanager)
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                          padding: const EdgeInsets.all(5.0),
                          width: 300,
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: colorblack.withOpacity(0.1),
                            ),
                            boxShadow: boxShadowcontainer(),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ), // Set rounded corner radius
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    JanuarySelect = !JanuarySelect;
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset("assets/icons/tag.png", fit: BoxFit.contain),
                                                    sizedboxwidth(10.0),
                                                    Text(
                                                      // model.astrologerListdb[index]['user_avability'].toString(),
                                                      ' History',
                                                      // overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: fontWeight600,
                                                        color: HexColor("#1A1D1F"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 25,
                                                color: HexColor("#6759FF"),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  JanuarySelect = !JanuarySelect;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider(
                                  //   thickness: 1,
                                  // ),
                                  JanuarySelect
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            border: Border.all(
                                                color: colorWhite, // Set border color
                                                width: 1.0), // Set border width
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0),
                                            ), // Set rounded corner radius
                                          ),
                                          height: 220,
                                          child: ListView.builder(
                                              itemCount: model.historyList.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext context, int index) {
                                                var data = model.historyList[index];
                                                return Container(
                                                  padding: EdgeInsets.zero,
                                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(() => pdfpage(
                                                                tabIndex: 3,
                                                              ));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                SizedBox(
                                                                  width: 45,
                                                                  height: 45,
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
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10, bottom: 2),
                                                                      child: Text(
                                                                        data['vendor_name'],
                                                                        // 'Test Vendor',
                                                                        style: TextStyle(
                                                                          fontSize: 15,
                                                                          color: HexColor("#1A1D1F"),
                                                                          fontWeight: fontWeight600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 8, bottom: 2),
                                                                      child: Text(
                                                                        (data['time'] ??= '') + ', ' + (data['date'] ??= ''),
                                                                        //'8:00-9:00 AM,  09 Dec',
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: fontWeight500,
                                                                          color: HexColor("#6F767E"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //),
                                                      const Divider(
                                                        thickness: 2,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (Dmanager) Container(),
                      if (!Dmanager)
                        Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(20),
                          child: ListView.builder(
                            itemCount: 1,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    child: productll(
                                      "${widget.image}",
                                      "${widget.product_name}",
                                      widget.productId.toString(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget buildSvgImageFromXml(String xmlPath) {
    debugPrint("$TAG build Svg Image From Xml ============> $xmlPath");
    String svgCode = xmlPath.replaceAll("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");

    //String svgString = "<svg></svg>"; // Load your XML content
    return SvgPicture.string(
      svgCode,
      width: 300,
      height: 300,
    );
  }
}

Widget sliderBuilder(BuildContext context, DashboardModelPage model) {
  return model.productDetails["images"] != null
      ? CarouselSlider.builder(
          itemCount: model.productDetails['images'].length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            // final
            return SizedBox(
              width: deviceWidth(context, 1.0),
              height: 170,
              child: ClipRRect(
                borderRadius: borderRadiuscircular(5.0),
                child: CachedNetworkImage(
                  imageUrl: model.productDetails['images'][itemIndex],
                  placeholder: (context, url) => const Image(
                    image: AssetImage(
                      'assets/images/ac.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(
                      'assets/images/ac.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          carouselController: model.buttonCarouselController,
          options: CarouselOptions(
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              model.valueset(index);
            },
            scrollDirection: Axis.horizontal,
            viewportFraction: 0.8,
            aspectRatio: 16 / 7,
            initialPage: 0,
          ),
        )
      : SizedBox(
          width: deviceWidth(context, 1.0),
          height: 170,
          child: const Text(
            "No Images Available",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
}

Widget productll(String btnname, String productName, String productId) {
  return Button(
      buttonName: "Send Request",
      borderColor: HexColor("#F5F5F5"),
      btnHeight: 55.0,
      btnColor: HexColor("#6759FF"),
      textColor: colorWhite,
      btnfontsize: 20,
      borderRadius: BorderRadius.circular(10.0),
      onPressed: () {
        Get.to(
          () => Vendorlist(
            image: btnname,
            product_name: productName,
            CategoryPossList: [],
            productId: productId,
          ),
        );
      });
}
