import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/const.dart';
import '../dashboard/dashboardModelPage.dart';

class EditProfileScreen extends StatefulWidget {
  DashboardModelPage model;

  EditProfileScreen({required this.model});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.model.profileDetails[0]['first_name'] ??= '';
    lastNameController.text = widget.model.profileDetails[0]['last_name'] ??= '';
    addressController.text = widget.model.profileDetails[0]['street_address'] ??= '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F9F9F9"),
      appBar: AppBar(
        // leadingWidth: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/icons/tag.png",
              fit: BoxFit.contain,
            ),
            sizedboxwidth(10.0),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 25,
                color: HexColor("#1A1D1F"),
                fontWeight: fontWeight600,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipOval(
                                child: pickedImage != null
                                    ? Image.file(
                                  File(pickedImage!.path),
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/images/empty_user.png");
                                  },
                                )
                                    : Image.network(
                                  widget.model.profileDetails[0]['image'].toString(),
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/images/empty_user.png");
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      sizedboxwidth(8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((widget.model.profileDetails[0]['first_name'] ??= '') + ' ' + (widget.model.profileDetails[0]['last_name'] ??= ''), style: Theme.of(context).textTheme.headline6),
                          sizedboxheight(4.0),
                          Row(
                            children: [
                              Text(widget.model.profileDetails[0]['email'], overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.subtitle2),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "First Name",
                              style: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: firstNameController,
                            // obscureText: true,
                            decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: HexColor("#F5F5F5"),
                              hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),

                              // labelText: 'Email',
                              hintText: 'First Name',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Last Name",
                          style: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: HexColor("#F5F5F5"),
                              hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),

                              // labelText: 'Email',
                              hintText: 'Last Name',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#1A1D1F")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: addressController,
                            // obscureText: true,
                            decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: HexColor("#F5F5F5"),
                              hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),

                              // labelText: 'Email',
                              hintText: 'Address',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                var list = Provider.of<DashboardModelPage>(context, listen: false);
                await list.editProfileDetails(context, firstNameController.text, lastNameController.text, addressController.text, pickedImage != null ? true : false, pickedImage);
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: HexColor("#6759FF"),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Text("Save", style: TextStyle(fontSize: 20, fontWeight: fontWeight600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
