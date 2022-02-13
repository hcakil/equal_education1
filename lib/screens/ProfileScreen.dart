import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/services/FileStorageService.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController = TextEditingController(text: appStore.userName);

  PickedFile? image;

  FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Widget profileImage() {
    if (image != null) {
      return Image.file(File(image!.path), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
    } else {
      if (getStringAsync(LOGIN_TYPE) == LoginTypeGoogle || getStringAsync(LOGIN_TYPE) == LoginTypeEmail) {
        return cachedImage(appStore.userProfileImage.validate(), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
      } else {
        return Icon(Icons.person_outline_rounded).paddingAll(16);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);
      setState(() {});

      Map<String, dynamic> req = {};

      if (nameController.text != appStore.userName) {
        req.putIfAbsent(UserKeys.name, () => nameController.text.trim());
      }

      if (image != null) {
        await uploadFile(file: File(image!.path), prefix: 'userProfiles').then((path) async {
          req.putIfAbsent(UserKeys.photoUrl, () => path);

          await setValue(USER_PHOTO_URL, path);
          appStore.setProfileImage(path);
        }).catchError((e) {
          toast(e.toString());
        });
      }

      await userDBService.updateDocument(req, appStore.userId).then((value) async {
        appStore.setLoading(false);
        appStore.setName(nameController.text);
        setValue(USER_DISPLAY_NAME, nameController.text);

        finish(context);
      });
    }
  }

  Future getImage() async {
    if (!isLoggedInWithGoogle()) {
      image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lbl_profile),
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
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 16,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                        child: profileImage(),
                      ),
                      Positioned(
                        child: CircleAvatar(
                          backgroundColor: colorPrimary,
                          radius: 15,
                          child: Icon(Icons.edit, color: white).onTap(() {
                            getImage();
                          }),
                        ),
                        right: 8,
                        bottom: 8,
                      ).visible(!isLoggedInWithGoogle()),
                    ],
                  ).paddingOnly(top: 16, bottom: 16).center(),
                  Observer(builder: (context) => Text(appStore.userName!, style: boldTextStyle(size: 20)).center()),
                  4.height,
                  Text('Points: ${getIntAsync(USER_POINTS)}', style: boldTextStyle(size: 18, color: colorPrimary)).center(),
                  16.height,
                  Divider(),
                  16.height,
                  Text(lbl_name, style: primaryTextStyle()),
                  8.height,
                  isLoggedInWithGoogle()
                      ? Text(appStore.userName!, style: boldTextStyle())
                      : AppTextField(
                          controller: nameController,
                          textFieldType: TextFieldType.NAME,
                          focus: nameFocus,
                          decoration: inputDecoration(hintText: lbl_name_hint),
                        ),
                  16.height,
                  Text(lbl_email_id, style: primaryTextStyle()),
                  8.height,
                  Text(appStore.userEmail!, style: boldTextStyle()),
                  30.height,
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
                      child: Text(lbl_update_profile, style: primaryTextStyle(color: white)),
                      onPressed: update,
                    ),
                  ).visible(!isLoggedInWithGoogle()),
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
