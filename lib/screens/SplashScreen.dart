import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/screens/DashboardScreen.dart';
import 'package:quizapp_flutter/screens/LoginScreen.dart';
import 'package:quizapp_flutter/screens/WalkThroughScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(scaffoldColor);

    Future.delayed(Duration(seconds: 2), () {
      if (appStore.isLoggedIn) {
        DashboardScreen().launch(context, isNewTask: true);
      } else {
        if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
          WalkThroughScreen().launch(context, isNewTask: true);
        } else {
          LoginScreen().launch(context, isNewTask: true);
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(appLogoImage, height: 150, width: 150),
            16.height,
            Text(lbl_online_education, style: boldTextStyle(size: 24)),
          ],
        ),
      ),
    );
  }
}
