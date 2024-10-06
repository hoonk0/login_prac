import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_prac/const/static/global.dart';
import 'package:uuid/uuid.dart';
import '../../../const/enums/enums.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/basic_button.dart';
import '../../component/textfield_border.dart';
import '../../dialog/dialog_confirm.dart';
import 'detail/route_auth_sign_up_welcome.dart';

class RouteAuthSignUp extends StatefulWidget {
  const RouteAuthSignUp({super.key});

  @override
  State<RouteAuthSignUp> createState() => _RouteAuthSignUpState();
}

class _RouteAuthSignUpState extends State<RouteAuthSignUp> {
  final TextEditingController tecNickName = TextEditingController();
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecEmailConfirm = TextEditingController();
  final TextEditingController tecPw = TextEditingController();
  final TextEditingController tecPwConfirm = TextEditingController();

  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);
  final ValueNotifier<bool> vnObscurePwNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> vnObscurePwConfirmNotifier = ValueNotifier<bool>(true);
  final regExpEmail = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]{2,}$");

  //regPw 6글자 이상
  final regPw = RegExp(r'^.{6,}$');
  String authNumber = 'doggaebi';
  bool isPasswordMatch = false;
  final ValueNotifier<bool> vnIsAuthNumberMatch = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    // Listen to changes in all text controllers to update the button state
    tecNickName.addListener(_updateSignUpButtonState);
    tecEmail.addListener(_updateSignUpButtonState);
    tecEmailConfirm.addListener(_updateSignUpButtonState);
    tecPw.addListener(_updateSignUpButtonState);
    tecPwConfirm.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    tecNickName.dispose();
    tecEmail.dispose();
    tecEmailConfirm.dispose();
    tecPw.dispose();
    tecPwConfirm.dispose();

    vnObscurePwNotifier.dispose();
    vnObscurePwConfirmNotifier.dispose();
    vnSignUpButtonEnabled.dispose();

    super.dispose();
  }

  void _updateSignUpButtonState() {
    final allFieldsFilled = tecNickName.text.isNotEmpty &&
        tecEmail.text.isNotEmpty &&
        tecEmailConfirm.text.isNotEmpty &&
        tecPw.text.isNotEmpty &&
        tecPwConfirm.text.isNotEmpty;

    final isEmailValid = regExpEmail.hasMatch(tecEmail.text);
    final isPasswordValid = _isValidPassword();
    final isPasswordConfirmed = tecPw.text == tecPwConfirm.text;

    vnSignUpButtonEnabled.value =
        allFieldsFilled && isEmailValid && isPasswordValid && isPasswordConfirmed && vnIsAuthNumberMatch.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign Up',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Appbar

                        Gaps.v36,

                        /// 이메일
                        const Text(
                          'Email',
                          style: TS.s14w500(colorGray900),
                        ),
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
                                    },
                                  ),
                                ),
                                Gaps.h8,
                                BasicButton(
                                  width: 100,
                                  title: 'Send',
                                  colorBg: isEmailMatch ? colorPurple500 : colorPurple100,
                                  onTap: isEmailMatch
                                      ? () async {
                                          final userDs = await FirebaseFirestore.instance
                                              .collection(keyUser)
                                              .where(keyEmail, isEqualTo: tecEmail.text)
                                              .get();
                                          if (userDs.docs.isNotEmpty) {
                                            Utils.toast(desc: 'Already registered email');
                                            return;
                                          }
                                          Utils.toast(desc: 'Please wait few seconds');
                                          final random = Random();
                                          authNumber = random.nextInt(10000).toString().padLeft(4, '0');

                                          final result = await Utils.sendEmail(tecEmail.text,
                                              'Welcome to Chapter book quiz', 'Verification number $authNumber');

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
                                controller: tecEmailConfirm,
                                hintText: 'Enter Verification Code',
                                onChanged: (value) {
                                  vnIsAuthNumberMatch.value = false;
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
                                        vnIsAuthNumberMatch.value = authNumber == tecEmailConfirm.text;
                                        if (!vnIsAuthNumberMatch.value) {
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

                        /// 닉네임
                        const Text(
                          'Nickname',
                          style: TS.s14w500(colorGray900),
                        ),
                        Gaps.v10,
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldBorder(
                                controller: tecNickName,
                                hintText: 'Enter Nickname',
                              ),
                            ),
                            Gaps.h8,
                            ValueListenableBuilder(
                              valueListenable: tecNickName,
                              builder: (context, tecNickName, child) {
                                return BasicButton(
                                  width: 100,
                                  title: 'Check',
                                  colorBg: tecNickName.text.isNotEmpty ? colorPurple500 : colorPurple100,
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();

                                    final userDs = await FirebaseFirestore.instance
                                        .collection(keyUser)
                                        .where(keyNickname, isEqualTo: tecNickName.text)
                                        .get();
                                    if (userDs.docs.isNotEmpty) {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => DialogConfirm(
                                          desc: 'Not Available\nAlready using now',
                                        ),
                                      );
                                    } else {
                                      Utils.toast(desc: 'Available Nickname');

                                      _updateSignUpButtonState();
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),

                        Gaps.v22,

                        /*<<<<<<< HEAD
                          /// 비밀번호
                          Text(
                            'Password',
                            style: TS.s14w500(colorGray900),
                          ),
                          Gaps.v10,
                          ValueListenableBuilder(
                            valueListenable: tecPw,
                            builder: (context, isCheck, child) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: vnObscurePwNotifier,
                                builder: (context, _obscurePw, child) {
                                  return TextFieldBorder(
                                    controller: tecPw,
                                    obscureText: _obscurePw,
                                    hintText: 'Enter Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePw ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        vnObscurePwNotifier.value = !vnObscurePwNotifier.value;
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Gaps.v10,
                          ValueListenableBuilder(
                            valueListenable: tecPwConfirm,
                            builder: (context, isCheck, child) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: vnObscurePwConfirmNotifier,
                                builder: (context, _obscurePwConfirm, child) {
                                  return TextFieldBorder(
                                    controller: tecPwConfirm,
                                    obscureText: _obscurePwConfirm,
                                    hintText: 'Re-enter Password',
                                    errorText: _isPassConfirmValid(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePwConfirm ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        vnObscurePwConfirmNotifier.value = !vnObscurePwConfirmNotifier.value;
                                      },
      =======*/

                        /// 비밀번호
                        const Text(
                          'Password',
                          style: const TS.s14w500(colorGray900),
                        ),
                        Gaps.v10,
                        ValueListenableBuilder(
                          valueListenable: tecPw,
                          builder: (context, isCheck, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: vnObscurePwNotifier,
                              builder: (context, _obscurePw, child) {
                                return TextFieldBorder(
                                  errorText:
                                      tecPw.text.isEmpty || regPw.hasMatch(tecPw.text) ? null : '6 characters or more',
                                  controller: tecPw,
                                  obscureText: _obscurePw,
                                  hintText: 'Enter Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePw ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      vnObscurePwNotifier.value = !vnObscurePwNotifier.value;
                                    },
                                  ),
                                  onChanged: (value) {
                                    _updateSignUpButtonState();
                                  },
                                );
                              },
                            );
                          },
                        ),
                        Gaps.v10,
                        ValueListenableBuilder(
                          valueListenable: tecPwConfirm,
                          builder: (context, isCheck, child) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: vnObscurePwConfirmNotifier,
                              builder: (context, _obscurePwConfirm, child) {
                                return TextFieldBorder(
                                  controller: tecPwConfirm,
                                  obscureText: _obscurePwConfirm,
                                  hintText: 'Re-enter Password',
                                  errorText: tecPwConfirm.text.isEmpty || tecPw.text == tecPwConfirm.text
                                      ? null
                                      : 'Password does not match',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePwConfirm ? Icons.visibility_off : Icons.visibility,
                                      /*>>>>>>> 1bb1d116f3d65c92c7e5becb715d8d80d8ad1cc8*/
                                    ),
                                    onPressed: () {
                                      vnObscurePwConfirmNotifier.value = !vnObscurePwConfirmNotifier.value;
                                    },
                                  ),
                                  onChanged: (value) {
                                    _updateSignUpButtonState();
                                  },
                                );
                              },
                            );
                          },
                        ),

                        Gaps.v10,
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: vnSignUpButtonEnabled,
                  builder: (context, isButtonEnabled, child) {
                    return BasicButton(
                      title: 'Done',
                      titleColorBg: isButtonEnabled ? colorWhite : colorGray500,
                      colorBg: isButtonEnabled ? colorPurple500 : colorPoint800,
                      onTap: isButtonEnabled ? _signUp : null,
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

  /// 비밀번호 검사
  bool _isValidPassword() {
    // 6글자 이상 정규식
    RegExp regex = RegExp(r'^.{6,}$');
    return regex.hasMatch(tecPw.text);
  }

  /// Sign Up
  Future<void> _signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final uid = const Uuid().v4();

    final modelUser = ModelUser(
      uid: uid,
      email: tecEmail.text,
      pw: tecPw.text,
      nickname: tecNickName.text,
      loginType: LoginType.email,
    );
    await FirebaseFirestore.instance.collection(keyUser).doc(modelUser.uid).set(modelUser.toJson());

    //FirebaseFirestore.instance.collection(keyUser).doc(Global.userNotifier.value!.uid).

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RouteAuthSignUpWelcome(),
      ),
    );
  }
}
