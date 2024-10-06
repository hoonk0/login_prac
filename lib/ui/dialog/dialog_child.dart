import 'package:flutter/material.dart';

import '../../const/value/colors.dart';
import '../../const/value/gaps.dart';
import '../component/basic_button.dart';

class DialogChild {
  final BuildContext context;
  final Widget child;
  final double? width;
  final Future<void> Function() onTap;
  final bool barrierDismissible;

  const DialogChild({
    required this.context,
    required this.child,
    this.width,
    required this.onTap,
    this.barrierDismissible = true,
  });

  Future<void> show() async {
    await showDialog(

      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(20)),
            width: width,
            constraints: const BoxConstraints(minHeight: 150, maxHeight: 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                child,
                Row(
                  children: [
                    Gaps.h10,
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await onTap();
                        },
                        child: BasicButton(title: 'OK', onTap: onTap),
                      ),
                    ),
                    Gaps.h10,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
