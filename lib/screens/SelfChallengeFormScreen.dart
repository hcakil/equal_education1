import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/screens/SelfChallengeQuizScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class SelfChallengeFormScreen extends StatefulWidget {
  static String tag = '/SelfChallengeFormScreen';

  @override
  SelfChallengeFormScreenState createState() => SelfChallengeFormScreenState();
}

class SelfChallengeFormScreenState extends State<SelfChallengeFormScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController noOfQueController = TextEditingController();

  FocusNode noOfQueFocus = FocusNode();

  List<CategoryModel> categoryItems = [];
  int? selectedTime;
  String? categoryId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    categoryService.categories().then((value) {
      categoryItems = value;
      setState(() {});
    });
  }

  createQuiz(String? catId) {
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      log(catId);
      appStore.setLoading(true);
      questionService.questionByCatId(catId).then((value) {
        appStore.setLoading(false);
        if (value.isNotEmpty) {
          SelfChallengeQuizScreen(queList: value, queCount: int.tryParse(noOfQueController.text.validate()), time: selectedTime).launch(context);
        } else {
          toast('No Questions found for this category');
        }
      }).catchError((e) {
        appStore.setLoading(false);
        throw e;
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
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(lbl_self_challenge),
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
                  Text(lbl_enter_detail_sc_education, style: secondaryTextStyle(), textAlign: TextAlign.center).center(),
                  30.height,
                  Text(lbl_select_category, style: primaryTextStyle()),
                  8.height,
                  DropdownButtonFormField(
                    hint: Text(lbl_select_category, style: secondaryTextStyle()),
                    value: categoryId,
                    isExpanded: true,
                    decoration: inputDecoration(),
                    items: List.generate(
                      categoryItems.length,
                      (index) {
                        return DropdownMenuItem(
                          value: categoryItems[index].id,
                          child: Text('${categoryItems[index].name}', style: primaryTextStyle()),
                        );
                      },
                    ),
                    onChanged: (dynamic value) {
                      categoryId = value;
                    },
                    validator: (dynamic value) {
                      return value == null ? 'This field is required' : null;
                    },
                  ),
                  16.height,
                  Text(lbl_no_of_questions, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: noOfQueController,
                    textFieldType: TextFieldType.PHONE,
                    focus: noOfQueFocus,
                    decoration: inputDecoration(hintText: lbl_hint_no_ques),
                    maxLength: 2,
                  ),
                  16.height,
                  Text(lbl_time, style: primaryTextStyle()),
                  8.height,
                  DropdownButtonFormField(
                    hint: Text(lbl_select_time, style: secondaryTextStyle()),
                    value: selectedTime,
                    decoration: inputDecoration(),
                    items: List.generate(
                      12,
                      (index) {
                        return DropdownMenuItem(
                          value: (index + 1) * 5,
                          child: Text('${(index + 1) * 5} Minutes', style: primaryTextStyle()),
                        );
                      },
                    ),
                    onChanged: (dynamic value) {
                      selectedTime = value;
                    },
                    validator: (dynamic value) {
                      return value == null ? 'This field is required' : null;
                    },
                  ),
                  30.height,
                  gradientButton(
                      text: lbl_ok,
                      onTap: () {
                        createQuiz(categoryId);
                      },
                      context: context,
                      isFullWidth: true),
                ],
              ).paddingOnly(left: 16, right: 16),
            ),
          ),
          Observer(builder: (context) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
