import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/common/const.dart';
import 'invoicDetailsPage.dart';
import 'invoicModelPage.dart';

class Searchpage extends StatefulWidget {
  Searchpage({
    super.key,
  });

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(milliseconds: 1));
      final model = Provider.of<invoicModelPage>(context, listen: false);
      await model.InvoiceListing(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<invoicModelPage>(builder: (context, model, _) {
      return SafeArea(
          child: Scaffold(
        backgroundColor: HexColor("#F9F9F9"),
        body: ModalProgressHUD(
          inAsyncCall: model.is_loding,
          opacity: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 10, top: 18),

                // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        sizedboxwidth(5.0),
                        Image.asset("assets/icons/tag.png"),
                        sizedboxwidth(10.0),
                        Text(
                            // model.astrologerListdb[index]['user_avability'].toString(),
                            "Report",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 25, fontWeight: fontWeight600)),
                      ],
                    ),
                  ],
                ),
              ),
              sizedboxheight(10.0),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                            itemCount: model.invoicDetails.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              var data = model.invoicDetails[index];
                              return InkWell(
                                  onTap: () {
                                    print("invoce Id${data['id']}");

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => invoicDetailsPage(
                                            Id: data['id'],
                                          ),
                                        ));
                                    // model.acceptOrderVendor(context,data);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                            padding: EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child: ClipOval(
                                                                child: Image.network(
                                                                  data['thumbnail_image'] != 'null' ? data['thumbnail_image'] : "http://209.97.156.170:7071/uploads/pictures/istockphoto-1447607402.jpg",
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            sizedboxwidth(10.0),
                                                            Text(
                                                              data['product_name'],
                                                              style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                                            ),
                                                            sizedboxwidth(5.0),
                                                            const Spacer(),
                                                            Text(
                                                              // data['order_amount'].toString(),
                                                              "Date : ${data["date"]}",
                                                              style: TextStyle(fontSize: 15, color: HexColor("#1C1244")),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          "Order_id : ${data['order_id']}",
                                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  height: 10,
                                                  thickness: 1,
                                                  color: HexColor("#DEDDDD"),
                                                ),
                                                Container(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 10, left: 10),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: ClipOval(
                                                            child: Image.network(
                                                              data['owner_image'].toString() != 'null' ? data['owner_image'].toString() : "http://209.97.156.170:7071/uploads/pictures/istockphoto-1447607402.jpg",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        sizedboxwidth(10.0),
                                                        Text(
                                                            // model.astrologerListdb[index]['name'].toString(),
                                                            data['vendor_name'],
                                                            style: TextStyle(fontWeight: fontWeight500, fontSize: 18, color: HexColor("#1A1D1F"))),
                                                        const Spacer(),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                          decoration: BoxDecoration(
                                                            color: HexColor("#6759FF"),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Text(
                                                              // model.astrologerListdb[index]['name'].toString(),
                                                              data['order_status'],
                                                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: fontWeight500)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            alignment: Alignment.center,
                                            child: Text(
                                              " Amount : ${data['order_amount'].toString()}",
                                              style: TextStyle(fontSize: 20, color: HexColor("#1A1D1F")),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }) !=
                        null
                    ? ListView.builder(
                        itemCount: model.invoicDetails.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          var data = model.invoicDetails[index];
                          return InkWell(
                            onTap: () {
                              print("invoce Id${data['id']}");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => invoicDetailsPage(
                                      Id: data['id'],
                                    ),
                                  ));
                              // model.acceptOrderVendor(context,data);
                            },
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  width: deviceWidth(context),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Image.network(
                                              data['thumbnail_image'] != 'null' ? data['thumbnail_image'] : "http://209.97.156.170:7071/uploads/pictures/istockphoto-1447607402.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data['product_name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Date : ${data["date"]}",
                                              style: TextStyle(fontSize: 12, color: HexColor("#1C1244")),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "Order_id : ${data['order_id']}",
                                          style: TextStyle(fontSize: 12, fontWeight: fontWeight500),
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      ListTile(
                                        leading: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: ClipOval(
                                            child: Image.network(
                                              data['vendor_image'].toString() != 'null' ? data['vendor_image'].toString() : "http://209.97.156.170:7071/uploads/pictures/istockphoto-1447607402.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              data['vendor_name'],
                                              style: TextStyle(fontSize: 18, fontWeight: fontWeight500),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                              decoration: BoxDecoration(
                                                color: HexColor("#6759FF"),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                  // model.astrologerListdb[index]['name'].toString(),
                                                  data['order_status'],
                                                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: fontWeight500)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          " Amount : ${data['order_amount'].toString()}",
                                          style: TextStyle(fontSize: 20, color: HexColor("#1A1D1F")),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : const Center(
                        child: Text(
                          "No data Found!!",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
              ))
            ],
          ),
        ),
      ));
    });
  }
}
