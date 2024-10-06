import 'package:flutter/material.dart';

import '../../const/value/colors.dart';

class PaginationIndicator extends StatelessWidget {
  const PaginationIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
      child: const CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(colorPrimary500),
        strokeCap: StrokeCap.round,
        strokeWidth: 3,
      ),
    );
  }
}


class BasicIndicator extends StatelessWidget {
  final ValueNotifier<bool> vnIsIndicatorShow;

  const BasicIndicator({
    super.key,
    required this.vnIsIndicatorShow,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: vnIsIndicatorShow,
      builder: (context, isIndicatorShow, child) => isIndicatorShow
          ? Container(
        constraints: const BoxConstraints(maxHeight: 20, maxWidth: 20),
        child: const CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(colorPurple500),
          strokeCap: StrokeCap.round,
          strokeWidth: 2,
        ),
      )
          : const SizedBox(),
    );
  }
}
