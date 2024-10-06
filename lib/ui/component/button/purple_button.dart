
import 'package:flutter/material.dart';

import '../../../const/value/colors.dart';


class PurpleButton extends StatelessWidget {
  final String title;
  final Color colorBg;
  final Color titleColorBg;
  final double titleFontSize;
  final double width;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const PurpleButton({
    required this.title,
    this.colorBg = colorPurple100,
    this.width = double.infinity,
    this.titleColorBg = colorWhite,
    this.titleFontSize = 18,
    required this.onTap,
    this.padding,
    this.margin,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        height: 48,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: colorBg,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
              color: titleColorBg
            )

          ),
        ),
      ),
    );
  }
}
