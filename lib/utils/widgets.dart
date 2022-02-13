import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

InputDecoration inputDecoration({String? hintText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
    fillColor: white,
    filled: true,
    hintText: hintText != null ? hintText : '',
    hintStyle: secondaryTextStyle(),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(defaultRadius)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(defaultRadius)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(defaultRadius)),
  );
}

Widget gradientButton({required String text, Function? onTap, bool isFullWidth = false, BuildContext? context}) {
  return Container(
    width: isFullWidth ? context!.width() : null,
    padding: EdgeInsets.only(left: 30, right: 30),
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
        text,
        style: boldTextStyle(color: white),
      ),
      onPressed: onTap as void Function()?,
    ),
  );
}

Widget cachedImage(String url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launch(url, forceWebView: forceWebView, enableJavaScript: true).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

bool isLoggedInWithGoogle() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeGoogle;
}

String getLevel({required int points}) {
  if (points < 100) {
    return Level0;
  } else if (points >= 100 && points < 200) {
    return Level1;
  } else if (points >= 200 && points < 300) {
    return Level2;
  } else if (points >= 300 && points < 400) {
    return Level3;
  } else if (points >= 400 && points < 500) {
    return Level4;
  } else if (points >= 500 && points < 600) {
    return Level5;
  } else if (points >= 600 && points < 700) {
    return Level6;
  } else if (points >= 700 && points < 800) {
    return Level7;
  } else if (points >= 800 && points < 900) {
    return Level8;
  } else if (points >= 900 && points < 1000) {
    return Level9;
  } else if (points >= 1000) {
    return Level10;
  } else {
    return '';
  }
}

Widget emptyWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(EmptyImage, height: 150, fit: BoxFit.cover),
      Text('No data found', style: boldTextStyle(size: 20)),
    ],
  ).center();
}
