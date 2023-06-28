import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../common/button.dart';
import '../common/const.dart';
import 'LoginModelPage.dart';

Widget loginChildrens(context) {
  return Form(
    child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Consumer<LoginModelPage>(builder: (context, model, _) {
        return Column(
          children: [
            const SizedBox(height: 100),
            sininwithAccountwel(context, "Sign in"),
            const SizedBox(height: 22),
            textemail(context, "E-mail"),
            const SizedBox(height: 5),
            loginemail(model),
            const SizedBox(height: 25),
            textpass(context, "Password"),
            const SizedBox(height: 5),
            loginPassword(context, model),
            const SizedBox(height: 30),
            loginBtn(context, model),
          ],
        );
      }),
    ),
  );
}

Widget loginemail(model) {
  return Padding(
    padding: const EdgeInsets.only(right: 15, left: 15),
    child: TextField(
      controller: model.loginEmail,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#EFEFEF"), width: 1),
        ),

        filled: true, //<-- SEE HERE
        fillColor: HexColor("#F5F5F5"),
        hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

        // labelText: 'Email',
        hintText: 'Enter Your Email',
      ),
    ),
  );
}

Widget sininwithAccountwel(context, leadingtext) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 45),
        child: Text(leadingtext, style: TextStyle(fontSize: 40)),
      ),
    ],
  );
}

Widget textemail(context, leadingtext) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 45),
        child: Text(leadingtext, style: TextStyle(color: HexColor("#1A1D1F"), fontSize: 18, fontWeight: fontWeight600)),
      ),
    ],
  );
}

Widget textpass(context, leadingtext) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 45),
        child: Text(leadingtext, style: TextStyle(color: HexColor("#1A1D1F"), fontSize: 18, fontWeight: fontWeight600)),
      ),
    ],
  );
}

Widget loginPassword(context, model) {
  return Padding(
    padding: const EdgeInsets.only(right: 15, left: 15),
    child: TextField(
      obscureText: true,
      controller: model.loginPassword,
      decoration: InputDecoration(
        // focusedBorder: HexColor("#6759FF"),
        focusColor: HexColor("#6759FF"),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("#EFEFEF"),
            width: 1,
          ),
        ),

        filled: true, //<-- SEE HERE
        fillColor: HexColor("#F5F5F5"),
        hintStyle: TextStyle(fontSize: 17, fontWeight: fontWeight600, color: HexColor("#D1D3D4")),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Enter Your Password',
      ),
    ),
  );
}

Widget loginBtn(BuildContext context, model,) {
  return Button(
    buttonName: 'Sign in',
    btnfontsize: 24.0,
    btnHeight: 55.0,
    btnWidth: 340.0,
    textColor: Colors.white,
    key: const Key('login_submit'),
    btnColor: HexColor('#6759FF'),
    borderColor: HexColor('#6759FF'),
    onPressed: () async {
      await model.loginSubmit(context);
    },
  );
}

