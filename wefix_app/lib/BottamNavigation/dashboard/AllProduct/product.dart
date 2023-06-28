import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/dashboard/AllProduct/productlist.dart';
import 'package:service/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboardModelPage.dart';

class ProductPage extends StatefulWidget {
  bool isForSearch = false;
  String searchText;
  ProductPage({super.key, required this.isForSearch, required this.searchText});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FocusNode node = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool isVendor = false;
  var list;
  @override
  void initState() {
    super.initState();
    list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      if (roleId == '1') {
        isVendor = true;
      }
      if (mounted) {
        if (!widget.isForSearch) {
          await list.loadDashboardProductList(context);
        } else if (widget.isForSearch && widget.searchText != '') {
          await list.loadSearchProductList(context, widget.searchText);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    list.searchProductList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModelPage>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: HexColor("#F9F9F9"),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            height: 55,
            color: colorWhite,
            child: productsearch(context, model),
          ),
        ),
        body:
        Consumer<DashboardModelPage>(
          builder: (context, model, _) {
            return RefreshIndicator(
                onRefresh: () async {
                  if (searchController.text.isEmpty) {
                    await model.loadDashboardProductList(context);
                  } else {
                    await model.loadSearchProductList(context, searchController.text);
                  }
                },
                child: model.isShimmer
                    ? Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            color: HexColor("#F9F9F9"),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          sizedboxwidth(5.0),
                                          Image.asset(
                                            "assets/icons/tag.png",
                                          ),
                                          sizedboxwidth(10.0),
                                          Text(
                                            widget.isForSearch ? " Recent Search " : " All Products",
                                            style: TextStyle(
                                              color: colorblack,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // btnviewd()
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                children: [
                                  (searchController.text.isNotEmpty && model.allProductList.isEmpty)
                                      ? Center(
                                          child: Text(
                                            'No product found!!',
                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : Expanded(
                                          child: GridView.builder(

                                            itemCount: model.allProductList.length,
                                            scrollDirection: Axis.vertical,
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 190),
                                            itemBuilder: (BuildContext context, int index) {
                                              var data = model.allProductList[index];
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0),
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (!isVendor) {
                                                      Get.to(
                                                        () => ProductDetails(
                                                          image: data['thumbnail_image'],
                                                          product_name: data['product_name'],
                                                          description: data['product_description'],
                                                          productId: data['id'],
                                                          brand: data['brand'],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(10), // Image border
                                                        child: SizedBox.fromSize(
                                                          size: const Size.fromRadius(69), // Image radius
                                                          child: data['thumbnail_image'] != null
                                                              ? Image.network(
                                                                  data['thumbnail_image'],
                                                                  fit: BoxFit.cover,
                                                                  errorBuilder: (context, url, error) => const Image(
                                                                    image: AssetImage('assets/images/ac.png'),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/ac.png',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                        ),
                                                      ),
                                                      sizedboxheight(10.0),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            data['product_name'],
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(color: HexColor("#252843"), fontSize: 17.0, fontWeight: fontWeight900),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
          },
        ),
      );
    });
  }


  Widget productsearch(context, model) {
    if (widget.isForSearch) {
      FocusScope.of(context).requestFocus(node);
    }
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 25,
          ),
        ),
        sizedboxwidth(10.0),
        Expanded(
            child: TextField(
          controller: searchController,
          onSubmitted: (search) async {
            await model.loadSearchProductList(context, searchController.text);
          },
          focusNode: node,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
            ),
            filled: true,
            fillColor: HexColor("#F5F5F5"),
            hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight500, color: HexColor("#D1D3D4")),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Search Product',
            suffixIcon: TextButton(
              onPressed: () async {
                await model.loadSearchProductList(context, searchController.text);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: 35,
                width: 35,
                child: Image.asset("assets/icons/searchgroup.png"),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
