import 'package:flutter/material.dart';

class JooseText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? fontColor;
  final TextAlign alignment;
  final String font;
  final TextOverflow? over;
  const JooseText(
      {Key? key,
        this.text,
        this.fontSize,
        this.fontWeight = FontWeight.w500,
        this.fontColor,
        this.alignment = TextAlign.center,
        this.font = "Segoe",
        this.over,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
          color: fontColor,
          fontWeight: fontWeight,
          fontFamily: font,
          fontSize: fontSize),
      textAlign: alignment,
      overflow: over,
    );
  }
}
