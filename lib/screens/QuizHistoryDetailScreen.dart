import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:quizapp_flutter/utils/colors.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';

class QuizHistoryDetailScreen extends StatefulWidget {
  static String tag = '/QuizHistoryDetailScreen';

  final QuizHistoryModel? quizHistoryData;

  QuizHistoryDetailScreen({this.quizHistoryData});

  @override
  QuizHistoryDetailScreenState createState() => QuizHistoryDetailScreenState();
}

class QuizHistoryDetailScreenState extends State<QuizHistoryDetailScreen> {
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
        backgroundColor: scaffoldColor,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: black).onTap(() {
          finish(context);
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.quizHistoryData!.quizTitle}', style: boldTextStyle(size: 20)),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$lbl_total_questions: ${widget.quizHistoryData!.totalQuestion}', style: boldTextStyle(size: 20, color: colorSecondary)),
                Row(
                  children: [
                    Image.asset(rightIconImage, height: 30, width: 30),
                    8.width,
                    Text('${widget.quizHistoryData!.rightQuestion}', style: boldTextStyle()),
                    16.width,
                    Image.asset(wrongIconImage, height: 30, width: 30),
                    8.width,
                    Text('${widget.quizHistoryData!.totalQuestion! - widget.quizHistoryData!.rightQuestion!}', style: boldTextStyle()),
                  ],
                ),
              ],
            ),
            16.height,
            Divider(),
            16.height,
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: widget.quizHistoryData!.quizAnswers!.length,
              itemBuilder: (context, index) {
                QuizAnswer mData = widget.quizHistoryData!.quizAnswers![index];
                //return QuizReviewQuestionComponent(queId: queId, index: index);
                return Container(
                  decoration: boxDecorationWithRoundedCorners(backgroundColor: white),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}.', style: boldTextStyle()),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${mData.question}', softWrap: true, style: primaryTextStyle()),
                          16.height,
                          Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: mData.correctAnswer == mData.answers ? greenColor.withOpacity(0.3) : redColor.withOpacity(0.3)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Answer:', style: boldTextStyle()),
                                8.height,
                                Text('${mData.answers}', softWrap: true, style: primaryTextStyle()),
                              ],
                            ),
                          ),
                          16.height,
                          Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: scaffoldColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Correct Answer:', style: boldTextStyle()),
                                8.height,
                                Text('${mData.correctAnswer}', softWrap: true, style: primaryTextStyle()),
                              ],
                            ),
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                );
              },
            ),
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }
}
