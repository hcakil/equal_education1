
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizHistoryComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:quizapp_flutter/screens/QuizHistoryDetailScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class MyQuizHistoryScreen extends StatefulWidget {
  static String tag = '/MyQuizHistoryScreen';

  @override
  MyQuizHistoryScreenState createState() => MyQuizHistoryScreenState();
}

class MyQuizHistoryScreenState extends State<MyQuizHistoryScreen> {
  BannerAd? myBanner;

  List<String> dropdownItems = [
    All,
    EducationTypeDaily,
    EducationTypeSelfChallenge,
    EducationTypeCategory
  ];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    init();
   // initAppodeal();
  }

 /* initAppodeal() async {
    await Appodeal.initialize(
        hasConsent: true,
        adTypes: [AdType.BANNER,],
        testMode: true);

    Appodeal.setBannerCallback((event) {
      if(event=="onBannerShown")
      {
        print("shown banner");
      }
    }
      );
  }
*/
  Future<void> init() async {
    dropdownValue = dropdownItems.first;

    if (!getBoolAsync(DISABLE_AD)) {
      myBanner = buildBannerAd()..load();
    }
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('${ad.runtimeType} loaded.');
          myBanner = ad as BannerAd?;
          myBanner!.load();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          bannerReady = true;
        },
        onAdOpened: (Ad ad) {
          log('${ad.runtimeType} onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          log('${ad.runtimeType} closed.');
          ad.dispose();
        },
      ),
    );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: colorPrimary,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return List.generate(dropdownItems.length, (index) {
                return PopupMenuItem(
                  value: dropdownItems[index],
                  child: Text('${dropdownItems[index]}',
                      style: primaryTextStyle()),
                );
              });
            },
            onSelected: (dynamic value) {
              dropdownValue = value;
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder(
            future: quizHistoryService.quizHistoryByQuizType(
                quizType: dropdownValue),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QuizHistoryModel> data =
                    snapshot.data as List<QuizHistoryModel>;
                return data.isNotEmpty
                    ? ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          QuizHistoryModel? mData = data[index];
                          return QuizHistoryComponent(quizHistoryData: mData)
                              .onTap(() {
                            QuizHistoryDetailScreen(quizHistoryData: mData)
                                .launch(context);
                          });
                        },
                      )
                    : emptyWidget();
              }
              return snapWidgetHelper(snapshot,
                  defaultErrorMessage: errorSomethingWentWrong);
            },
          ).paddingAll(16),
          if (!getBoolAsync(DISABLE_AD) && myBanner != null)
            Positioned(
              child: Container(
                  child: myBanner != null
                      ? AdWidget(ad: myBanner!) //showBanner() //
                      : SizedBox(),
                  color: Colors.white),
              height: myBanner!.size.height.toDouble(),
              bottom: 0,
              width: context.width(),
            ),
        ],
      ),
    );
  }

 /* showBanner() async{
var isReady = await Appodeal.isReadyForShow(AdType.BANNER);
    if(isReady)
    return Appodeal.show(AdType.BANNER, placementName: "banner1");
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Banner not Ready")));
            return ;
          }
  }*/
}
