import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizCategoryComponent.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/screens/QuizScreen.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class QuizCategoryScreen extends StatefulWidget {
  static String tag = '/QuizCategoryScreen';

  @override
  QuizCategoryScreenState createState() => QuizCategoryScreenState();
}

class QuizCategoryScreenState extends State<QuizCategoryScreen> {
  List<CategoryModel> categoryItems = [];
  bool isLoading = false;

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
      appBar: AppBar(
        title: Text(lbl_education_category),
        backgroundColor: colorPrimary,
      ),
      body: FutureBuilder(
        future: categoryService.categories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoryModel> data = snapshot.data as List<CategoryModel>;
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 20,
                  children: List.generate(data.length, (index) {
                    CategoryModel? mData = data[index];

                    return QuizCategoryComponent(category: mData).onTap(() {
                      print("----->"+ mData.name.toString());
                      QuizScreen(catId: mData.id, catName: mData.name).launch(context);
                    });
                  }),
                ),
              ),
            );
          }
          return snapWidgetHelper(snapshot, errorWidget: emptyWidget());
        },
      ),
    );
  }
}
