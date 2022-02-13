import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('About', showBack: true, color: colorPrimary, textColor: white),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mAppName, style: primaryTextStyle(size: 30)),
            16.height,
            Container(
              decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(4)),
              height: 4,
              width: 100,
            ),
            16.height,
            Text('version', style: secondaryTextStyle()),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (_, snap) {
                if (snap.hasData) {
                  return Text('${snap.data!.version.validate()}', style: primaryTextStyle());
                }
                return SizedBox();
              },
            ),
            16.height,
            Text(
              mAboutApp,
              style: primaryTextStyle(size: 14),
              textAlign: TextAlign.justify,
            ),
            16.height,
            AppButton(
              color: colorPrimary,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.contact_support_outlined, color: Colors.white),
                  8.width,
                  Text('Contact Us', style: boldTextStyle(color: white)),
                ],
              ),
              onTap: () {
                launchUrl('mailto:${getStringAsync(CONTACT_PREF)}');
              },
            ),
            16.height,
            AppButton(
              color: colorPrimary,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/purchase.png', height: 24, color: white),
                  8.width,
                  Text('Get More Apps', style: boldTextStyle(color: white)),
                ],
              ),
              onTap: () {
                launchUrl(mBaseUrl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
