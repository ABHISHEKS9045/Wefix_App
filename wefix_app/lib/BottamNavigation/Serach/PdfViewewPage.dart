import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../common/const.dart';
import 'invoicModelPage.dart';

class PdfViewerPage extends StatefulWidget {
  PdfViewerPage({super.key, this.Id});
  final Id;
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = 'http://209.97.156.170/wefix_stagging/api/generate-invoice/${widget.Id}';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
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
    return Consumer<invoicModelPage>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              " PDF Viewer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,

                            //add more permission to request here.
                          ].request();

                          if (statuses[Permission.storage]!.isGranted) {
                            var dir = await DownloadsPathProvider.downloadsDirectory;
                            if (dir != null) {
                              String savename = "Save.pdf";
                              String savePath = dir.path + "/$savename";
                              print(savePath);
                              //output:  /storage/emulated/0/Download/banner.png

                              try {
                                await Dio().download("http://209.97.156.170/wefix_stagging/generate-invoice/${model.invoicDetailsclicks[0]['id']}", savePath, onReceiveProgress: (received, total) {
                                  if (total != -1) {
                                    print((received / total * 100).toStringAsFixed(0) + "%");
                                    //you can build progressbar feature too
                                  }
                                });
                                Fluttertoast.showToast(msg: "File is saved to download folder.");
                              } on DioError catch (e) {
                                print(e.message);
                              }
                            }
                          } else {
                            print("No permission to read and write.");
                          }
                        },
                        child: Container(
                          width: 130,
                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                            color: HexColor("#6759FF"),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                            // boxShadow: boxShadowcontainer(),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Text(
                                  "Download",
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

                      Expanded(
                        child: PDFView(
                          filePath: Pfile.path,
                        ),
                      )
                    ],
                  ),
                )

          );
    });
  }
}
