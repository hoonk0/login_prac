import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../component/basic_button.dart';
import '../../component/textfield_border.dart';
import '../../dialog/dialog_confirm.dart';
import 'detail/route_auth_find_id_detail.dart';

class RouteAuthFindId extends StatefulWidget {
  const RouteAuthFindId({super.key});

  @override
  State<RouteAuthFindId> createState() => _RouteAuthFindIdState();
}

class _RouteAuthFindIdState extends State<RouteAuthFindId> {
  final TextEditingController tecNickname = TextEditingController();

  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    tecNickname.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    tecNickname.dispose();
    tecNickname.removeListener(_updateSignUpButtonState);
    super.dispose();
  }

  void _updateSignUpButtonState() {
    vnSignUpButtonEnabled.value = tecNickname.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find ID'),
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
                        // Appbar
                        Gaps.v36,
                        // 이메일
                        const Text('Nickname', style: TS.s14w500(colorGray900)),
                        Gaps.v10,
                        ValueListenableBuilder(
                          valueListenable: tecNickname,
                          builder: (context, value, child) {
                            return TextFieldBorder(
                              controller: tecNickname,
                              hintText: 'Enter Nickname',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: vnSignUpButtonEnabled,
                  builder: (context, vnSignUpButtonEnabled, child) {
                    return BasicButton(
                      title: 'Find ID',
                      titleColorBg: vnSignUpButtonEnabled ? colorWhite : colorGray500,
                      colorBg: vnSignUpButtonEnabled ? colorPurple500 : colorPoint800,
                      onTap: vnSignUpButtonEnabled ? _findId : null,
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

  Future<void> _findId() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final nickname = tecNickname.text;
    final listUserQs = await FirebaseFirestore.instance.collection(keyUser).where(keyNickname, isEqualTo: nickname).get();
    if (listUserQs.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogConfirm(desc: 'User is not exsit');
        },
      );
      return;
    }

    final listModelUser = listUserQs.docs.map((e) => ModelUser.fromJson(e.data())).toList();
    // 조건이 모두 맞으면 다이얼로그를 보여주지 않고 바로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RouteAuthFindIdDetail(
          modelUser: listModelUser.first,
        ),
      ),
    );
  }
}
