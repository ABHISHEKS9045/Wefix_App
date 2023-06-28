import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/dashboard/AllProduct/productlist.dart';
import 'package:service/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/button.dart';
import '../../PDF/pdf.dart';
import '../dashboardModelPage.dart';

class Vendorlist extends StatefulWidget {
  Vendorlist({super.key, this.image, this.product_name, this.productId, this.description, required List<dynamic> CategoryPossList});

  final image;
  final product_name;
  final description;
  final productId;

  @override
  State<Vendorlist> createState() => _VendorlistState();
}

class _VendorlistState extends State<Vendorlist> {
  int selectedVendorIndex = 0;
  var imageSource = '';
  List imageList = ["assets/images/frame.png", "assets/images/frame.png"];

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  final TextEditingController descriptionCont = TextEditingController();

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    // else {
    //   imageFileList!.addAll(selectedImages1 as Iterable<XFile>);
    // }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }

  void selectImages1() async {
    if (imageSource == 'gallery') {
      var images = (await imagePicker.pickImage(source: ImageSource.gallery))!;
    } else {
      var images = (await imagePicker.pickImage(source: ImageSource.camera))!;
    }
  }

  void openCamera() async {
    imageFileList?.clear();
    XFile? selectedImages = (await imagePicker.pickImage(source: ImageSource.camera))!;
    imageFileList?.add(selectedImages!);
    print(imageFileList!.length);
    Navigator.of(context).pop();
  }
  TextEditingController searchController = new TextEditingController();

