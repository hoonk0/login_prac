import 'package:flutter/material.dart';
import '../../../../const/model/model_user.dart';
import '../../../../const/static/global.dart';
import '../../../../const/value/colors.dart';
import '../../../../const/value/gaps.dart';
import '../../../../const/value/text_style.dart';
import '../../../component/basic_button.dart';
import '../route_auth_find_pw.dart';
import '../route_auth_login.dart';

class RouteAuthFindIdDetail extends StatelessWidget {
  final ModelUser modelUser;

  const RouteAuthFindIdDetail({super.key, required this.modelUser});

  @override
  Widget build(BuildContext context) {
    final emailFore = modelUser.email.split('@').toList()[0];
    final emailBack = modelUser.email.split('@').toList()[1];
    final emailForeObscure = emailFore.substring(0, 3).padRight(emailFore.length, '*');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gaps.v188,
              Text(
                'Your ID is\n$emailForeObscure@$emailBack',
                style: const TS.s20w600(colorGray900),
                textAlign: TextAlign.center,
              ),
              Gaps.v50,
              BasicButton(
                  title: 'Login',
                  colorBg: colorPurple500,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RouteAuthLogin(),
                      ),
                      (route) => false,
                    );
                  }),
              Gaps.v16,
              GestureDetector(
                onTap: () {
                  Navigator.of(Global.contextSplash!).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const RouteAuthFindPw(),
                    ),
                    (route) => false,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Find Password',
                      style: TS.s14w600(colorGray600),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: colorGray600,
                    ),
                  ],
                ),
              ),
              Gaps.v20,
              const Text(
                'Accounts registered via social media cannot reset passwords.Please log in with your social account on the login screen.',
                style: TS.s13w500(colorPoint700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
