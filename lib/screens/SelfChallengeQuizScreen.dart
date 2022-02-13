import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/components/QuizQuestionComponent.dart';
import 'package:quizapp_flutter/models/QuestionModel.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:quizapp_flutter/screens/QuizResultScreen.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import '../main.dart';

class SelfChallengeQuizScreen extends StatefulWidget {
  static String tag = '/SelfChallengeQuizScreen';

  final List<QuestionModel>? queList;
  final int? queCount;
  final int? time;

  SelfChallengeQuizScreen({this.queList, this.queCount, this.time});

  @override
  SelfChallengeQuizScreenState createState() => SelfChallengeQuizScreenState();
}

class SelfChallengeQuizScreenState extends State<SelfChallengeQuizScreen> {
  PageController? pageController;
  int? endTime;
  int rightAnswers = 0;
  int selectedPageIndex = 0;
  int? totalQue;

  String? oldLevel, newLevel;

  List<QuestionModel> questions = [];
  List<QuizAnswer> quizAnswer = [];

  CountdownTimerController? countdownController;

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now().millisecondsSinceEpoch + Duration(minutes: widget.time!).inMilliseconds;
    pageController = PageController(initialPage: selectedPageIndex);
    countdownController = CountdownTimerController(endTime: endTime!, onEnd: onEnd);
    totalQue = widget.queCount! > widget.queList!.length ? widget.queList!.length : widget.queCount;
    init();
  }

  Future<void> init() async {
    LiveStream().on(answerQuestionStream, (s) {
      if (questions.contains(s)) {
        questions.remove(s);
      }
      questions.add(s as QuestionModel);
    });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    countdownController!.dispose();
    pageController!.dispose();
    LiveStream().dispose(answerQuestionStream);
  }

  void onEnd() {
    log('onEnd');
    showInDialog(
      context,
      barrierDismissible: false,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lbl_time_over_message),
            16.height,
            Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  text: lbl_submit,
                  onTap: submitQuiz,
                  elevation: 0,
                  color: greenColor,
                  textColor: white,
                )),
          ],
        ),
      ),
    );
  }

  void submitQuiz() async {
    countdownController!.disposeTimer();
    finish(context);
    appStore.setLoading(true);

    questions.forEach((element) {
      if (element.answer == element.correctAnswer) {
        rightAnswers++;
      }
    });
    log('right:$rightAnswers');

    questions.forEach((element) {
      quizAnswer.add(QuizAnswer(question: element.addQuestion.validate(), answers: element.answer.validate(value: 'Not Answered'), correctAnswer: element.correctAnswer.validate()));
    });
    log('quizAnswer:$quizAnswer');

    QuizHistoryModel quizHistory = QuizHistoryModel();
    quizHistory.userId = appStore.userId;
    quizHistory.createdAt = DateTime.now();
    quizHistory.quizType = EducationTypeSelfChallenge.validate();
    quizHistory.quizTitle = "Self Challenge Quiz";
    quizHistory.quizAnswers = quizAnswer.validate();
    quizHistory.totalQuestion = quizAnswer.length.validate();
    quizHistory.rightQuestion = rightAnswers.validate();

    await quizHistoryService.addDocument(quizHistory.toJson()).then((v) async {
      await userDBService.updateDocument({UserKeys.points: FieldValue.increment(POINT_PER_QUESTION * rightAnswers)}, appStore.userId).then((value) {
        oldLevel = getLevel(points: getIntAsync(USER_POINTS));

        setValue(USER_POINTS, getIntAsync(USER_POINTS) + POINT_PER_QUESTION * rightAnswers);

        newLevel = getLevel(points: getIntAsync(USER_POINTS));

        appStore.setLoading(false);
        finish(context);
        QuizResultScreen(quizHistoryData: quizHistory, oldLevel: oldLevel, newLevel: newLevel).launch(context);
      }).catchError((e) {
        toast(e.toString());
      });
    }).catchError((e) {
      toast(e.toString());
    });
  }

  void onSubmit() {
    log('submit');
    showInDialog(
      context,
      child: WillPopScope(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lbl_want_to_submit),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(text: lbl_submit, onTap: submitQuiz, elevation: 0, color: greenColor, textColor: white),
                16.width,
                AppButton(
                  text: lbl_cancel,
                  onTap: () {
                    finish(context);
                  },
                  elevation: 0,
                  color: colorSecondary,
                  textColor: white,
                ),
              ],
            )
          ],
        ),
        onWillPop: () => Future.value(false),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: context.width(),
              height: context.height() * 0.30,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [colorPrimary, colorSecondary],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              )),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Questions:${selectedPageIndex + 1}/$totalQue', style: boldTextStyle(color: white, size: 20)),
                      CountdownTimer(
                        controller: countdownController,
                        onEnd: onEnd,
                        endTime: endTime,
                        textStyle: primaryTextStyle(color: white),
                      ),
                    ],
                  ),
                  AppButton(
                    text: 'End Quiz',
                    color: white,
                    onTap: onSubmit,
                    textColor: colorPrimary,
                    padding: EdgeInsets.all(4),
                  )
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              top: context.height() * 0.20,
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius)),
                child: PageView(
                  physics: new NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: List.generate(totalQue!, (index) {
                    LiveStream().emit(answerQuestionStream, widget.queList![index]);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          QuizQuestionComponent(question: widget.queList![index]),
                          16.height,
                          if (index == 0 && totalQue != 1)
                            gradientButton(
                                text: 'Next',
                                onTap: () {
                                  pageController!.animateToPage(++selectedPageIndex, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                })
                          else if (index > 0 && index < totalQue! - 1)
                            Row(
                              children: [
                                gradientButton(
                                    text: 'Previous',
                                    onTap: () {
                                      pageController!.animateToPage(--selectedPageIndex, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                    }).expand(),
                                16.width,
                                gradientButton(
                                    text: 'Next',
                                    onTap: () {
                                      pageController!.animateToPage(++selectedPageIndex, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                    }).expand(),
                              ],
                            )
                          else if (index == totalQue! - 1 && totalQue != 1)
                            Row(
                              children: [
                                gradientButton(
                                    text: 'Previous',
                                    onTap: () {
                                      pageController!.animateToPage(--selectedPageIndex, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                                    }).expand(),
                                16.width,
                                gradientButton(text: 'Submit', onTap: onSubmit).expand(),
                              ],
                            )
                            else if (totalQue == 1)
                                gradientButton(text: 'Submit', onTap: onSubmit).center(),
                        ],
                      ),
                    );
                  }),
                  onPageChanged: (value) {
                    selectedPageIndex = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            Observer(builder: (context) => Loader().visible(appStore.isLoading)),
          ],
        ).withHeight(context.height()),
      ),
      onWillPop: () {
        return Future.value(false);
      },
    );
  }
}
