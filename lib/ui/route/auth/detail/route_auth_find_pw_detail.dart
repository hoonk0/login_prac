import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../const/model/model_user.dart';
import '../../../../const/value/colors.dart';
import '../../../../const/value/gaps.dart';
import '../../../../const/value/keys.dart';
import '../../../../const/value/text_style.dart';
import '../../../../service/utils/utils.dart';
import '../../../component/basic_button.dart';
import '../../../component/textfield_border.dart';
import '../route_auth_login.dart';

class RouteAuthFindPwDetail extends StatefulWidget {
  final ModelUser modelUser;

  const RouteAuthFindPwDetail({
    super.key,
    required this.modelUser,
  });

  @override
  State<RouteAuthFindPwDetail> createState() => _RouteAuthFindPwDetailState();
}

class _RouteAuthFindPwDetailState extends State<RouteAuthFindPwDetail> {
  final TextEditingController tecPw = TextEditingController();
  final TextEditingController tecPwConfirm = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);
  final ValueNotifier<bool> vnObscurePwNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> vnObscurePwConfirmNotifier = ValueNotifier<bool>(true);

  bool isPasswordMatch = false;

  @override
  void initState() {
    super.initState();
    tecPw.addListener(_updateSignUpButtonState);
    tecPwConfirm.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    tecPw.dispose();
    tecPwConfirm.dispose();
    super.dispose();
  }

  void _updateSignUpButtonState() {
    vnSignUpButtonEnabled.value = tecPw.text.isNotEmpty && tecPw.text == tecPwConfirm.text && Utils.regExpPw.hasMatch(tecPw.text);
    debugPrint("vnSignUpButtonEnabled.value ${vnSignUpButtonEnabled.value}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Password'),
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

                        /// New Password
                        const Text(
                          'New Password',
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
                                  errorText: tecPw.text.isEmpty || Utils.regExpPw.hasMatch(tecPw.text) ? null : '6 characters or more',
                                  controller: tecPw,
                                  obscureText: _obscurePw,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 16.0),
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 16.0),
                                  hintText: 'Re-enter Password',
                                  errorText: tecPwConfirm.text.isEmpty || tecPw.text == tecPwConfirm.text ? null : 'Password does not match',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePwConfirm ? Icons.visibility_off : Icons.visibility,
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
                      title: 'Complete Change',
                      titleColorBg: isButtonEnabled ? colorWhite : colorGray500,
                      colorBg: isButtonEnabled ? colorPurple500 : colorPoint800,
                      onTap: isButtonEnabled ? _findPw : null,
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

  /// Find Password
  Future<void> _findPw() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final pw = tecPw.text;

    await FirebaseFirestore.instance.collection(keyUser).doc(widget.modelUser.uid).update({keyPw: pw});

    Utils.toast(desc: "Password has been changed");

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const RouteAuthLogin(),
      ),
      (route) => false,
    );
  }

  void showBottomDialog(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 80),
            decoration: const BoxDecoration(
              color: colorBlack,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Text(
              'Password has been changed.',
              style: TS.s14w500(colorWhite),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
