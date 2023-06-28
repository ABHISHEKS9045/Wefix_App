// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service/common/const.dart';

class AllInputDesign extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final controller;
  final floatingLabelBehavior;
  final prefixText;
  final fillColor;
  final enabled;
  final initialValue;
  final hintText;
  final labelText;
  final textInputAction;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final List<TextInputFormatter>? inputFormatterData;
  final FormFieldSetter<String>? onSaved;
  final obsecureText;
  final suffixIcon;
  final prefixIcon;
  final maxLength;
  final outlineInputBorderColor;
  final outlineInputBorder;
  final enabledBorderRadius;
  final focusedBorderRadius;
  final enabledOutlineInputBorderColor;
  final focusedBorderColor;
  final hintTextStyleColor;
  final counterText;
  final cursorColor;
  final textStyleColors;
  final inputHeaderName;
  final autofillHints;
  final onEditingComplete;
  final textCapitalization;
  final keyboardType;
  final maxLines;
  final minLines;
  final boxshadow;
  final elevation;
  final widthtextfield;
  final inputHeaderTextStyle;
  final inputLableColor;

  const AllInputDesign({
    Key? key,
    this.textStyleColors,
    this.controller,
    this.floatingLabelBehavior,
    this.initialValue,
    this.cursorColor,
    this.prefixIcon,
    this.textInputAction,
    this.outlineInputBorder,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.enabled,
    this.prefixText,
    this.fillColor,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.validatorFieldValue,
    this.inputFormatterData,
    this.validator,
    this.onSaved,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.outlineInputBorderColor,
    this.enabledOutlineInputBorderColor,
    this.focusedBorderColor,
    this.hintTextStyleColor,
    this.counterText,
    this.inputHeaderName,
    this.onEditingComplete,
    this.autofillHints,
    this.textCapitalization,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.boxshadow,
    this.elevation,
    this.widthtextfield,
    this.inputHeaderTextStyle,
    this.inputLableColor,
  }) : super(key: key);

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  // var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.inputHeaderName != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.inputHeaderName != null)
                        ? widget.inputHeaderName
                        : '',
                    style: (widget.inputHeaderTextStyle != null)
                        ? widget.inputHeaderTextStyle
                        : textstylesubtitle1(context)!
                            .copyWith(color: colorblack54),
                  ),
                  sizedboxheight(3.0),
                  myTextfieldWidget(context),
                ],
              )
            : myTextfieldWidget(context),
      ],
    );
  }

  Widget myTextfieldWidget(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: widget.enabledBorderRadius ?? BorderRadius.circular(0),
      color: Colors.transparent,
      elevation: widget.elevation ?? 0,
      child: Container(
        width: widget.widthtextfield ?? screensize,
        decoration: BoxDecoration(
            borderRadius: widget.boxshadow != null
                ? BorderRadius.circular(0)
                : BorderRadius.circular(0),
            boxShadow: widget.boxshadow ??
                [
                  BoxShadow(
                    color: Colors.transparent,
                  )
                ]),
        child: TextFormField(
          minLines: widget.maxLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          cursorColor: widget.cursorColor ?? colorblack,
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          style: TextStyle(
              color: widget.textStyleColors ?? colorblack,
              fontWeight: FontWeight.w500,
              fontSize: screensize <= 350 ? 16 : 18),
          keyboardType: widget.keyBoardType,
          validator: widget.validator,
          controller: widget.controller,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatterData,
          obscureText: widget.obsecureText ?? false,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            labelText: widget.labelText ?? widget.hintText ?? '',

            labelStyle: textstylesubtitle1(context)!
                .copyWith(color: widget.inputLableColor ?? colorblack54),
            counterText: widget.counterText,
            filled: true,
            fillColor: widget.fillColor ?? colorWhite,
            hintText: (widget.hintText != null) ? widget.hintText : '',
            floatingLabelBehavior:
                widget.floatingLabelBehavior ?? FloatingLabelBehavior.never,
            hintStyle: TextStyle(
              color: widget.hintTextStyleColor ?? colorgrey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon != null
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: widget.prefixIcon,
                  )
                : null,

            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: widget.suffixIcon ?? Text(''),
                  )
                : null,
            prefixText: (widget.prefixText != null) ? widget.prefixText : '',
            prefixStyle: widget.prefixStyle,
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.all(10.0),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  widget.focusedBorderRadius ?? BorderRadius.circular(0),
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? colorredlightbtn,
                  width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  widget.enabledBorderRadius ?? BorderRadius.circular(0),
              borderSide: BorderSide(
                  color: widget.enabledOutlineInputBorderColor ?? colorgrey,
                  width: 1.0),
            ),
            border: widget.outlineInputBorder ??
                OutlineInputBorder(
                  borderRadius:
                      widget.enabledBorderRadius ?? BorderRadius.circular(0),
                  borderSide: BorderSide(
                      color: widget.outlineInputBorderColor ?? colorredlightbtn,
                      width: 1.0),
                ),
          ),
        ),
      ),
    );
  }
}
