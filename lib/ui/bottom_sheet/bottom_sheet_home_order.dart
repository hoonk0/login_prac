/*
import 'package:english_quiz/const/enums/enums.dart';
import 'package:english_quiz/const/static/global.dart';
import 'package:english_quiz/service/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const/value/colors.dart';
import '../../const/value/gaps.dart';
import '../../const/value/text_style.dart';
import '../../ui/component/button/gray_button.dart';
import '../../ui/component/button/purple_button.dart';

class BottomSheetBookOrder extends ConsumerWidget {
  final ValueNotifier<EnumBookOrder> vnSelectedBookOrder;

  const BottomSheetBookOrder({
    super.key,
    required this.vnSelectedBookOrder,
  });

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.v15,
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: colorGray300,
                  ),
                ),
              ),
              Gaps.v20,
              const Text(
                'Order by',
                style: TS.s20w600(colorGray900),
              ),
              Gaps.v10,
              ValueListenableBuilder<EnumBookOrder?>(
                valueListenable: vnSelectedBookOrder,
                builder: (context, selectedBookOrder, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        EnumBookOrder.values.length,
                        (index) {
                          final bookOrder = EnumBookOrder.values.toList()[index];
                          return _Title(
                            title: bookOrder.name,
                            onTap: () {
                              vnSelectedBookOrder.value = bookOrder;
                              final currentFamilyKey = vnFilterFamilyKey.value;
                              ref.read(providerBooksFamily(currentFamilyKey).notifier).reset(context);
                              ref.read(providerBooksFamily(currentFamilyKey).notifier).initPaginate(context);
                              Navigator.of(context).pop();
                            },
                            isSelected: selectedBookOrder == bookOrder,
                          );
                        },
                      ),
                      Gaps.v20,
                      PurpleButton(
                        colorBg: colorPurple500,
                        title: 'Reset',
                        onTap: () {
                          vnSelectedBookOrder.value = EnumBookOrder.Newest;
                        },
                      ),
                      Gaps.v20,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final bool isSelected;

  const _Title({
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(
                title,
                style: TS.s14w600(isSelected ? colorPurple500 : colorGray900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
