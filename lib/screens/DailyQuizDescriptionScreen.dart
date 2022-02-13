import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/strings.dart';
import 'package:quizapp_flutter/utils/widgets.dart';

import 'QuizQuestionsScreen.dart';

class DailyQuizDescriptionScreen extends StatefulWidget {
  static String tag = '/DailyQuizDescriptionScreen';

  @override
  DailyQuizDescriptionScreenState createState() => DailyQuizDescriptionScreenState();
}

class DailyQuizDescriptionScreenState extends State<DailyQuizDescriptionScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
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
          FutureBuilder(
            future: dailyQuizService.dailyQuiz(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuizModel mData = snapshot.data as QuizModel;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        mData.imageUrl!,
                        width: context.width(),
                        height: context.height() * 0.40,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRectOnly(bottomLeft: defaultRadius.toInt(), bottomRight: defaultRadius.toInt()),
                      30.height,
                      Text('About this Quiz', style: boldTextStyle(size: 20)).paddingOnly(left: 16, right: 16),
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        width: context.width(),
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: grey.withOpacity(0.3)), backgroundColor: white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quiz Title:', style: boldTextStyle()),
                            8.height,
                            Text(mData.quizTitle!, style: primaryTextStyle()),
                            8.height,
                            Divider(color: grey.withOpacity(0.3), thickness: 1),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                8.height,
                                Text('Quiz Description:', style: boldTextStyle()),
                                8.height,
                                Text(mData.description!, style: primaryTextStyle()),
                                8.height,
                                Divider(color: grey.withOpacity(0.3), thickness: 1),
                              ],
                            ).visible(mData.description.validate().isNotEmpty),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(lbl_no_of_questions + ":", style: boldTextStyle()),
                                4.width,
                                Text(mData.questionRef!.length.toString(), softWrap: true, style: primaryTextStyle()).expand(),
                              ],
                            ),
                            8.height,
                            Divider(color: grey.withOpacity(0.3), thickness: 1),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('QuizDuration: ', style: boldTextStyle()),
                                4.width,
                                Text(mData.quizTime.toString() + " Minutes", softWrap: true, style: primaryTextStyle()).expand(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      16.height,
                      Container(
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
                            lbl_start,
                            style: primaryTextStyle(color: white),
                          ),
                          onPressed: () {
                            if (mData.questionRef!.length != 0) {
                              finish(context);
                              QuizQuestionsScreen(quizData: mData, quizType: EducationTypeDaily).launch(context);
                            }else {
                              toast('No Question found');
                            }
                          },
                        ),
                      ).center(),
                      16.height,
                    ],
                  ),
                );
              }
              return snapWidgetHelper(snapshot, errorWidget: emptyWidget());
            },
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
