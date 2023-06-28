import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../common/const.dart';

class Historypage extends StatefulWidget {
  const Historypage({Key? key, this.image, this.product_name, this.description}) : super(key: key);
  final image;
  final product_name;
  final description;

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#F9F9F9"),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            "${widget.image}",
                          ),
                          fit: BoxFit.cover)),
                  alignment: Alignment.topLeft,
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 20),
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
                      margin: const EdgeInsets.only(top: 200, right: 30, left: 30),
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              sizedboxwidth(5.0),
                              Image.asset("assets/icons/tag.png", fit: BoxFit.contain),
                              sizedboxwidth(10.0),
                              Text("${widget.product_name}",
                                  // model.astrologerListdb[index]['user_avability'].toString(),
                                  //' Air Conditioner',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 22, fontWeight: fontWeight600)),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          //  Text(""),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: colorblack,
                              ),
                              sizedboxwidth(5.0),
                              Text(
                                "Air Conditioning services we provide",
                                style: TextStyle(color: HexColor("#6F767E"), fontSize: 17, fontWeight: fontWeight500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: colorblack,
                              ),
                              sizedboxwidth(5.0),
                              Text(
                                "Ac Installation & Replacement",
                                style: TextStyle(color: HexColor("#6F767E"), fontSize: 17, fontWeight: fontWeight500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: colorblack,
                              ),
                              sizedboxwidth(5.0),
                              Text(
                                "AC Maintenance",
                                style: TextStyle(color: HexColor("#6F767E"), fontSize: 17, fontWeight: fontWeight500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: colorblack,
                              ),
                              sizedboxwidth(5.0),
                              Text(
                                "Ac Repaire",
                                style: TextStyle(color: HexColor("#6F767E"), fontSize: 17, fontWeight: fontWeight500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: colorblack,
                              ),
                              sizedboxwidth(5.0),
                              Text(
                                "Thermostat & Air Conditioner",
                                style: TextStyle(color: HexColor("#6F767E"), fontSize: 17, fontWeight: fontWeight500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "About this item\nSplit AC with Twin Cool Inverter compressor: Variable Speed Inverter Compressor which adjusts power depending on heat load. It is most energy efficient and has lowest-noise operation\nCapacity: 1.5 Ton - Suitable for medium sized rooms"
                            ,
                            style: TextStyle(color: HexColor("#6F767E"), fontSize: 15, fontWeight: fontWeight500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
