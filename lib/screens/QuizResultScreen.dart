import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/UpgradeLevelDialogComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:quizapp_flutter/screens/DashboardScreen.dart';
import 'package:quizapp_flutter/screens/QuizHistoryDetailScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class QuizResultScreen extends StatefulWidget {
  static String tag = '/QuizResultScreen';

  final QuizHistoryModel? quizHistoryData;
  final String? oldLevel, newLevel;

  QuizResultScreen({this.quizHistoryData, this.oldLevel, this.newLevel});

  @override
  QuizResultScreenState createState() => QuizResultScreenState();
}

class QuizResultScreenState extends State<QuizResultScreen> {
  late double? percentage;

  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    init();
  }

  void createInterstitialAd() {
    int numInterstitialLoadAttempts = 0;
    InterstitialAd.load(
      adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('${ad.runtimeType} loaded.');
          interstitialReady = true;
          interstitialAd = ad;
          numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd(BuildContext context) {
    if (interstitialAd == null) {
      log('attempt to show interstitial before loaded.');
      finish(context);
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  init() async {
    percentage = (widget.quizHistoryData!.rightQuestion! / widget.quizHistoryData!.totalQuestion!) * 100;
    Future.delayed(2.seconds, () {
      if (widget.oldLevel != widget.newLevel) {
        showInDialog(
          context,
          child: UpgradeLevelDialogComponent(level: widget.newLevel),
        );
      }
    });

    if (!getBoolAsync(DISABLE_AD)) {
      createInterstitialAd();
    }
  }

  String? resultWiseImage() {
    if (percentage! >= 0 && percentage! <= 30) {
      return ResultTryAgainImage;
    } else if (percentage! > 30 && percentage! <= 60) {
      return ResultAverageImage;
    } else if (percentage! > 60 && percentage! <= 90) {
      return ResultGoodJobImage;
    } else if (percentage! > 90) {
      return ResultExcellentImage;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
    if (interstitialAd != null) {
      showInterstitialAd(context);
      interstitialAd?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: context.width(),
            height: context.height(),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ResultBgImage), fit: BoxFit.fill),
            ),
          ),
          Container(
            height: context.height() * 0.80,
            width: context.width(),
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset(
                  ResultCardImage,
                  fit: BoxFit.fill,
                  width: context.width(),
                ).paddingOnly(top: 100),
                Positioned(top: 0, height: 200, width: 200, child: Image.asset(resultWiseImage()!)),
                Image.asset(ResultCompleteImage, height: 200, width: 200),
                Text('${widget.quizHistoryData!.rightQuestion! * 10}', style: boldTextStyle(color: colorPrimary, size: 30)).paddingTop(30),
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            color: colorSecondary,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Total', style: boldTextStyle(color: white)),
                                4.height,
                                Text('${widget.quizHistoryData!.totalQuestion}', style: boldTextStyle(color: white)),
                              ],
                            ),
                          ).cornerRadiusWithClipRRect(defaultRadius),
                          16.width,
                          Container(
                            width: 70,
                            height: 70,
                            color: greenColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Right', style: boldTextStyle(color: white)),
                                4.height,
                                Text('${widget.quizHistoryData!.rightQuestion}', style: boldTextStyle(color: white)),
                              ],
                            ),
                          ).cornerRadiusWithClipRRect(defaultRadius),
                          16.width,
                          Container(
                            width: 70,
                            height: 70,
                            color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Wrong', style: boldTextStyle(color: white)),
                                4.height,
                                Text('${widget.quizHistoryData!.totalQuestion! - widget.quizHistoryData!.rightQuestion!}', style: boldTextStyle(color: white)),
                              ],
                            ),
                          ).cornerRadiusWithClipRRect(defaultRadius),
                        ],
                      ),
                      16.height,
                      gradientButton(
                          text: 'See Answers',
                          onTap: () {
                            QuizHistoryDetailScreen(quizHistoryData: widget.quizHistoryData).launch(context);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              color: white,
              child: Icon(Icons.home, color: colorPrimary).onTap(() {
                DashboardScreen().launch(context, isNewTask: true);
              }),
            ).cornerRadiusWithClipRRect(defaultRadius),
          ),
        ],
      ),
    );
  }
}
