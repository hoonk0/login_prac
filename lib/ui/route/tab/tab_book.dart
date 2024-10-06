import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_prac/const/enums/enums.dart';
import 'package:login_prac/const/model/model_user.dart';
import 'package:login_prac/const/static/global.dart';
import 'package:login_prac/const/value/keys.dart';
import 'package:login_prac/ui/route/route_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBook extends ConsumerStatefulWidget {
  const TabBook({super.key});

  @override
  ConsumerState<TabBook> createState() => _TabBookState();
}

class _TabBookState extends ConsumerState<TabBook> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 로그아웃
        ElevatedButton(
          onPressed: () async {
            final pref = await SharedPreferences.getInstance();
            pref.remove('uid');

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RouteSplash(),
              ),
              (route) => false,
            );
          },
          child: Text('test'),
        ),

        /// 탈퇴
        ElevatedButton(
          onPressed: () async {
            FirebaseFirestore.instance.collection(keyUser).doc(Global.userNotifier.value!.uid).delete();

            final pref = await SharedPreferences.getInstance();
            pref.remove('uid');

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RouteSplash(),
              ),
              (route) => false,
            );
          },
          child: Text('test'),
        ),
      ],
    );
  }
}
