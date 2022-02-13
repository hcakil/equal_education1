import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/screens/DashboardScreen.dart';
import 'package:quizapp_flutter/screens/EditUserDetailScreen.dart';
import 'package:quizapp_flutter/screens/RegisterScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController(text: kReleaseMode ? '' : '');
  TextEditingController passController = TextEditingController(text: kReleaseMode ? '' : '');

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> loginWithEmail() async {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      authService.signInWithEmailPassword(email: emailController.text, password: passController.text).then((value) {
        appStore.setLoading(false);

        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  Future<void> loginWithGoogle() async {
    appStore.setLoading(true);

    await authService.signInWithGoogle().then((value) {
      appStore.setLoading(false);

      if (getStringAsync(USER_AGE).isNotEmpty) {
        DashboardScreen().launch(context);
      } else {
        EditUserDetailScreen(isFromGoogle: true).launch(context);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(LoginPageImage,color: colorPrimary, height: context.height() * 0.35, width: context.width(), fit: BoxFit.fill),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: Image.asset(LoginPageLogo, width: 80, height: 80),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lbl_sign_in, style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lbl_do_not_have_account, style: primaryTextStyle(color: white)),
                              4.width,
                              Text(lbl_sign_up, style: boldTextStyle(color: white, size: 18)).onTap(() {
                                RegisterScreen().launch(context);
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lbl_email_id, style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: emailController,
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocus,
                        nextFocus: passFocus,
                        decoration: inputDecoration(hintText: lbl_email_hint),
                      ),
                      16.height,
                      Text(lbl_password, style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: passController,
                        focus: passFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(hintText: lbl_password_hint),
                      ),
                      30.height,
                      gradientButton(text: lbl_sign_in, onTap: loginWithEmail, context: context, isFullWidth: true),
                      16.height,
                      Container(
                        padding: EdgeInsets.only(top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Text(lbl_sign_up, style: boldTextStyle()).center(),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() {
                        RegisterScreen().launch(context);
                      }),
                      30.height,
                      Row(
                        children: [
                          Divider(thickness: 2).expand(),
                          8.width,
                          Text('', style: secondaryTextStyle()),
                          8.width,
                          Divider(thickness: 2).expand(),
                        ],
                      ),
                      30.height,
                    /*  Container(
                        padding: EdgeInsets.only(top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleLogoWidget(),
                            16.width,
                            Text(lbl_login_with_google, style: boldTextStyle()).center(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() {
                        loginWithGoogle();
                      }),*/
                    ],
                  ).paddingOnly(left: 16, right: 16),
                ),
                16.height,
              ],
            ),
          ),
          Observer(builder: (context) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
