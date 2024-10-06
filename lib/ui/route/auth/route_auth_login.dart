import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_prac/ui/route/auth/route_auth_find_id.dart';
import 'package:login_prac/ui/route/auth/route_auth_find_pw.dart';
import 'package:login_prac/ui/route/auth/route_auth_sign_up.dart';
import 'package:login_prac/ui/route/auth/route_auth_sns_sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../const/enums/enums.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/button/purple_button.dart';
import '../../component/textfield_border.dart';
import '../../dialog/dialog_confirm.dart';
import '../route_splash.dart';

class RouteAuthLogin extends StatefulWidget {
  const RouteAuthLogin({super.key});

  @override
  State<RouteAuthLogin> createState() => _RouteLoginState();
}

class _RouteLoginState extends State<RouteAuthLogin> {
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecPw = TextEditingController();
  final ValueNotifier<bool> vnObscureTextNotifier = ValueNotifier<bool>(true);

  // final ValueNotifier<bool> vnIsCheck = ValueNotifier(false);
  bool isPasswordOverSix = false;

  @override
  void dispose() {
    tecEmail.dispose();
    tecPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: [

                  SizedBox(height: 30.w,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final UserCredential? userCredential = await Utils.onGoogleTap();
                          if (userCredential != null) {
                            final uid = userCredential.user!.uid;
                            final userDs =
                                await FirebaseFirestore.instance.collection(keyUser).where(keyEmail, isEqualTo: userCredential.user!.email).get();
                            // 회원가입이 안됨
                            if (userDs.docs.isEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RouteAuthSnsSignUp(
                                    uid: uid,
                                    email: userCredential.user!.email!,
                                    loginType: LoginType.google,
                                  ),
                                ),
                              );
                            }

                            // 회원가입이 되어있음
                            else {
                              final pref = await SharedPreferences.getInstance();
                              pref.setString(keyUid, uid);
                              Navigator.of(context)
                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                            }
                          }
                        },
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Image.asset(
                            'assets/images/google.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                      Gaps.h20,

                      ///카카오 로그인
                      GestureDetector(
                        onTap: () async {
                          final String? uid = await Utils.onKakaoTap();
                          if (uid != null) {
                            final userDs = await FirebaseFirestore.instance.collection(keyUser).where(keyUid, isEqualTo: uid).get();
                            // 회원가입이 안됨
                            if (userDs.docs.isEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RouteAuthSnsSignUp(
                                    uid: uid,
                                    email: null,
                                    loginType: LoginType.kakao,
                                  ),
                                ),
                              );
                            }

                            // 회원가입이 되어있음
                            else {
                              final pref = await SharedPreferences.getInstance();
                              pref.setString(keyUid, uid);
                              Navigator.of(context)
                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                            }
                          }
                        },
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Image.asset(
                            'assets/images/kakao.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),


                      if (Platform.isIOS)
                        Row(
                          children: [
                            Gaps.h20,
                            GestureDetector(
                              onTap: () async {
                                final UserCredential? userCredential = await Utils.onAppleTap();
                                if (userCredential != null) {
                                  final uid = userCredential.user!.uid;
                                  final userDs = await FirebaseFirestore.instance
                                      .collection(keyUser)
                                      .where(keyEmail, isEqualTo: userCredential.user!.email)
                                      .get();
                                  // 회원가입이 안됨
                                  if (userDs.docs.isEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RouteAuthSnsSignUp(
                                          uid: uid,
                                          email: userCredential.user!.email!,
                                          loginType: LoginType.apple,
                                        ),
                                      ),
                                    );
                                  }

                                  // 회원가입이 되어있음
                                  else {
                                    final pref = await SharedPreferences.getInstance();
                                    pref.setString(keyUid, uid);
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                                  }
                                }
                              },
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Image.asset(
                                  'assets/images/apple.png',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                  Gaps.v86,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginCheck(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (tecEmail.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          desc: 'Enter Email',
        ),
      );
      return;
    }

    if (tecPw.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          desc: 'Enter password',
        ),
      );
      return;
    }

    final targetUserDs = await FirebaseFirestore.instance.collection(keyUser).where(keyEmail, isEqualTo: tecEmail.text).get();
    if (targetUserDs.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          desc: 'This user is not exist',
        ),
      );
      return;
    }
    final targetUser = ModelUser.fromJson(targetUserDs.docs.first.data());

    if (targetUser.pw != tecPw.text) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(
          desc: 'Password is not matched',
        ),
      );
      return;
    }

    final pref = await SharedPreferences.getInstance();
    pref.setString(keyUid, targetUser.uid);

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
  }
}

class _WidgetText extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const _WidgetText({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.transparent,
          child: Text(
            title,
            style: const TS.s13w400(colorGray600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
