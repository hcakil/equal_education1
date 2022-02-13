import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/screens/DashboardScreen.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class EditUserDetailScreen extends StatefulWidget {
  static String tag = '/EditUserDetailScreen';

  final bool isFromGoogle;

  EditUserDetailScreen({this.isFromGoogle = false});

  @override
  EditUserDetailScreenState createState() => EditUserDetailScreenState();
}

class EditUserDetailScreenState extends State<EditUserDetailScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  List<String> ageRangeList = ['5 - 10', '10 - 15', '15 - 20', '20 - 25', '25 - 30', '30 - 35', '35 - 40', '40 - 45', '45 - 50'];

  TextEditingController nameController = TextEditingController();

  String? dropdownValue;

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
    dropdownValue = ageRangeList.first;
  }

  Future<void> editData() async {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      userDBService.updateDocument({UserKeys.age: dropdownValue.validate()}, appStore.userId).then((value) {
        appStore.setLoading(false);
        setValue(USER_AGE, dropdownValue.validate());
        DashboardScreen().launch(context);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
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
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(LoginPageImage, height: context.height() * 0.35, width: context.width(), fit: BoxFit.fill),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: Image.asset(
                        LoginPageLogo,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lbl_enter_details, style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          Icon(Icons.arrow_back, color: white).onTap(() {
                            finish(context);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.isFromGoogle
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lbl_name, style: primaryTextStyle()),
                                8.height,
                                AppTextField(
                                  controller: nameController,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: inputDecoration(
                                    hintText: lbl_name_hint,
                                  ),
                                ),
                                16.height,
                              ],
                            ),
                      Text(lbl_age, style: primaryTextStyle()),
                      8.height,
                      DropdownButtonFormField(
                        value: dropdownValue,
                        items: List.generate(
                          ageRangeList.length,
                          (index) {
                            return DropdownMenuItem(
                              value: ageRangeList[index],
                              child: Text('${ageRangeList[index]}', style: primaryTextStyle()),
                            );
                          },
                        ),
                        onChanged: (dynamic value) {
                          dropdownValue = value;
                        },
                        decoration: inputDecoration(),
                      ),
                      30.height,
                      gradientButton(text: lbl_save, onTap: editData, context: context, isFullWidth: true),
                    ],
                  ).paddingOnly(left: 16, right: 16),
                ),
                16.height,
              ],
            ),
          ),
          Observer(builder: (context) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
