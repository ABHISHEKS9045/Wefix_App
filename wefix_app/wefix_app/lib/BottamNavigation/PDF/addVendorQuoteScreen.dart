import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/PDF/pdfModelPage.dart';

import '../../common/const.dart';
import '../dashboard/AllProduct/vendorlist.dart';

class AddVendorQuoteScreen extends StatefulWidget {
  final model;

  AddVendorQuoteScreen({super.key, this.model});

  @override
  State<AddVendorQuoteScreen> createState() => _AddVendorQuoteScreenState();
}

class _AddVendorQuoteScreenState extends State<AddVendorQuoteScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<String>? imageSource;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String selectedDate = '';
  String selectedTime = '';

  final imgPicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PDFModelPage>(builder: (context, model, _) {
        return model.isShimmer
            ? Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: colorTheme,
                ))
            : Container(
                color: HexColor("#F9F9F9"),
                // color: Colors.grey.withOpacity(0.5),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(image: DecorationImage(image: widget.model['thumbnail_image'] != null ? NetworkImage(widget.model['thumbnail_image']) : const AssetImage('assets/iamges/Beauty.png') as ImageProvider, fit: BoxFit.cover)),
                          alignment: Alignment.topLeft,
                          height: 250.0,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, top: 20),
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
                        Stack(children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 220, right: 30, left: 30),
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      sizedboxwidth(5.0),
                                      Image.asset("assets/icons/tag.png"),
                                      sizedboxwidth(10.0),
                                      Text(widget.model['product_name'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25, fontWeight: fontWeight600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 20),
                      padding: const EdgeInsets.all(10.0),
                      width: 300,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: colorblack.withOpacity(0.1)),
                        boxShadow: boxShadowcontainer(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              sizedboxwidth(5.0),
                              Image.asset("assets/icons/tag.png"),
                              sizedboxwidth(10.0),
                              Text('Note', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: fontWeight600)),
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
                                                              color: colorTheme,
                                                              onPressed: () {

                                                                selectImages();
                                                              },
                                                              child: const Text("Open Gallery"),
                                                            ),
                                                            sizedboxheight(5.0),
                                                            CupertinoButton(
                                                              color: colorTheme,
                                                              onPressed: () {
                                                                openCamera();
                                                              },
                                                              child: const Text("Open Camera"),
                                                            ),
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
                                                ),),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              buildTextField(noteController),
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
                                            ));
                                      }),
                                )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Price', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: fontWeight600)),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            height: 50,
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusColor: HexColor("#6759FF"),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: HexColor("#EFEFEF"),
                                    width: 1,
                                  ),
                                ),

                                filled: true,
                                //<-- SEE HERE
                                fillColor: HexColor("#F5F5F5"),
                                hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Enter Price ',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 20),
                      padding: const EdgeInsets.all(10.0),
                      width: 300,
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
                              Text('Select Date-Time', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: fontWeight600,),),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100),);
                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  selectedDate = formattedDate; //set output date to TextField value.
                                });
                              }
                            },
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(color: const Color(0xFFFFBC99), borderRadius: BorderRadius.circular(10),),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'DATE',
                                        style: TextStyle(fontSize: 17, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        selectedDate != '' ? selectedDate : 'Select Your Date',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context, //context of current state
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  selectedTime = pickedTime.format(context);
                                });
                              }
                            },
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(color: const Color(0xFFB5E4CA), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'TIME',
                                        style: TextStyle(fontSize: 17, color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        selectedTime != '' ? selectedTime : 'Select Your Time',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (priceController.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Please fill price..');
                          return;
                        }
                        if (selectedTime == '') {
                          Fluttertoast.showToast(msg: 'Please select time..');
                          return;
                        }
                        if (selectedDate == '') {
                          Fluttertoast.showToast(msg: 'Please select date..');
                          return;
                        }

                        model.acceptOrderVendor(context, widget.model, noteController.text, priceController.text, selectedDate, selectedTime, imageFileList);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: const Color(0xFF6759FF), borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          'Proposal Submit ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
      }),
    );
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
    Navigator.of(context).pop();

  }

  void openCamera() async {
    imageFileList?.clear();
    XFile? selectedImages = (await imagePicker.pickImage(source: ImageSource.camera))!;
    imageFileList?.add(selectedImages!);
    print(imageFileList!.length);
    Navigator.of(context).pop();
  }
}
