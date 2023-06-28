import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:service/BottamNavigation/dashboard/AllProduct/product.dart';
import 'package:service/common/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Notification/NotificationScreen.dart';
import '../../QRCode/rrscan.dart';
import '../PDF/PaindingData.dart';
import '../Serach/Searchpage.dart';
import '../Serach/invoichomescreen.dart';
import 'GooglePlaceLApi/StorLocation.dart';
import 'dashboardModelPage.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key, this.Id, this.isTap});

  final Id;
  final isTap;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  String? firstName;
  bool isVendor = false;
  bool ismanager = false;
  String? userType;

  @override
  void initState() {
    bool? selectedAddress;
    if (widget.isTap == null) {
      selectedAddress = true;
    } else {
      selectedAddress = widget.isTap;
    }
    var list = Provider.of<DashboardModelPage>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {


      SharedPreferences prefs = await SharedPreferences.getInstance();
      String roleId = jsonDecode(prefs.getString('roleid')!).toString();
      userType = roleId;
      if (roleId == '1') isVendor = true;
      if (roleId == '3') ismanager = true;
      Future.delayed(const Duration(milliseconds: 10));
      await list.loadDashboardProductList(context);

      firstName = jsonDecode(prefs.getString('first_name')!);
    });

    if (selectedAddress == true) {
      _getCurrentPosition(context, list);
    }
    super.initState();
  }

  String result = '';

  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModelPage>(builder: (context, model, _) {
      return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: model.is_loding,
          opacity: 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: RefreshIndicator(
              onRefresh: () async {
                await model.loadDashboardProductList(context);
              },
              child: Column(
                children: [
                  Container(
                    color: colorWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CURRENT LOCATION',
                                style: TextStyle(color: Colors.grey),
                              ),
                              sizedboxwidth(4.0),
                              // Icon(Icons.menu, size: 27),
                              if (!isVendor)
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          model.currentAddress.toString() == ''
                                              ? model.selectaddress
                                              : model.selectaddress == null
                                                  ? "Enable Location"
                                                  : model.currentAddress.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 20,
                                    )
                                  ],
                                ),

                              if (isVendor)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          model.currentAddress.toString() == ''
                                              ? model.selectaddress
                                              : model.selectaddress == null
                                                  ? "Enable Location"
                                                  : model.currentAddress.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.black, fontSize: 16)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => StorLoctionScreen());
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const NotificationScreen());
                          },
                          child: const SizedBox(
                              width: 25,
                              height: 25,
                              child: Image(
                                image: AssetImage('assets/icons/Notification.png'),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/homess.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sizedboxheight(20.0),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "HELLO ${firstName.toString().toUpperCase()} 👋",
                                    style: TextStyle(
                                      color: HexColor("#FFFFFF"),
                                      fontSize: 19.0,
                                      fontWeight: fontWeight500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
                              child: Text(
                                "What you are ",
                                style: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  fontSize: 28.0,
                                  fontWeight: fontWeight600,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
                              child: Text(
                                "looking for",
                                style: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  fontSize: 28.0,
                                  fontWeight: fontWeight600,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
                              child: Text(
                                "Today",
                                style: TextStyle(
                                  color: HexColor("#FFFFFF"),
                                  fontSize: 35.0,
                                  fontWeight: fontWeight600,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 150,
                          child: Image.asset(
                            'assets/images/homedesign.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  sizedboxheight(10.0),
                  Expanded(
                    child: GridView.extent(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 270.0,
                      childAspectRatio: 0.7,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Get.to(() => ScanQR());
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  sizedboxheight(40.0),
                                  SizedBox(
                                    height: 130,
                                    child: Image.asset(
                                      'assets/images/Layer1.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 137,
                                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: HexColor("#6759FF"),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: HexColor("#E5E5E5").withOpacity(1.0),
                                            ),
                                          ),
                                          child: const SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: Icon(
                                              Icons.qr_code,
                                              color: Colors.black,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                        sizedboxwidth(5.0),
                                        InkWell(
                                          child: Text(
                                            "QR code",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: fontWeight600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        if (userType == "4")
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                sizedboxheight(40.0),
                                SizedBox(
                                  height: 130,
                                  child: Image.asset(
                                    'assets/images/dataproduct.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ProductPage(
                                        isForSearch: false,
                                        searchText: '',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 135,
                                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                      color: HexColor("#6759FF"),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          // onTap: () => AddProductScanQRPage(),
                                          child: Text(
                                            "All product",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: fontWeight600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (userType == "1")
                          InkWell(
                            onTap: () {
                              Get.to(() => const PaindingData());
                            },
                            child: Container(
                                // width: 160,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    sizedboxheight(40.0),
                                    SizedBox(
                                      height: 130,
                                      child: Image.asset(
                                        'assets/images/pendingg.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 135,
                                      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                      decoration: BoxDecoration(
                                        color: HexColor("#6759FF"),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              "Pending",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: fontWeight600,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        if (userType == '3')
                          InkWell(
                            onTap: () {
                              Get.to(() => const PaindingData());
                            },
                            child: Container(
                              // width: 160,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  sizedboxheight(40.0),
                                  SizedBox(
                                    height: 130,
                                    child: Image.asset(
                                      'assets/images/pendingg.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 140,
                                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                      color: HexColor("#6759FF"),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Text(
                                            "Pending ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: fontWeight600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (userType == "3")
                          Container(
                            // width: 160,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                sizedboxheight(40.0),
                                SizedBox(
                                  height: 130,
                                  child: Image.asset(
                                    'assets/images/dataproduct.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ProductPage(
                                          isForSearch: false,
                                          searchText: '',
                                        ));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 140,
                                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                      color: HexColor("#6759FF"),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          // onTap: () => AddProductScanQRPage(),
                                          child: Text(
                                            "Equipment",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: fontWeight600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (userType == "1" || userType == "4")
                          Container(
                            // width: 160,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                sizedboxheight(40.0),
                                SizedBox(
                                  height: 130,
                                  child: Image.asset(
                                    'assets/images/invoicesffgfd.png',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => InvoicHomescreen());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 137,
                                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                      color: HexColor("#6759FF"),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Invoices",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: fontWeight600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Searchpage()));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6759FF), Color(0xFFC9C4FD)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                sizedboxheight(40.0),
                                SizedBox(
                                  height: 130,
                                  child: Image.asset(
                                    'assets/images/reportss.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 137,
                                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    color: HexColor("#6759FF"),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Report",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: fontWeight600,
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      );
    });
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition(BuildContext context, DashboardModelPage model) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!, model);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position, DashboardModelPage model) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        model.currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
