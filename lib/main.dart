
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/screens/SplashScreen.dart';
import 'package:quizapp_flutter/services/AuthService.dart';
import 'package:quizapp_flutter/services/CategoryService.dart';
import 'package:quizapp_flutter/services/DailyQuizService.dart';
import 'package:quizapp_flutter/services/QuestionService.dart';
import 'package:quizapp_flutter/services/QuizHistoryService.dart';
import 'package:quizapp_flutter/services/QuizService.dart';
import 'package:quizapp_flutter/services/SettingService.dart';
import 'package:quizapp_flutter/services/userDBService.dart';
import 'package:quizapp_flutter/store/AppStore.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;

AuthService authService = AuthService();
UserDBService userDBService = UserDBService();
CategoryService categoryService = CategoryService();
QuestionService questionService = QuestionService();
QuizService quizService = QuizService();
QuizHistoryService quizHistoryService = QuizHistoryService();
DailyQuizService dailyQuizService = DailyQuizService();
AppSettingService appSettingService = AppSettingService();

bool bannerReady = false;
bool interstitialReady = false;
bool rewarded = false;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    MobileAds.instance.initialize();
   // Appodeal.setAppKeys(androidAppKey: '41b32ee4957eaf8343678641261ed0d4e76703456680a293');
  });

  defaultRadius = 12.0;
  defaultAppButtonRadius = 12.0;
  await initialize(); //Shared Preferences

  setOrientationPortrait();

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setName(getStringAsync(USER_DISPLAY_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setProfileImage(getStringAsync(USER_PHOTO_URL));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
        scaffoldBackgroundColor: scaffoldColor,
      ),
      home: SplashScreen(),
    );
  }
}
