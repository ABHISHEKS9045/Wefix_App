import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../common/const.dart';
import '../bottom_navigationmodelpage.dart';
import '../bottom_navigationpage.dart';
import 'invoicDetailsPage.dart';
import 'invoicModelPage.dart';

class ProductInfo {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  int get quantity => int.tryParse(quantityController.text) ?? 0;
  int get price => int.tryParse(priceController.text) ?? 0;
  int get total => quantity * price;

  void updateTotal() {
    totalController.text = total.toString();
  }
}

class SubmitInvoicepage extends StatefulWidget {
  final invoiceData;

  SubmitInvoicepage({super.key, this.invoiceData});

  @override
  State<SubmitInvoicepage> createState() => _SubmitInvoicepageState();
}

class _SubmitInvoicepageState extends State<SubmitInvoicepage> {

  List<ProductInfo> products = [];
  int totalSum = 0;

  List<Widget> rows = [];
  List<TextEditingController> textControllers = [];


  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController firstTotalController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();



  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = Provider.of<invoicModelPage>(context, listen: false);

      qtyController.text = widget.invoiceData['qty'].toString();
      priceController.text = widget.invoiceData['price'].toString();
      firstTotalController.text = widget.invoiceData['total'].toString();


      model.setOrderAmount(widget.invoiceData['order_amount'].toString());
      model.setSubTotal(widget.invoiceData['order_amount'].toString());


