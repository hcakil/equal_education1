import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';

class QuizCategoryComponent extends StatefulWidget {
  static String tag = '/QuizCategoryComponent';

  final CategoryModel? category;

  QuizCategoryComponent({this.category});

  @override
  QuizCategoryComponentState createState() => QuizCategoryComponentState();
}

class QuizCategoryComponentState extends State<QuizCategoryComponent> {
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
    return Container(
      width: (context.width() * 0.5) - 30,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 35),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.circular(defaultRadius),
              backgroundColor: white,
            ),
            height: 120,
            width: context.width(),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Text(
              widget.category!.name!,
              style: boldTextStyle(),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            width: 80,
            height: 80,
            child: Image.network(widget.category!.image!, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
          ),
        ],
      ),
    );
  }
}
