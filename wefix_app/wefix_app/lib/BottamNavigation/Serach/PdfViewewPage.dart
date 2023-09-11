import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../DataApi/constant_apiUrl.dart';
import '../../common/const.dart';
import '../bottom_navigationmodelpage.dart';
import '../bottom_navigationpage.dart';
import 'invoicModelPage.dart';
class PdfViewerPage extends StatefulWidget {
  PdfViewerPage({super.key, this.Id, this.invoiceId});
  final Id;
  final invoiceId;
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}
class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;
  bool isLoading = false;
  var downloadurl = "";
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    downloadurl = "${baseUrl}/owner/click_invoice?id=${widget.Id}";
    print("downloadurl: $downloadurl");

    final response = await http.get(Uri.parse(downloadurl));
    final bytes = response.bodyBytes;
    final filename = basename(downloadurl);
    print("downloadurl: $downloadurl\nfilename: $filename");
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(milliseconds: 1));
      final model = Provider.of<invoicModelPage>(context as BuildContext, listen: false);
      await model.InvoicelistingClick(context, widget.Id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Consumer<invoicModelPage>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              " PDF Download",
              style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.black),
            ),
            actions: [
              InkWell(
                onTap: () async {
                  model.showLoader();

                  PermissionStatus mediaPermissionStatus = await Permission.mediaLibrary.status;
                  model.hideLoader();



                  if (mediaPermissionStatus.isGranted) {
                    var dir = await DownloadsPathProvider.downloadsDirectory;
                    if (dir != null) {
                      String savename = "${widget.invoiceId}.pdf";
                      String savePath = dir.path + "/$savename";

                      // print(savePath);

                      try {
                        await Dio().download("${baseUrl}/owner/click_invoice?id=${widget.Id}", savePath, onReceiveProgress: (received, total) {
                          if (total != -1) {
                            print((received / total * 100).toStringAsFixed(0) + "%");
                          }
                        });
                        Fluttertoast.showToast(msg: "File is saved to download folder.");
                        Provider.of<BottomnavbarModelPage>(context, listen: false).togglebottomindexreset();
                        Get.off(BottomNavBarPage());
                      } on DioError catch (e) {
                        Fluttertoast.showToast(msg: e.message);
                        print(e.message);
                      }
                    }
                  } else {
                    print("No permission to read and write.");
                    Fluttertoast.showToast(msg:"No permission to read and write.");

                  }
                },

                child: Container(
                  padding: EdgeInsets.all(10),

                  child:Icon(Icons.cloud_download,color: colorTheme,size: 30,)
                ),
              ),
            ],

          ),
          body:

          ModalProgressHUD(
            inAsyncCall: model.is_loding,
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(
              color: colorTheme,
            ),
            child: model.invoicDetailsclicks == null ? const CircularProgressIndicator(



            ):
            Column(
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
                                    "Invoice ID :",
                                    style: TextStyle(fontSize: 20, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                  ),
                                  sizedboxwidth(5.0),
                                  Text(
                                    "${model.invoicDetailsclicks['order_id'].toString()} ",
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
                                              "${model.invoicDetailsclicks['first_name'].toString()} ${model.invoicDetailsclicks['last_name'].toString()}",
                                              style: TextStyle(fontSize: 15, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                            ),
                                            sizedboxheight(5.0),
                                            Text(
                                              model.invoicDetailsclicks['address'].toString()
                                                  !='null' ?  model.invoicDetailsclicks['address'].toString(): 'address',
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
                                                  model.invoicDetailsclicks['phone'].toString(),
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
                                                    "ID: ${ model.invoicDetailsclicks['order_id'].toString()} ",
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
                                                    " Date: "
                                                        "${model.invoicDetailsclicks['date'].toString()} ",
                                                    style: TextStyle(fontSize: 14, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                                  ),
                                                  sizedboxheight(8.0),
                                                  Text(

                                                    " Time: "  " ${model.invoicDetailsclicks['time'].toString() }",
                                                    style: TextStyle(fontSize: 14, color: HexColor("#6B6B6B"), fontWeight: fontWeight500),
                                                  ),
                                                  // sizedboxheight(8.0),
                                                  // Text(
                                                  //   'Status:  ${model.invoicDetailsclicks['payment_status'].toString()} ',
                                                  //   style: TextStyle(fontSize: 15, color: HexColor("#6B6B6B"), fontWeight: fontWeight600),
                                                  // ),
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
                                                  model.invoicDetailsclicks['thumbnail_image'].toString(),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/wefix_logo.png');
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        sizedboxwidth(12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.invoicDetailsclicks['product_name'],
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Qty : ${model.invoicDetailsclicks['qty'].toString() == "null" ? '00' : model.invoicDetailsclicks['qty'].toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 15, color: Colors.black),
                                        ),
                                        sizedboxwidth(5.0),

                                        Text(
                                          "Unit Price : ${model.invoicDetailsclicks['price'].toString()== null ? "00" :   model.invoicDetailsclicks['price'].toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        ),
                                        sizedboxwidth(10.0),
                                        Text(
                                          "Amount : ${ model.invoicDetailsclicks['sub_total'].toString()== null ? "00" :   model.invoicDetailsclicks['sub_total'].toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500),
                                        )
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
                                          model.invoicDetailsclicks['sub_total'].toString() == null ? "00" : model.invoicDetailsclicks['sub_total'].toString(),
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
                                          model.invoicDetailsclicks['track_charge'].toString() == "null" ? "00" : model.invoicDetailsclicks['track_charge'].toString(),
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
                                          model.invoicDetailsclicks['labour_charge'].toString() == "null" ? "00" : model.invoicDetailsclicks['labour_charge'].toString(),
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
                                          model.invoicDetailsclicks['extra_charge'].toString() == "null" ? "00" :   model.invoicDetailsclicks['extra_charge'].toString(),
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
                                          model.invoicDetailsclicks['tax'].toString() == "null" ? "00" : model.invoicDetailsclicks['tax'].toString(),
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
                                          model.invoicDetailsclicks['total'].toString() == "null" ? "00" : model.invoicDetailsclicks['total'].toString(),
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
          
          )
      );
    });
  }
}

