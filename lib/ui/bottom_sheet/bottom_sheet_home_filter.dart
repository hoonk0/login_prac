/*
import 'package:english_quiz/const/model/model_filter.dart';
import 'package:english_quiz/const/value/colors.dart';
import 'package:english_quiz/const/value/gaps.dart';
import 'package:english_quiz/const/value/text_style.dart';
import 'package:english_quiz/service/providers/providers.dart';
import 'package:english_quiz/ui/component/bottom_sheet_short_bar.dart';
import 'package:english_quiz/ui/component/button/gray_button.dart';
import 'package:english_quiz/ui/component/button/purple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../const/static/global.dart';
import '../../const/value/keys.dart';

class BottomSheetBookFilter extends ConsumerStatefulWidget {
  const BottomSheetBookFilter({super.key});

  @override
  ConsumerState<BottomSheetBookFilter> createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends ConsumerState<BottomSheetBookFilter> {
  final pc = PageController();
  final ValueNotifier<List<String>> vnListSelectedThemeTemp = ValueNotifier([]);
  final ValueNotifier<List<String>> vnListSelectedARLevelTemp = ValueNotifier([]);
  final ValueNotifier<List<String>> vnListSelectedAgeTemp = ValueNotifier([]);
  final ValueNotifier<List<String>> vnListSelectedLexileTemp = ValueNotifier([]);
  final ValueNotifier<String> vnSelectedFilterTemp = ValueNotifier(keyTheme);
  late List<ValueNotifier<List<String>>> listVnListSelectedFilterTemp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vnListSelectedThemeTemp.value = List.from(vnListSelectedTheme.value);
    vnListSelectedARLevelTemp.value = List.from(vnListSelectedARLevel.value);
    vnListSelectedAgeTemp.value = List.from(vnListSelectedAge.value);
    vnListSelectedLexileTemp.value = List.from(vnListSelectedLexile.value);
    listVnListSelectedFilterTemp = [vnListSelectedThemeTemp, vnListSelectedARLevelTemp, vnListSelectedAgeTemp, vnListSelectedLexileTemp];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gaps.v15,
          const BottomSheetShortBar(),
          Gaps.v40,
          const Text('Filter', style: TS.s20w600(colorGray900)),
          Gaps.v10,
          Expanded(
            child: Column(
              children: [
                // 제목
                Row(
                  children: List.generate(
                    listFilter.length,
                    (index) => _Title(
                      title: listFilter[index],
                      vnSelectedFilter: vnSelectedFilterTemp,
                      pc: pc,
                      index: index,
                    ),
                  ),
                ),
                Gaps.v20,
                // 내용
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      vnSelectedFilterTemp.value = listFilter[value];
                    },
                    controller: pc,
                    children: List.generate(
                      listFilterData.length,
                      (index) => SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            listFilterData[index].length,
                            (index2) => ValueListenableBuilder(
                              valueListenable: listVnListSelectedFilterTemp[index],
                              builder: (context, listSelectedFilter, child) {
                                final data = listFilterData[index][index2];
                                final isSelected = listSelectedFilter.contains(data);
                                return GestureDetector(
                                  onTap: () {
                                    if (isSelected) {
                                      listVnListSelectedFilterTemp[index].value = List.from(listVnListSelectedFilterTemp[index].value..remove(data));
                                    } else {
                                      listVnListSelectedFilterTemp[index].value = List.from(listVnListSelectedFilterTemp[index].value..add(data));
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          side: WidgetStateBorderSide.resolveWith(
                                            (states) => const BorderSide(width: 1.0, color: colorPurple500),
                                          ),
                                          activeColor: colorPurple500,
                                          checkColor: colorWhite,
                                          value: isSelected,
                                          onChanged: (value) {
                                            if (isSelected) {
                                              listVnListSelectedFilterTemp[index].value =
                                                  List.from(listVnListSelectedFilterTemp[index].value..remove(data));
                                            } else {
                                              listVnListSelectedFilterTemp[index].value =
                                                  List.from(listVnListSelectedFilterTemp[index].value..add(data));
                                            }
                                          },
                                        ),
                                        Text(
                                          data,
                                          style: const TS.s15w500(colorBlack),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.v26,
                Row(
                  children: [
                    Expanded(
                        child: GrayButton(
                            title: 'Reset',
                            onTap: () {
                              Navigator.of(context).pop();
                              resetFilter();
                              vnFilterFamilyKey.value = null;
                            })),
                    Gaps.h15,
                    Expanded(
                      child: PurpleButton(
                        title: 'Confirm',
                        colorBg: colorPurple500,
                        onTap: () async {
                          vnListSelectedTheme.value = List.from(vnListSelectedThemeTemp.value);
                          vnListSelectedARLevel.value = List.from(vnListSelectedARLevelTemp.value);
                          vnListSelectedAge.value = List.from(vnListSelectedAgeTemp.value);
                          vnListSelectedLexile.value = List.from(vnListSelectedLexileTemp.value);

                          final modelFilter = ModelFilter(
                            listTheme: vnListSelectedThemeTemp.value,
                            listARLevel: vnListSelectedARLevelTemp.value,
                            listAge: vnListSelectedAgeTemp.value,
                            listLexile: vnListSelectedLexileTemp.value,
                          );
                          Navigator.of(context).pop();
                          await ref.read(providerBooksFamily(modelFilter).notifier).initPaginate(context);
                          vnFilterFamilyKey.value = modelFilter;
                        },
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetFilter() {
    vnListSelectedLexile.value = [];
    vnListSelectedAge.value = [];
    vnListSelectedARLevel.value = [];
    vnListSelectedTheme.value = [];
  }
}

class _Title extends StatelessWidget {
  final String title;
  final ValueNotifier<String> vnSelectedFilter;
  final PageController pc;
  final int index;

  const _Title({
    required this.title,
    required this.vnSelectedFilter,
    required this.pc,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          vnSelectedFilter.value = title;
          final currentPageIndex = pc.page;
          if ((index - currentPageIndex!).abs() > 1) {
            pc.jumpToPage(index);
          } else {
            pc.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          }
        },
        child: ValueListenableBuilder(
          valueListenable: vnSelectedFilter,
          builder: (context, selectedFilter, child) {
            final isSelected = selectedFilter == title;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? colorPurple500 : colorGray200,
                  ),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TS.s14w600(isSelected ? colorPurple500 : colorGray900),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/
