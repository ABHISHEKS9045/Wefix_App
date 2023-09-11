
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/apiErrorAlertdialog.dart';
import 'package:service/common/const.dart';

import 'invoicDetailsPage.dart';
import 'invoicModelPage.dart';

class Searchpage extends StatefulWidget {
final searchText;
  final bool showBack;


  Searchpage({
    super.key,
    required this.showBack, this.searchText,
  });

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  TextEditingController invoiceController = TextEditingController();
  TextEditingController searchInvoiceController = TextEditingController();


  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(milliseconds: 1));
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              height: 55,
              color: colorWhite,
              child: invoiceSearch(context, model, widget.showBack),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: model.is_loding,
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(
              color: colorTheme,
            ),
            child: model.invoicDetails.isEmpty ? noDataFound(context) : Column(
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
                              "history",
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
                    child: model.invoicDetails != null
                        ? ListView.builder(
                      itemCount: model.invoicDetails.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        var data = model.invoicDetails[index];
                        return InkWell(
                          onTap: () {
                            print("invoce Id1${data['id']}");

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
                            margin: const EdgeInsets.only(top: 15),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10,  ),
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,

                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: ClipOval(
                                                child: Image.network(
                                                  data['thumbnail_image'].toString(),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset("assets/images/wefix_logo.png");
                                                  },
                                                ),
                                              ),
                                            ),
                                            sizedboxwidth(10.0),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Text(
                                                data['product_name'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: fontWeight500,
                                                ),
                                              ),
                                              sizedboxheight(5.0),
                                              Text(
                                                "${data['order_id']}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: fontWeight500,
                                                ),
                                              ),

                                            ],)
                                          ],
                                        ),
                                        sizedboxheight(10.0),
                                        Text(
                                          // data['order_amount'].toString(),
                                          "Date : ${data["date"]}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: HexColor("#1C1244"),
                                          ),
                                        ),

                                        Divider(
                                          height: 10,
                                          thickness: 1,
                                          color: HexColor("#DEDDDD"),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10, left: 10),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    data['vendor_image'].toString(),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Image.asset("assets/images/empty_user.png");
                                                    },
                                                  ),
                                                ),
                                              ),
                                              sizedboxwidth(10.0),
                                              Text(
                                                data['vendor_name'].toString(),
                                                style: TextStyle(
                                                  fontWeight: fontWeight500,
                                                  fontSize: 18,
                                                  color: HexColor("#1A1D1F"),
                                                ),
                                              ),
                                              Spacer(),

                                              Container(

                                                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: HexColor("#6759FF"),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(

                                                  data['order_status'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: fontWeight500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Amount : ${data['total'].toString()}",
                                      style: TextStyle(fontSize: 16, color: HexColor("#1A1D1F")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ) :Center(
                      child: Text("No data ", style: TextStyle(fontSize: 27, color: colorTheme)),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget invoiceSearch(BuildContext context, invoicModelPage model, bool showBack) {
    return Row(
      children: [
        if(showBack)
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 25,
          ),
        ),
        if(showBack)
        sizedboxwidth(10.0),
        Expanded(
            child: TextField(
              controller: searchInvoiceController,
              onChanged: (value)  {

                if(value.isEmpty){
                  model.InvoiceListing(context);
                }
                else if(value.length > 2 ){
                  model.loadSearchInvoiceList(searchInvoiceController.text);
                }

              },
              // focusNode: node,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
                ),
                filled: true,
                fillColor: HexColor("#F5F5F5"),
                hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight500, color: HexColor("#D1D3D4")),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Search history',
                suffixIcon: TextButton(
                  onPressed: () async {
                    // await model.invoicDetails(context, invoiceController.text);
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
