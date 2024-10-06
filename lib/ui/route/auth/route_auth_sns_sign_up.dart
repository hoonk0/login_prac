import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/enums/enums.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../component/basic_button.dart';
import '../../component/textfield_border.dart';
import '../../dialog/dialog_confirm.dart';
import 'detail/route_auth_sign_up_welcome.dart';

class RouteAuthSnsSignUp extends StatefulWidget {
  final String uid;
  final String? email;
  final LoginType loginType;

  const RouteAuthSnsSignUp({
    super.key,
    required this.uid,
    this.email,
    required this.loginType,
  });

  @override
  State<RouteAuthSnsSignUp> createState() => _RouteAuthSnsSignUpState();
}

class _RouteAuthSnsSignUpState extends State<RouteAuthSnsSignUp> {
  final TextEditingController tecNickName = TextEditingController();
  final ValueNotifier<bool> vnIsComplete = ValueNotifier(false);
  final fn = FocusNode();

  @override
  void dispose() {
    tecNickName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sns가입'),
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
                            flex: 3,
                            child: TextFieldBorder(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                              focusNode: fn,
                              controller: tecNickName,
                              hintText: 'Enter Nickname',
                              onChanged: (value) {
                                vnIsComplete.value = false;
                              },
                            ),
                          ),
                          Gaps.h8,
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: tecNickName,
                              builder: (context, tecNickName, child) {
                                return BasicButton(
                                  title: 'Check',
                                  colorBg: tecNickName.text.isNotEmpty ? colorPurple500 : colorPurple100,
                                  onTap: () async {
                                    fn.unfocus();
                                    final userDs =
                                        await FirebaseFirestore.instance.collection(keyUser).where(keyNickname, isEqualTo: tecNickName.text).get();
                                    if (userDs.docs.isNotEmpty) {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => DialogConfirm(
                                          desc: 'Not Available\nAlready using now',
                                        ),
                                      );
                                    } else {
                                      vnIsComplete.value = true;
                                      await showDialog(
                                        context: context,
                                        builder: (context) => DialogConfirm(
                                          desc: 'Available',
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      Gaps.v22,
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: vnIsComplete,
                builder: (context, isComplete, child) {
                  return BasicButton(
                    title: 'Done',
                    titleColorBg: isComplete ? colorWhite : colorGray500,
                    colorBg: isComplete ? colorPurple500 : colorPoint800,
                    onTap: isComplete
                        ? () async {
                            debugPrint("dd");
                            final modelUser = ModelUser(
                              uid: widget.uid,
                              email: widget.email == null ? 'kakaoLogin' : widget.email!,
                              pw: 'appdoggaebi1!',
                              nickname: tecNickName.text,
                              loginType: widget.loginType,
                            );
                            try {
                              await FirebaseFirestore.instance.collection(keyUser).doc(modelUser.uid).set(modelUser.toJson());


                              final pref = await SharedPreferences.getInstance();

                              pref.setString('uid', widget.uid);

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RouteAuthSignUpWelcome()));
                            } catch (e) {}
                          }
                        : null,
                  );
                },
              ),
              Gaps.v10,
            ],
          ),
        ),
      ),
    );
  }
}
