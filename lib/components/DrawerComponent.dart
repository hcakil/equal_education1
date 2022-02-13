import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/Model.dart';
import 'package:quizapp_flutter/screens/LoginScreen.dart';
import 'package:quizapp_flutter/screens/ProfileScreen.dart';
import 'package:quizapp_flutter/utils/DataProviders.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerComponent extends StatefulWidget {
  static String tag = '/DrawerComponent';

  @override
  DrawerComponentState createState() => DrawerComponentState();
}

class DrawerComponentState extends State<DrawerComponent> {
  List<DrawerItemModel> drawerItemsList = getDrawerItems();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  void logout() {
    authService.logout().then((value) {
      LoginScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: context.width(),
        height: context.height(),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Observer(
                builder: (context) => appStore.userProfileImage.validate().isEmpty
                    ? Icon(Icons.person_outline, size: 40)
                    : cachedImage(appStore.userProfileImage.validate(), usePlaceholderIfUrlEmpty: true, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
              ),
              title: Observer(builder: (context) => Text(appStore.userName!, style: boldTextStyle())),
              subtitle: Text(getLevel(points: getIntAsync(USER_POINTS)), style: boldTextStyle(color: colorPrimary)),
              onTap: () {
                finish(context);
                ProfileScreen().launch(context);
              },
            ).paddingAll(16),
            Text(appStore.userEmail!, style: secondaryTextStyle()).paddingLeft(16),
            Divider(height: 20),
            Column(
              children: List.generate(drawerItemsList.length, (index) {
                DrawerItemModel mData = drawerItemsList[index];

                return SettingItemWidget(
                  leading: Image.asset(mData.image!, height: 30, width: 30),
                  title: mData.name!,
                  onTap: () {
                    if (mData.widget != null) {
                      LiveStream().emit(HideDrawerStream, true);
                      mData.widget.launch(context);
                    }
                    if (mData.name == lbl_home) {
                      finish(context);
                    } else if (mData.name == lbl_logout) {
                      showConfirmDialog(context, 'Do you want to logout?').then((value) {
                        if (value ?? false) {
                          logout();
                        }
                      });
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
