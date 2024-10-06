
import 'package:flutter/material.dart';

import '../../../const/value/colors.dart';


class BlueButton extends StatelessWidget {
  final String title;
  final Color colorBg;
  final Color titleColorBg;
  final double titleFontSize;
  final double width;
  final void Function()? onTap;

  const BlueButton({
    required this.title,
    this.colorBg = colorBlue500,
    this.width = double.infinity,
    this.titleColorBg = colorWhite,
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