  void initState() {
    super.initState();
    var list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(milliseconds: 600));
      await list.loadVendorList(context, widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardModelPage>(builder: (context, model, _) {
        return Container(
          color: HexColor("#F9F9F9"),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (model.productDetails['images'] != null && model.productDetails['images'].length > 0) sliderBuilder(context, model),
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 20),
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            sizedboxwidth(5.0),
                            Image.asset("assets/icons/tag.png"),
                            sizedboxwidth(10.0),
                            Text(
                                "${widget.product_name}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 25, fontWeight: fontWeight600)),
                          ],
                        ),

                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 20),
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: colorblack.withOpacity(0.1)),
                      boxShadow: boxShadowcontainer(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            sizedboxwidth(5.0),
                            Image.asset("assets/icons/tag.png"),
                            sizedboxwidth(10.0),
                            Text(
                                // model.astrologerListdb[index]['user_avability'].toString(),
                                'Note',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20, fontWeight: fontWeight600)),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10, right: 10, left: 10),
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                // color: HexColor("#F9F9F9"),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: colorblack.withOpacity(0.1)),
                                boxShadow: boxShadowcontainer(),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                    height: 23,
                                    child: ClipOval(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/light.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                    height: 23,
                                    child: ClipOval(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/filled.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                    height: 23,
                                    child: ClipOval(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/underline.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  sizedboxwidth(5.0),
                                  Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                backgroundColor: Colors.transparent,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(builder: (context, StateSetter setState) {
                                                    return Container(
                                                      height: 150,
                                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          CupertinoButton(
                                                            color: colorpinklight,
                                                            onPressed: () {
                                                              selectImages();
                                                            },
                                                            child: const Text("Open Gallery"), // onPressed: () {
                                                          ),
                                                          sizedboxheight(5.0),
                                                          CupertinoButton(
                                                              color: colorpinklight,
                                                              child: const Text("Open Camera"),
                                                              onPressed: () {
                                                                openCamera();
                                                              })
                                                        ],
                                                      ),
                                                    );
                                                  });
                                                });
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: boxShadowcontainer(),
                                              ),
                                              alignment: Alignment.center,
                                              child: const SizedBox(
                                                width: 30,
                                                height: 23,
                                                child: ClipOval(
                                                  child: Image(
                                                    image: AssetImage(
                                                      'assets/icons/Upload icon.png',
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            buildTextField(descriptionCont),
                            const SizedBox(
                              height: 10,
                            ),
                            if (imageFileList!.isNotEmpty)
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                    itemCount: imageFileList!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        height: 70,
                                        width: 70,
                                        child: Image.file(
                                          File(imageFileList![index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                              ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 20),
                    padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: colorblack.withOpacity(0.1)),
                      boxShadow: boxShadowcontainer(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            sizedboxwidth(5.0),
                            Image.asset("assets/icons/tag.png"),
                            sizedboxwidth(10.0),
                            Text(
                                // model.astrologerListdb[index]['user_avability'].toString(),
                                'Select Vendor',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20, fontWeight: fontWeight600)),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        // searchHistry(context),
                        productsearch(context, model, widget.productId, searchController),
                        model.isShimmer
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : (model.vendorList.isNotEmpty
                                ? Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      border: Border.all(
                                          color: colorWhite, // Set border color
                                          width: 1.0), // Set border width
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)), // Set rounded corner radius
                                    ),
                                    height: 200,
                                    child: ListView.builder(
                                        itemCount: model.vendorList.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: ClipOval(
                                                            child: model.vendorList[index]['image'] == null
                                                                ? Image.asset('assets/images/frame.png')
                                                                : Image.network(
                                                                    //  "http://209.97.156.170/WeFix/public//images/products/202301191227iPhon.jpg"
                                                                    model.vendorList[index]['image'],
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, url, error) => const Image(image: AssetImage('assets/images/frame.png'), fit: BoxFit.cover),
                                                                  )),
                                                      )
                                                    ],
                                                  ),
                                                  sizedboxwidth(8.0),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                              //model.astrologerListdb[index]['name'].toString(),
                                                              model.vendorList[index]['first_name'] + " " + model.vendorList[index]['last_name'],
                                                              //'Vendor Name',
                                                              style: TextStyle(fontSize: 18, color: HexColor("#1A1D1F"), fontWeight: fontWeight600)),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.centerRight,
                                                      margin: const EdgeInsets.only(left: 30, right: 20),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedVendorIndex = index;
                                                          });
                                                        },
                                                        child: selectedVendorIndex != index
                                                            ? const Icon(Icons.radio_button_off)
                                                            : Icon(
                                                                Icons.radio_button_on,
                                                                color: HexColor("#6759FF"),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 2,
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                : const Text('No vendor found!!')),
                      ],
                    ),
                  ),
                  if (model.vendorList.isNotEmpty)
                    InkWell(
                      onTap: () {
                        Get.to(() => pdfpage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: vendorlist(context, model, descriptionCont, model.vendorList[selectedVendorIndex]['id'].toString(), model.vendorList[selectedVendorIndex]['first_name'] + " " + model.vendorList[selectedVendorIndex]['last_name'], imageFileList, widget.productId),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Widget vendorlist(BuildContext context, model, TextEditingController controller, venderId, venderName, image, productId) {
  return Button(
    buttonName: "Submit",
    btnHeight: 45.0,
    btnColor: colorpinklight,
    textColor: Colors.white,
    btnfontsize: 16,
    btnWidth: 163.0,
    borderRadius: BorderRadius.circular(10.0),
    onPressed: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ownerId = prefs.getString('owner_id');

      if (controller.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter description');
      } else if (venderId == '') {
        Fluttertoast.showToast(msg: 'Please select vendor');
      } else if (image.length == 0) {
        Fluttertoast.showToast(msg: 'Please select image');
      } else {
        await model.addOrder(context, ownerId!, productId, controller.text, venderId.toString(), venderName, image);
      }
    },
  );
}

Widget productsearch(context, model, productId, searchController) {
  return Padding(
    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
    child: TextField(
      controller: searchController,
      onSubmitted: (text) async {
        await model.searchVendorList(context, productId, searchController.text);
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
        ),

        filled: true,
        fillColor: HexColor("#F5F5F5"),
        hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        hintText: 'Search Vendor',

        suffixIcon: TextButton(
          onPressed: () async {
            await model.searchVendorList(context, productId, searchController.text);
          },
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

Widget buildTextField(textController) {
  return Container(
    child: TextField(
      maxLines: 5,
      controller: textController,
      decoration: InputDecoration(
        focusColor: HexColor("#6759FF"),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("#EFEFEF"),
            width: 1,
          ),
        ),

        filled: true,
        fillColor: HexColor("#F5F5F5"),
        hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Enter Your ',
      ),
    ),
  );
}