      print("widget.invoiceData==========================>${widget.invoiceData}");
    });

    super.initState();
  }
  void addNewRow() {
    ProductInfo productInfo = ProductInfo();
    // products.add(productInfo);

    setState(() {
      products.add(productInfo);
      calculateTotalSum();
    });
  }

  void calculateTotalSum() {
    int sum = 0;
    for (var product in products) {
      sum += product.total;
    }
    setState(() {
      totalSum = sum + int.parse(firstTotalController.text);
      Provider.of<invoicModelPage>(context, listen: false).subTotalController1.text = totalSum.toString();
    });



  }

  void removeLastRow() {

    products.removeLast();
    calculateTotalSum();
  }




  Widget buildRow(ProductInfo productInfo) {
    return Consumer<invoicModelPage>(builder: (context, model, _) {

      return


        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                height: 40,
                width: 80,
                child: TextField(
                  controller: productInfo.productNameController,
                  decoration: InputDecoration(
                    focusColor: HexColor("#6759FF"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#cccccc"),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: HexColor("#ffffff"),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: fontWeight600,
                      color: HexColor("#D1D3D4"),
                    ),
                    hintText: "Name",
                  ),

                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                height: 40,
                width: 80,
                child: TextField(

                  onChanged: (_) {
                    productInfo.updateTotal();
                    calculateTotalSum();
                  },
                  controller:productInfo.quantityController,
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    focusColor: HexColor("#6759FF"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#cccccc"),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: HexColor("#ffffff"),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: fontWeight600,
                      color: HexColor("#D1D3D4"),
                    ),
                    hintText: "Qty",
                  ),

                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                height: 40,
                width: 80,
                child: TextField(
                  controller: productInfo.priceController,
                  onChanged: (_) {
                    productInfo.updateTotal();
                    calculateTotalSum();
                  },

                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    focusColor: HexColor("#6759FF"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#cccccc"),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: HexColor("#ffffff"),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: fontWeight600,
                      color: HexColor("#D1D3D4"),
                    ),
                    hintText: "price",
                  ),

                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                height: 40,
                width: 80,
                child: TextField(
                  enabled: false,
                  readOnly: true,

                  controller: productInfo.totalController,
                  decoration: InputDecoration(
                    focusColor: HexColor("#6759FF"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#ffffff"),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: HexColor("#ffffff"),
                    hintStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: fontWeight600,
                      color: Colors.black,
                    ),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    hintText: "0.0",
                  ),

                ),
              ),

            ],

          ),);});
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<invoicModelPage>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              "New message",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),


          body: ModalProgressHUD(
            inAsyncCall: model.is_loding,
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(
              color: colorTheme,
            ),child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "INVOICE :  ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            "To:  ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.invoiceData['vendor_name'].toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.invoiceData['first_name'].toString()} ${widget.invoiceData['last_name'].toString()} ',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        widget.invoiceData['phone'].toString() == 'null' ? "905674463" : widget.invoiceData['phone'].toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        widget.invoiceData['address'].toString() == "null" ? "Address" : widget.invoiceData['address'].toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        widget.invoiceData['email'].toString() == "null" ? "" : widget.invoiceData['email'].toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  sizedboxheight(10.0),
                  Table(
                    children: [
                      TableRow(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Product',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: fontWeight500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Qty',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: fontWeight500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: fontWeight500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: fontWeight500,
                            ),
                          ),
                        ),
                      ]),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child:
                            Text(
                              widget.invoiceData['product_name'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: 40,
                            width: 30,
                            child:  qtyTextField(model, 1, qtyController, "1", true, false),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: 40,
                            width: 30,

                            child:  priceTextField(model, 1, priceController, "1", true, false),

                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: 40,
                            width: 90,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: firstTotalController,
                              decoration: InputDecoration(
                                focusColor: HexColor("#6759FF"),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: HexColor("#ffffff"),
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: HexColor("#ffffff"),
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: fontWeight600,
                                  color: Colors.black,
                                ),
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                hintText: "0.0",
                              ),

                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                  sizedboxheight(5.0),

                  // Column(
                  //   children: rows,
                  // ),
                  ...products.map((product) => buildRow(product)).toList(),

                  sizedboxheight(10.0),
                  // noteTextField(4, model.notesController, widget.invoiceData['note'].toString()),


                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {



                            addNewRow();


                            // model.checkField(context, widget.invoiceData['order_id'], widget.invoiceData['id'], widget.invoiceData['note'].toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: HexColor("#6759FF"),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                            ),
                            child: Text(
                              "Add Row",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: fontWeight600,
                              ),
                            ),
                          ),
                        ),
                        sizedboxwidth(20.0),
                        InkWell(
                          onTap: () {

                            removeLastRow();
                            setState(() {});
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                              ),
                              child: Text(
                                "Delete Row",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: fontWeight600,
                                ),
                              )),
                        ),



                      ],
                    ),
                  ),


                  Table(
                      border: TableBorder.all(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor("#E5E5E5").withOpacity(1.0),
                      ), // Allows to add a border decoration around your table
                      children: [
                        TableRow(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(18),
                              child: Text(
                                'Sub Total',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: fontWeight500,
                                ),
                              ),
                            ),
                            invoiceTextField(model, 1, model.subTotalController1 , widget.invoiceData['sub_total'].toString(), true, false),
                          ],
                        ),
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Truck Charges',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          invoiceTextField(model, 1, model.trackController, widget.invoiceData['track_charge'].toString() == "null" ? "0.0" : widget.invoiceData['track_charge'].toString(), true, false),
                        ]),
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Labour Charges',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          invoiceTextField(model, 1, model.labourController, widget.invoiceData['labour_charge'].toString() == "null" ? "0.0" : widget.invoiceData['labour_charge'].toString(), true, false),
                        ]),
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Extra Charges',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          invoiceTextField(model, 1, model.extraController, widget.invoiceData['extra_charge'].toString() == "null" ? "0.0" : widget.invoiceData['extra_charge'].toString(), true, false),
                        ]),
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Tax in %',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          invoiceTextField(model, 1, model.taxController, widget.invoiceData['tax'].toString() == "null" ? "0.0" : widget.invoiceData['tax'].toString(), true, false),
                        ]),
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: fontWeight500,
                              ),
                            ),
                          ),
                          invoiceTextField(model, 1, model.grandTotalController, widget.invoiceData['order_amount'].toString(), false, true),
                        ]),
                      ]),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<BottomnavbarModelPage>(context, listen: false).togglebottomindexreset();
                            Get.off(BottomNavBarPage());
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                              ),
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: fontWeight600,
                                ),
                              )),
                        ),
                        sizedboxwidth(20.0),
                        InkWell(
                          onTap: () {

                            if (model.grandTotalController.text.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please enter your total amount!');
                            } else if (qtyController.text.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please enter your qty!');
                            } else if (model.trackController.text.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please enter  track amount!');
                            } else if (priceController.text == '') {
                              Fluttertoast.showToast(msg: 'Please enter your labour charges!');
                            }
                            else {
                              model.generateInvoice(context, widget.invoiceData['order_id'], widget.invoiceData['id'], widget.invoiceData['note'].toString(),qtyController.text,priceController.text,model.trackController.text,model.extraController.text ,model.labourController.text);

                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: HexColor("#6759FF"),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: HexColor("#E5E5E5").withOpacity(1.0)),
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: fontWeight600,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),)
      );
    });
  }

  Widget AddRow(invoicModelPage model,TextEditingController productController,TextEditingController qtyController,TextEditingController priceController) {
    return Table(
      children: [

        TableRow(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              height: 40,
              width: 30,
              child:productTextField(model, 1, model.productController, widget.invoiceData['product_name'].toString(), true, false),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              height: 40,
              width: 30,
              child:  qtyTextField(model, 1, model.qtyController, "1", true, false),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              height: 40,
              width: 30,

              child:  priceTextField(model, 1, model.priceController, "1", true, false),

            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text(
                model.totalPrice,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: fontWeight500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget invoiceTextField(invoicModelPage model, int maxline, TextEditingController controller, String hintText, bool enable, bool readOnly) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: maxline,
            controller: controller,
            enabled: enable,
            readOnly: readOnly,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
            ],
            onChanged: (value) {
              debugPrint("function called ======> $value");
              model.calculation();
              calculate();

            },
            decoration: InputDecoration(
              focusColor: HexColor("#6759FF"),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: HexColor("#ffffff"),
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: HexColor("#ffffff"),
              hintStyle: TextStyle(
                fontSize: 17,
                fontWeight: fontWeight600,
                color: HexColor("#D1D3D4"),
              ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              hintText: hintText,
            ),
          )
        ],
      ),
    );
  }

  calculate(){
    firstTotalController.clear();
    subTotalController.clear();
    int qty = int.parse(qtyController.text);
    int price = int.parse(priceController.text);
    int total = qty * price;
    firstTotalController.text = total.toString();
    // subTotalController = firstTotalController + ;
    setState(() {

    });



  }

  Widget qtyTextField(invoicModelPage model, int maxline, TextEditingController controller, String hintText, bool enable, bool readOnly) {
    return Container(
      alignment: Alignment.center,
      child: TextField(
        maxLines: maxline,
        controller: controller,
        enabled: enable,
        readOnly: readOnly,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]'),
          ),
        ],
        onChanged: (value) {
          debugPrint("function called ======> $value");
          calculate();
          calculateTotalSum();
          // model.calculation();
          // model.updateSubTotal();
        },
        decoration: InputDecoration(
          focusColor: HexColor("#6759FF"),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor("#cccccc"),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: HexColor("#ffffff"),
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: fontWeight600,
            color: HexColor("#D1D3D4"),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget priceTextField(invoicModelPage model, int maxline, TextEditingController controller, String hintText, bool enable, bool readOnly) {
    return Container(
      child: TextField(

        maxLines: maxline,
        controller: controller,
        enabled: enable,
        readOnly: readOnly,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]'),
          ),
        ],




        onChanged: (value) {
          debugPrint("function called ======> $value");

          calculate();
          calculateTotalSum();

          // model.calculation();
          // model.updateSubTotal();
          setState(() {});

        },
        decoration: InputDecoration(
          focusColor: HexColor("#6759FF"),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor("#cccccc"),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: HexColor("#ffffff"),
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: fontWeight600,
            color: HexColor("#D1D3D4"),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
  Widget productTextField(invoicModelPage model, int maxline, TextEditingController controller, String hintText, bool enable, bool readOnly) {
    return Container(

      alignment: Alignment.center,
      child: TextField(
        maxLines: maxline,
        controller: controller,
        enabled: enable,
        readOnly: readOnly,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,



        decoration: InputDecoration(
          focusColor: HexColor("#6759FF"),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor("#cccccc"),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: HexColor("#ffffff"),
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight600,
              color: Colors.black
          ),
          hintText: hintText,
        ),
      ),
    );
  }


}




