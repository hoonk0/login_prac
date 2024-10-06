
import 'package:flutter/material.dart';

import '../../../const/value/colors.dart';


class GrayButton extends StatelessWidget {
  final String title;
  final Color colorBg;
  final Color titleColorBg;
  final double titleFontSize;
  final double width;
  final void Function()? onTap;

  const GrayButton({
    required this.title,
    this.colorBg = colorPoint800,
    this.width = double.infinity,
    this.titleColorBg = colorGray500,
    this.titleFontSize = 18,
    required this.onTap,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
