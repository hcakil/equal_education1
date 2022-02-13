import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/RegisterScreen';

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode nameFocus = FocusNode();

  List<String> ageRangeList = [
    '5 - 10',
    '10 - 15',
    '15 - 20',
    '20 - 25',
    '25 - 30',
    '30 - 35',
    '35 - 40',
    '40 - 45',
    '45 - 50'
  ];

  List<String> jobList = [
    'Teacher - Primary Sch.',
    'Teacher - High Sch.',
    'Teacher - Collage',
    'Student - Primary Sch.',
    'Student - High Sch.',
    'Student - Collage',
    'Farmer',
  ];

  List<String> learningStyleList = [
    'Visual',
    'Auditory',
    'Reading & Writing',
  ];

  List<String> disparityList = [
    'No',
    'Deaf',
    'Blind',
    'Autism',
    'Do not want to say',
  ];

  String? dropdownValueAge;
  String? dropdownValueJob;
  String? dropdownValueLearningStyle;
  String? dropdownValueDisparity;

  bool disparityVis = true;

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
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);

      await authService
          .signUpWithEmailPassword(
          name: nameController.text,
          email: emailController.text,
          password: passController.text.validate(),
          age: dropdownValueAge,
          job: dropdownValueJob,
          learningStyle: dropdownValueLearningStyle,
          disparity: dropdownValueDisparity ?? "No")
          .then((value) {
        appStore.setLoading(false);
        //DashboardScreen().launch(context, isNewTask: true);
        finish(context);
      }).catchError((e) {
        toast(e.toString());

        appStore.setLoading(false);
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
                    Image.asset(LoginPageImage,color:colorPrimary,
                        height: context.height() * 0.35,
                        width: context.width(),
                        fit: BoxFit.fill),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: Image.asset(LoginPageLogo, width: 80, height: 80),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lbl_sign_up,
                              style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lbl_already_have_an_account,
                                  style: primaryTextStyle(color: white)),
                              4.width,
                              Text(lbl_sign_in,
                                  style: boldTextStyle(color: white))
                                  .onTap(() {
                                finish(context);
                              }),
                            ],
                          )
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
                    children: [
                      Text(lbl_name, style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: nameController,
                        textFieldType: TextFieldType.NAME,
                        focus: nameFocus,
                        decoration: inputDecoration(hintText: lbl_name_hint),
                      ),
                      16.height,
                      Text(lbl_email_id, style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: emailController,
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocus,
                        nextFocus: passFocus,
                        decoration: inputDecoration(hintText: lbl_email_hint),
                      ),
                      16.height,
                      Text(lbl_password, style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: passController,
                        focus: passFocus,
                        nextFocus: nameFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(
                          hintText: lbl_password_hint,
                        ),
                      ),
                      16.height,
                      Text(lbl_age, style: primaryTextStyle()),
                      8.height,
                      DropdownButtonFormField(
                        hint: Text('Select Age', style: secondaryTextStyle()),
                        value: dropdownValueAge,
                        decoration: inputDecoration(),
                        items: List.generate(
                          ageRangeList.length,
                              (index) {
                            return DropdownMenuItem(
                              value: ageRangeList[index],
                              child: Text('${ageRangeList[index]}',
                                  style: primaryTextStyle()),
                            );
                          },
                        ),
                        onChanged: (dynamic value) {
                          dropdownValueAge = value;
                        },
                        validator: (dynamic value) {
                          return value == null ? errorThisFieldRequired : null;
                        },
                      ),
                      16.height,
                      Text(lbl_job, style: primaryTextStyle()),
                      8.height,
                      DropdownButtonFormField(
                        hint: Text('Select Job', style: secondaryTextStyle()),
                        value: dropdownValueJob,
                        decoration: inputDecoration(),
                        items: List.generate(
                          jobList.length,
                              (index) {
                            return DropdownMenuItem(
                              value: jobList[index],
                              child: Text('${jobList[index]}',
                                  style: primaryTextStyle()),
                            );
                          },
                        ),
                        onChanged: (dynamic value) {
                          dropdownValueJob = value;
                          //Change disparity based on Job
                          if (value.toString().contains("Teacher"))
                            setState(() {
                              disparityVis = false;
                            });
                        },
                        validator: (dynamic value) {
                          return value == null ? errorThisFieldRequired : null;
                        },
                      ),
                      16.height,
                      Text(lbl_learningStyle, style: primaryTextStyle()),
                      8.height,
                      DropdownButtonFormField(
                        hint: Text('Select Learning Style',
                            style: secondaryTextStyle()),
                        value: dropdownValueLearningStyle,
                        decoration: inputDecoration(),
                        items: List.generate(
                          learningStyleList.length,
                              (index) {
                            return DropdownMenuItem(
                              value: learningStyleList[index],
                              child: Text('${learningStyleList[index]}',
                                  style: primaryTextStyle()),
                            );
                          },
                        ),
                        onChanged: (dynamic value) {
                          dropdownValueLearningStyle = value;
                        },
                        validator: (dynamic value) {
                          return value == null ? errorThisFieldRequired : null;
                        },
                      ),
                      Visibility(
                          visible: disparityVis,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Text(lbl_disparity, style: primaryTextStyle()),
                              8.height,
                              DropdownButtonFormField(
                                hint: Text('Select Disparity',
                                    style: secondaryTextStyle()),
                                value: dropdownValueDisparity,
                                decoration: inputDecoration(),
                                items: List.generate(
                                  disparityList.length,
                                      (index) {
                                    return DropdownMenuItem(
                                      value: disparityList[index],
                                      child: Text('${disparityList[index]}',
                                          style: primaryTextStyle()),
                                    );
                                  },
                                ),
                                onChanged: (dynamic value) {
                                  dropdownValueDisparity = value;
                                },
                                validator: (dynamic value) {
                                  return value == null
                                      ? errorThisFieldRequired
                                      : null;
                                },
                              )
                            ],
                          )),

                      30.height,
                      gradientButton(
                          text: lbl_sign_up,
                          onTap: signUp,
                          isFullWidth: true,
                          context: context),
                      16.height,
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

