import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../common/const.dart';
import '../dashboard.dart';
import '../dashboardModelPage.dart';

class StorLoctionScreen extends StatefulWidget {
  @override
  _StorLoctionScreenState createState() => _StorLoctionScreenState();
}

class _StorLoctionScreenState extends State<StorLoctionScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(milliseconds: 1));
      final model = Provider.of<DashboardModelPage>(context, listen: false);
      await model.StoreLocationData(context);
    });
    super.initState();
  }

  Color _colorContainer = HexColor("#EFEFEF");

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModelPage>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: HexColor("#F9F9F9"),
        body: ModalProgressHUD(
          inAsyncCall: model.is_loding,
          opacity: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10,top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  //height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: model.storelocation.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      var data = model.storelocation[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _colorContainer = _colorContainer == Colors.white ? Colors.white : Colors.white;
                          });
                          print("Store Id${data['id']}");
                          model.updateAddress(data['address']);
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dashboard(Id: data['id'], isTap: false),
                              ));
                        },
                        child: Column(
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _colorContainer,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                width: deviceWidth(context),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Store Name : ",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: fontWeight500,
                                                  ),
                                                ),
                                                Text(
                                                  data['name'].toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: fontWeight500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            "Store Location :",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: fontWeight500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          sizedboxwidth(5.0),
                                          Expanded(
                                            child: Text(
                                              data['address'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
