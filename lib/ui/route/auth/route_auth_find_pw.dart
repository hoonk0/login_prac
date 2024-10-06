import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/basic_button.dart';
import '../../component/textfield_border.dart';
import '../../dialog/dialog_confirm.dart';
import 'detail/route_auth_find_pw_detail.dart';

class RouteAuthFindPw extends StatefulWidget {
  const RouteAuthFindPw({super.key});

  @override
  State<RouteAuthFindPw> createState() => _RouteAuthFindPwState();
}

class _RouteAuthFindPwState extends State<RouteAuthFindPw> {
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecEmailConfirm = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);
  final RegExp regExpEmail = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]{2,}$");
  final fn_2 = FocusNode();
  final fn = FocusNode();
  ModelUser? targetModelUser;

  String authNumber = 'doggaebi';
  final ValueNotifier<bool> vnIsAuthNumberMatch = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    tecEmail.addListener(_updateSignUpButtonState);
    tecEmailConfirm.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    tecEmail.dispose();
    tecEmailConfirm.dispose();
    super.dispose();
  }

  void _updateSignUpButtonState() {
    vnSignUpButtonEnabled.value = tecEmail.text.isNotEmpty &&
        regExpEmail.hasMatch(tecEmail.text) &&
        tecEmailConfirm.text.isNotEmpty &&
        vnIsAuthNumberMatch.value &&
        targetModelUser != null;
    debugPrint("vnSignUpButtonEnabled.value ${vnSignUpButtonEnabled.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Password'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.v36,

                        // 이메일
                        const Text('Email', style: TS.s14w500(colorGray900)),
                        Gaps.v10,
                        ValueListenableBuilder(
                          valueListenable: tecEmail,
                          builder: (context, value, child) {
                            final isEmailMatch = regExpEmail.hasMatch(tecEmail.text);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFieldBorder(

                                    controller: tecEmail,
                                    hintText: 'Enter Email',
                                    errorText: (tecEmail.text.isEmpty || isEmailMatch) ? null : 'Invalid Email format',
                                    onChanged: (value) {
                                      vnIsAuthNumberMatch.value = false;
                                      targetModelUser = null;
                                      _updateSignUpButtonState();
                                    },
                                    focusNode: fn_2,
                                  ),
                                ),
                                Gaps.h8,
                                BasicButton(
                                  width: 100,
                                  title: 'Send',
                                  colorBg: isEmailMatch ? colorPurple500 : colorPurple100,
                                  onTap: isEmailMatch
                                      ? () async {
                                          fn_2.unfocus();

                                          final userQs =
                                              await FirebaseFirestore.instance.collection(keyUser).where(keyEmail, isEqualTo: tecEmail.text).get();
                                          if (userQs.docs.isEmpty) {
                                            Utils.toast(desc: 'User is not exist');
                                            return;
                                          }
                                          final modelUser = ModelUser.fromJson(userQs.docs.first.data());
                                          targetModelUser = modelUser;
                                          Utils.toast(desc: 'Please wait few seconds');
                                          final random = Random();
                                          authNumber = random.nextInt(10000).toString().padLeft(4, '0');

                                          final result =
                                              await Utils.sendEmail(tecEmail.text, 'Welcome to Chapter book quiz', 'Verification number $authNumber');

                                          showDialog(
                                            context: context,
                                            builder: (context) => DialogConfirm(
                                              desc: result ? 'Sent successfully' : 'Sent fail',
                                            ),
                                          );
                                        }
                                      : null,
                                ),
                              ],
                            );
                          },
                        ),
                        Gaps.v10,
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldBorder(
                                focusNode: fn,
                                controller: tecEmailConfirm,
                                hintText: 'Enter Verification Code',
                                onChanged: (value) {
                                  vnIsAuthNumberMatch.value = false;
                                  _updateSignUpButtonState();
                                },
                              ),
                            ),
                            Gaps.h8,
                            ValueListenableBuilder(
                              valueListenable: vnIsAuthNumberMatch,
                              builder: (context, isAuthNumberMatch, child) {
                                return ValueListenableBuilder(
                                  valueListenable: tecEmailConfirm,
                                  builder: (context, tecEmailConfirm, child) {
                                    return BasicButton(
                                      width: 100,
                                      title: isAuthNumberMatch ? 'Confirmed' : 'Confirm',
                                      colorBg: tecEmailConfirm.text.isNotEmpty ? colorPurple500 : colorPurple100,
                                      onTap: () {
                                        if (tecEmailConfirm.text.isEmpty) return;
                                        fn.unfocus();
                                        vnIsAuthNumberMatch.value = authNumber == tecEmailConfirm.text;
                                        if (!vnIsAuthNumberMatch.value) {
                                          targetModelUser = null;
                                          Utils.toast(desc: 'Please confirm again');
                                        }
                                        _updateSignUpButtonState();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Gaps.v20,
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: vnSignUpButtonEnabled,
                  builder: (context, vnSignUpButtonEnabled, child) {
                    return BasicButton(
                      title: 'Find Password',
                      titleColorBg: vnSignUpButtonEnabled ? colorWhite : colorGray500,
                      colorBg: vnSignUpButtonEnabled ? colorPurple500 : colorPoint800,
                      onTap: vnSignUpButtonEnabled ? _findPw : null,
                    );
                  },
                ),
                Gaps.v10,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _findPw() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (tecEmail.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(desc: 'Please enter your email.'),
      );
      return;
    }

    if (!regExpEmail.hasMatch(tecEmail.text)) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(desc: 'Invalid email format.'),
      );
      return;
    }

    if (tecEmailConfirm.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(desc: 'Please enter the verification code.'),
      );
      return;
    }

    if (targetModelUser == null) {
      showDialog(
        context: context,
        builder: (context) => const DialogConfirm(desc: 'User is not appointed'),
      );
      return;
    }
    // 조건이 모두 맞으면 다이얼로그를 보여주지 않고 바로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RouteAuthFindPwDetail(modelUser: targetModelUser!),
      ),
    );
  }
}
