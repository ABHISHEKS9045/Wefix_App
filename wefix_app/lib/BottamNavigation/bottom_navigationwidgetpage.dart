// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/common/const.dart';

BottomNavigationBar bottomNavBarPagewidget(context, model) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: colorWhite,
    selectedItemColor: colorpinklight,
    unselectedItemColor: colorblack,
    showUnselectedLabels: true,
    selectedFontSize: 10,
    unselectedFontSize: 10,

    selectedIconTheme: IconThemeData(color: colorpinklight, size: 10),
    selectedLabelStyle: TextStyle(fontWeight: fontWeight700, color: colorpinklight),
    unselectedLabelStyle: TextStyle(fontWeight: fontWeight500),
    onTap: (index) {
      model.toggle(context, index);
    },
    currentIndex: model.bottombarzindex,

    items: [
      BottomNavigationBarItem(
        icon: SizedBox(
            width: 20,
            height: 20,
            child: Image(
              image: AssetImage('assets/icons/Home.png'),
              color: model.bottombarzindex == 0 ? colorpinklight : Colors.grey,
            )),
        label: '',
      ),
      BottomNavigationBarItem(
          icon: SizedBox(
              width: 20,
              height: 20,
              child: Image(
                image: AssetImage('assets/icons/Icon- Outline12.png'),
                color: model.bottombarzindex == 1 ? colorpinklight : Colors.grey,
              )),
          label: ''),
      BottomNavigationBarItem(
          icon: SizedBox(
              width: 20,
              height: 20,
              child: Image(
                image: AssetImage('assets/icons/invoice.png'),
                color: model.bottombarzindex == 2 ? colorpinklight : Colors.grey,
              )),
          label: ''),
      BottomNavigationBarItem(
          // icon: Icon(Icons.person_outline_rounded),
          icon: SizedBox(
              width: 20,
              height: 20,
              child: Image(
                image: AssetImage('assets/icons/profile1.png'),
                color: model.bottombarzindex == 3 ? colorpinklight : Colors.grey,
              )),
          label: ''),
    ],
  );
}

Widget botamshitCardFile(image, titel, ontap) {
  return GestureDetector(
    onTap: () {
      Get.to(ontap);
    },
    child: ListTile(
      tileColor: colorWhite,
      dense: true,
      leading: Image.asset(
        image,
        color: colorblack,
      ),
      minLeadingWidth: 5,
      title: Text(titel),
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: colorblack,
        ),
        onPressed: () {
          Get.to(ontap);
        },
      ),
    ),
  );
}

Widget dividercontaner(context) {
  return Container(
    height: 1,
    width: deviceWidth(context, 1.0),
    color: Colors.black26,
  );
}

Future<bool> onWillPop(context) async {
  final showPopUp = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Are you sure'),
      content: Text('You want to leave from App'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorredlightbtn,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorredlightbtn,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
      ],
    ),
  );

  return showPopUp ?? false;
}
