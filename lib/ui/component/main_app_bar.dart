import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../const/value/colors.dart';
import '../../const/value/text_style.dart';

class MainAppBar extends StatelessWidget {
  final String title;

  const MainAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'appbar',
      child: AppBar(
        title: Text(title, style: const TS.s18w600(colorGray900)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent,
            child: Transform.scale(
              scale: 0.5,
              child: SvgPicture.asset('assets/icons/left_arrow.svg'),
            ),
          ),
        ),
      ),
    );
  }
}
