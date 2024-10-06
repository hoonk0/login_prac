import 'package:flutter/material.dart';

import '../../const/value/colors.dart';
import '../../const/value/gaps.dart';
import '../../const/value/text_style.dart';

class PurpleContainer extends StatelessWidget {
  final String title;
  final String desc;
  final void Function()? onTap;

  const PurpleContainer({
    super.key,
    required this.title,
    required this.desc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: colorPurple50,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: colorPurple500,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TS.s14w500(colorGray900),

                ///size 14인데 12로 바꿈 (질문)
              ),
              Gaps.v10,
              Text(
                desc,
                style: TS.s18w600(colorPurple500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
