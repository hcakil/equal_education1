import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/UpgradeLevelDialogComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class EarnPointScreen extends StatefulWidget {
  static String tag = '/EarnPointScreen';

  @override
  EarnPointScreenState createState() => EarnPointScreenState();
}

class EarnPointScreenState extends State<EarnPointScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  late RewardedAd? rewardedAd;

  bool _isWatchVideo = true;
  bool _isRewardedAdReady = false;

  String? oldLevel, newLevel;

  @override
  void initState() {
    super.initState();
    init();
  }

  void createRewardedAd() {
    int numRewardedLoadAttempts = 0;
    RewardedAd.load(
      adUnitId: kReleaseMode ? mAdMobRewardId : RewardedAd.testAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('${ad.runtimeType} loaded.');
          rewardedAd = ad;
          numRewardedLoadAttempts = 0;
          _isRewardedAdReady = true;
          setState(() {});
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error');
          rewardedAd = null;
          numRewardedLoadAttempts += 1;
          if (numRewardedLoadAttempts <= maxFailedLoadAttempts) {
            createRewardedAd();
          }
        },
      ),
    );
  }

  void showRewardedAd() {
    if (rewardedAd == null) {
      log('attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('${ad.runtimeType} closed.');
        createRewardedAd();
        rewarded = true;
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        createRewardedAd();
        _isRewardedAdReady = false;
      },
    );
    rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      log('$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})');
      userDBService.updateDocument({UserKeys.points: FieldValue.increment(10)}, appStore.userId).then((value) {
        oldLevel = getLevel(points: getIntAsync('USER_POINTS'));
        setValue(USER_POINTS, getIntAsync(USER_POINTS) + 10);
        newLevel = getLevel(points: getIntAsync('USER_POINTS'));
        Future.delayed(2.seconds, () {
          if (oldLevel != newLevel) {
            showInDialog(
              context,
              child: UpgradeLevelDialogComponent(level: newLevel),
            );
          }
        });
      });
      setState(() {
        _isWatchVideo = false;
      });
    });
    rewardedAd = null;
  }

  Future<void> init() async {
    createRewardedAd();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earn Points'),
        backgroundColor: colorPrimary,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 16,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                    child: cachedImage(appStore.userProfileImage.validate(), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center),
                  ).center(),
                  16.height,
                  Observer(builder: (context) => Text(appStore.userName!, style: boldTextStyle(size: 20)).center()),
                  4.height,
                  Text('Points: ${getIntAsync(USER_POINTS)}', style: boldTextStyle(size: 18, color: colorPrimary)).center(),
                  16.height,
                  Divider(),
                  16.height,
                  Container(
                    width: context.width(),
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrimary, colorSecondary],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    child: TextButton(
                      child: Text(
                        'Watch Video',
                        style: primaryTextStyle(color: white),
                      ),
                      onPressed: () async {
                        appStore.setLoading(true);
                        await 2.seconds.delay;
                        appStore.setLoading(false);
                        if (_isRewardedAdReady) {
                          showRewardedAd();
                        } else {
                          toast('Failed to load a rewarded ad');
                        }
                      },
                    ),
                  ).visible(_isWatchVideo),
                ],
              ).paddingOnly(left: 16, right: 16),
            ),
          ),
          Observer(
            builder: (context) => Loader().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
