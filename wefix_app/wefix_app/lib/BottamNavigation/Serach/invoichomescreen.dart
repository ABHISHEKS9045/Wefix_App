import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:service/common/const.dart';

import '../../DataApi/constant_apiUrl.dart';
import '../apiErrorAlertdialog.dart';
import 'invoicModelPage.dart';

class InvoicHomescreen extends StatefulWidget {
  @override
  State<InvoicHomescreen> createState() => _InvoicHomescreenState();
}

class _InvoicHomescreenState extends State<InvoicHomescreen> {



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = Provider.of<invoicModelPage>(context, listen: false);
      await model.InvoiceListing(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<invoicModelPage>(builder: (context, model, _) {
      return
          Scaffold(
            backgroundColor: HexColor("#F9F9F9"),
            appBar: AppBar(
              title: Row(
                children: [
                  sizedboxwidth(5.0),
                  Image.asset("assets/icons/tag.png"),
                  sizedboxwidth(10.0),
                  Text("Invoices", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25, fontWeight: fontWeight400,color: Colors.black)),
                ],
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: model.is_loding,
              opacity: 0.7, progressIndicator: CircularProgressIndicator(
              color: colorTheme,
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              sizedboxheight(10.0),
              model.invoicDetails.isEmpty ? Expanded(child: noDataFound(context)):
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: model.invoicDetails ==null ?
                      Center(child: Text("No data ",
                          style: TextStyle(fontSize: 27 ,color: colorTheme)),) :
                      ListView.builder(
                          itemCount: model.invoicDetails.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            var data = model.invoicDetails[index];
                            return
                              InkWell(
                              onTap: () {
                                debugPrint("invoce Id${data['id']}");
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Order id : ",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500, color: HexColor("#1A1D1F")),
                                        ),
                                        sizedboxwidth(5.0),
                                        Text(
                                          data['order_id'],
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500, color: HexColor("#6759FF")),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () async {
                                            model.showLoader();
                                            // Fluttertoast.showToast(msg: "File is saved to download folder.");

                                            PermissionStatus mediaPermissionStatus = await Permission.mediaLibrary.status;


                                            if (mediaPermissionStatus.isGranted) {
                                              var dir = await DownloadsPathProvider.downloadsDirectory;
                                              if (dir != null) {
                                                String savename = "${data['order_id']}.pdf";
                                                String savePath = dir.path + "/$savename";


                                                // String savePath = dir.path ;
                                                print(savePath);

                                                try {
                                                  await Dio().download("${baseUrl}/owner/click_invoice?id=${data['id']}", savePath, onReceiveProgress: (received, total) {
                                                    if (total != -1) {
                                                      print((received / total * 100).toStringAsFixed(0) + "%");
                                                    }
                                                  });
                                                  Fluttertoast.showToast(msg: "File is saved to download folder.");
                                                  model.hideLoader();
                                                } on DioError catch (e) {
                                                  print(e.message);
                                                }
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: "No permission to read and write.");

                                              print("No permission to read and write.");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: HexColor("#6759FF"),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    "Invoice",
                                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: fontWeight600),
                                                  ),
                                                ),
                                                sizedboxwidth(5.0),
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Image.asset(
                                                    'assets/images/saves.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date: ${data["date"]}",
                                          style: TextStyle(fontSize: 15, fontWeight: fontWeight500, color: HexColor("#6F767E")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })))
            ],
          ),
        ),
      );
    });
  }
}

Widget searchpages(context) {
  return InkWell(
    onTap: () {},
    child: Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: TextField(
        enabled: true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorTheme, width: 2),
          ),

          filled: true, //<-- SEE HERE
          fillColor: HexColor("#F5F5F5"),
          hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Search Invoice',
          suffixIcon: TextButton(
            onPressed: () {},
            child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: 35,
                width: 35,
                child: Icon(
                  Icons.search,
                  size: 25,
                  color: colorblack,
                )),
          ),
        ),
      ),
    ),
  );
}
