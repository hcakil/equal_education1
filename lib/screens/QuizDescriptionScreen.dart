import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizDescriptionComponent.dart';
import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/screens/QuizQuestionsScreen.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

class QuizDescriptionScreen extends StatefulWidget {
  static String tag = '/QuizDescriptionScreen';

  final QuizModel? quizModel;

  QuizDescriptionScreen({this.quizModel});

  @override
  QuizDescriptionScreenState createState() => QuizDescriptionScreenState();
}

class QuizDescriptionScreenState extends State<QuizDescriptionScreen> {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizDescriptionComponent(quizModel: widget.quizModel),
                16.height,
                gradientButton(
                  text: lbl_start,
                  onTap: () {
                    showConfirmDialog(context, 'Do you want play this quiz?').then((value) {
                      if (value ?? false) {
                        QuizQuestionsScreen(quizData: widget.quizModel, quizType: EducationTypeCategory).launch(context);
                      }
                    });
                  },
                ).center(),
                16.height,
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 30,
            child: CircleAvatar(
              child: Icon(Icons.close, color: black),
              backgroundColor: white,
              radius: 15,
            ).onTap(() {
              finish(context);
            }),
          ),
        ],
      ),
    );
  }
}
