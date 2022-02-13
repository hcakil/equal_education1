import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/Model.dart';
import 'package:quizapp_flutter/screens/LoginScreen.dart';
import 'package:quizapp_flutter/utils/DataProviders.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController? pageController;
  int currentPage = 0;
  List<WalkThroughItemModel> pages = getWalkThroughItems();

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
    pageController = PageController(initialPage: currentPage);
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
          PageView(
            controller: pageController,
            children: List.generate(pages.length, (index) {
              return Column(
                children: [
                  Image.asset(pages[index].image!, width: context.width(), height: context.height() * 0.5, fit: BoxFit.cover),
                  50.height,
                  Column(
                    children: [
                      Text(pages[index].title!, style: boldTextStyle(size: 30), textAlign: TextAlign.center).paddingOnly(left: 30, right: 30),
                      30.height,
                      Text(
                        pages[index].subTitle!,
                        textAlign: TextAlign.center,
                      ).paddingOnly(left: 30, right: 30),
                    ],
                  ),
                  16.height,
                ],
              );
            }),
            onPageChanged: (value) {
              currentPage = value;
              setState(() {});
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await setValue(IS_FIRST_TIME, false);
                    LoginScreen().launch(context);
                  },
                  child: Text('Skip', style: boldTextStyle(color: grey)),
                ),
                DotIndicator(
                  pages: pages,
                  pageController: pageController!,
                  indicatorColor: colorPrimary,
                ),
                AppButton(
                  child: currentPage != 2 ? Icon(Icons.navigate_next, color: white, size: 30) : Text('Get Started', style: boldTextStyle(color: white)),
                  color: colorPrimary,
                  onTap: () async {
                    if (currentPage != 2) {
                      pageController!.animateToPage(++currentPage, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                    } else {
                      await setValue(IS_FIRST_TIME, false);
                      LoginScreen().launch(context, isNewTask: true);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
