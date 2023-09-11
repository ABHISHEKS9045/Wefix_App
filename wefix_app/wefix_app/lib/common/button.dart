import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service/common/const.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonName;
  @override
  final Key? key;
  final borderRadius;
  final double? btnWidth;
  final double? btnHeight;
  final Color? btnColor;
  final Color? btnColorGradientUp;
  final Color? btnColorGradientdown;
  final Color? borderColor;
  final Color? textColor;
  final imageAsset;
  final double? elevation;
  final double? btnfontsize;
  final btnstyle;

  const Button({
    this.buttonName,
    required this.onPressed,
    this.borderRadius,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.btnColorGradientUp,
    this.btnColorGradientdown,
    this.borderColor,
    this.textColor,
    this.key,
    this.imageAsset,
    this.elevation,
    this.btnstyle,
    this.btnfontsize,
  });
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;
    return Container(
      height: btnHeight ?? 45.0,
      width: btnWidth ?? screenSize,
      decoration: BoxDecoration(
        color: btnColor ?? colorredlightbtn,
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      ),
      child: MaterialButton(
        splashColor: Colors.grey,
        // animationDuration: Duration(seconds: 10),
        hoverColor: Colors.black26,

        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(20.0),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        key: key,
        elevation: elevation ?? 3,
        onPressed: onPressed,
        child: imageAsset != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefiximage(), btnname(context)],
              )
            : btnname(context),
      ),
    );
  }

  Widget prefiximage() {
    return imageAsset;
  }

  Widget btnname(context) {
    return Text(
      buttonName!,
      style: btnstyle ??
          TextStyle(
            inherit: true,
            color: textColor ?? Colors.white,
            fontFamily: 'Nunito',
            fontSize: btnfontsize ?? 17,
            letterSpacing: 0.3,
          ),
    );
  }
}
