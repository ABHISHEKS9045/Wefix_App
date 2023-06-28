import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../common/const.dart';
import 'PdfViewewPage.dart';
import 'invoicModelPage.dart';

class invoicDetailsPage extends StatefulWidget {
  invoicDetailsPage({
    Key? key,
    this.Id,
  }) : super(key: key);
  final Id;

  @override
  State<invoicDetailsPage> createState() => _invoicDetailsPageState();
}

class _invoicDetailsPageState extends State<invoicDetailsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(milliseconds: 1));
      final model = Provider.of<invoicModelPage>(context, listen: false);
      await model.InvoicelistingClick(context, widget.Id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<invoicModelPage>(builder: (context, model, _) {
      return Scaffold(
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
                  const Spacer(),
                  Text(
                    "Report Details",
                    style: TextStyle(fontSize: 20, color: HexColor("#484848"), fontWeight: fontWeight600),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(Id: model.invoicDetailsclicks[0]["id"].toString())));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: HexColor("#6759FF"),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.print,
                            color: Colors.white,
                            size: 20,
                          ),
                          sizedboxwidth(5.0),

                            Text(
                              "Print",
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: fontWeight600),

                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: model.is_loding,
            opacity: 0.7,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Invoice >> ",
                                    style: TextStyle(fontSize: 20, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                  ),
                                  sizedboxwidth(5.0),
                                  Text(
                                    "ID: ${model.orderId.toString()} ",
                                    style: TextStyle(fontSize: 20, fontWeight: fontWeight500, color: Colors.red),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 30,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              sizedboxheight(5.0),
                              Table(
                                  border: TableBorder.all(borderRadius: BorderRadius.circular(10), color: HexColor("#E5E5E5").withOpacity(1.0)), // Allows to add a border decoration around your table
                                  children: [
                                    TableRow(children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Maintenance Report",
                                                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: fontWeight500),
                                              ),
                                              sizedboxheight(1.0),
                                            ],
                                          )),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        child: Text(
                                          'Invoice',
                                          style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: fontWeight500),
                                        ),
                                      )
                                    ]),
                                    TableRow(children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.vendorName,
                                              style: TextStyle(fontSize: 15, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                            ),
                                            sizedboxheight(5.0),
                                            Text(
                                              model.address,
                                              style: TextStyle(fontSize: 15, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                            ),
                                            sizedboxheight(5.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.call,
                                                  size: 18,
                                                ),
                                                sizedboxwidth(5.0),
                                                Text(
                                                  model.phone,
                                                  style: TextStyle(fontSize: 16, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 15, bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "ID: ${model.orderId.toString()} ",
                                                    style: TextStyle(fontSize: 14, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 15, bottom: 15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Invoice Date: "
                                                    "${model.date}  ${model.invoicDetails[0]["time"]}",
                                                    style: TextStyle(fontSize: 14, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                                  ),
                                                  sizedboxheight(8.0),
                                                  Text(
                                                    'Status:${model.status}',
                                                    style: TextStyle(fontSize: 15, color: HexColor("#6B6B6B"), fontWeight: fontWeight600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ]),
                              sizedboxheight(20.0),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: colorblack.withOpacity(0.1)),
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
                                                  child: Image.network(
                                                            model.image.toString(),
                                                            fit: BoxFit.cover,
                                                          ) ==
                                                          null
                                                      ? const Image(
                                                          image: AssetImage('assets/images/Beauty.png'),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          model.image.toString(),
                                                          fit: BoxFit.cover,
                                                          // errorBuilder: (context, url,error) => Image(image: AssetImage('assets/images/ac.png'), fit: BoxFit.cover,),
                                                        )),
                                            )
                                          ],
                                        ),
                                        sizedboxwidth(12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.productname.toString(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                            sizedboxheight(6.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(5.0),
                                    sizedboxheight(10.0),
                                    Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Qty : ",
                                              style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                            ),
                                            Text(
                                              model.qty == null ? '00' : model.qty.toString(),
                                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Unit Price : ",
                                              style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                            ),
                                            Text(
                                              model.price == null ? "00" : model.price.toString(),
                                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Amount : ",
                                              style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                            ),
                                            Text(
                                              model.total == null ? "00" : model.total.toString(),
                                              style: const TextStyle(fontSize: 15, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 30,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    sizedboxheight(5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "SubTotal : ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          model.SubTotal == null ? "00" : model.SubTotal.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Track Charges : ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          model.trackcharge == null ? "00" : model.trackcharge.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Labour Charges: ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          model.labourcharge == null ? "00" : model.labourcharge.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Extra Charges : ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          model.extracharge == null ? "00" : model.extracharge.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tax : ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          model.tax == null ? "00" : model.tax.toString(),
                                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    sizedboxheight(10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Total Amount: ",
                                          style: TextStyle(fontSize: 18, fontWeight: fontWeight500),
                                        ),
                                        sizedboxwidth(5.0),
                                        Text(
                                          model.orderamount == null ? "00" : model.orderamount.toString(),
                                          style: TextStyle(fontSize: 18, color: HexColor("#1C1244")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }
}
