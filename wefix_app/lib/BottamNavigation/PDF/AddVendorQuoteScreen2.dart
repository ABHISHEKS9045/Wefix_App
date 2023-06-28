import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/PDF/pdfModelPage.dart';

import '../../common/const.dart';

class AddVendorQuoteScreen2 extends StatefulWidget {
  final model;

  const AddVendorQuoteScreen2({super.key, this.model});

  @override
  State<AddVendorQuoteScreen2> createState() => _AddVendorQuoteScreen2State();
}

class _AddVendorQuoteScreen2State extends State<AddVendorQuoteScreen2> {

  String selectedDate = '';
  String selectedTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PDFModelPage>(builder: (context, model, _) {
        return model.isShimmer
            ? Container(height: MediaQuery.of(context).size.height, alignment: Alignment.center, child: const CircularProgressIndicator())
            : Container(
                color: HexColor("#F9F9F9"),
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
                                      Text(
                                        widget.model['product_name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: fontWeight600,
                                        ),
                                      ),
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
                        children: [
                          Row(
                            children: [
                              sizedboxwidth(5.0),
                              Image.asset("assets/icons/tag.png"),
                              sizedboxwidth(10.0),
                              Text(
                                  // model.astrologerListdb[index]['user_avability'].toString(),
                                  'Select Date-Time',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20, fontWeight: fontWeight600)),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('dd MMM yy').format(pickedDate);
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
                              decoration: BoxDecoration(color: const Color(0xFFFFBC99), borderRadius: BorderRadius.circular(10)),
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
                        if (selectedTime == '') {
                          Fluttertoast.showToast(msg: 'Please select time');
                          return;
                        }
                        if (selectedDate == '') {
                          Fluttertoast.showToast(msg: 'Please select date');
                          return;
                        }
                        model.acceptOrderVendor11(context, widget.model, selectedDate, selectedTime);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: const Color(0xFF6759FF), borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          'Schedule ',
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
}
