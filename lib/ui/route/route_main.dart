//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_prac/ui/route/tab/tab_book.dart';
import 'package:login_prac/ui/route/tab/tab_profile.dart';
import 'package:login_prac/ui/route/tab/tab_study_history.dart';
import '../../const/static/global.dart';
import '../../const/value/colors.dart';
import '../../const/value/gaps.dart';
import '../../const/value/keys.dart';
import '../../const/value/text_style.dart';

class RouteMain extends StatefulWidget {
  const RouteMain({super.key});

  @override
  State<RouteMain> createState() => _RouteMainState();
}

class _RouteMainState extends State<RouteMain> {
  final pc = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chapter Book Quiz',
          style: TS.s20w700(colorPurple900),
        ),
      ),
      backgroundColor: colorWhite,
      body: SafeArea(
        child: PageView(
          controller: pc,
          //physics: const NeverScrollableScrollPhysics(),
          children: const [TabBook(), TabStudyHistory(), TabProfile()],

          onPageChanged: (value) {},
        ),
      ),
      bottomNavigationBar: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                final currentPageIndex = pc.page;
                if ((index - currentPageIndex!).abs() > 1) {
                  pc.jumpToPage(index);
                } else {
                  pc.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AnimatedBuilder(
                  animation: pc,
                  builder: (context, child) {
                    final pageIndex = pc.page ?? 0;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          index == 0
                              ? 'assets/icons/home.png'
                              : index == 1
                              ? 'assets/icons/video.png'
                              : 'assets/icons/person.png',
                          width: 28, // 이미지 너비 (옵션)
                          height: 28, // 이미지 높이 (옵션)
                          fit: BoxFit.cover,
                          color: pageIndex.toInt() == index ? colorPurple500 : colorPoint700, // 이미지 맞춤 방식 (옵션)
                        ),
                        Gaps.v5,
                        Text(
                          index == 0
                              ? 'Book'
                              : index == 1
                              ? 'Study'
                              : 'Profil',
                          style: TextStyle(
                            color: pageIndex.toInt() == index ? colorPurple500 : colorPoint700,
                            fontWeight: FontWeight.w400,
                            fontSize: 11, // 글씨 크기 조정
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
