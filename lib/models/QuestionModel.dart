import 'package:quizapp_flutter/utils/ModelKeys.dart';

class QuestionModel {
  String? addQuestion;
  String? correctAnswer;
  String? imageUrl;
  String? id;
  int? selectedOptionIndex;
  List<String>? optionList;
  String? answer;

  QuestionModel({this.addQuestion, this.correctAnswer, this.id,this.imageUrl, this.optionList, this.selectedOptionIndex, this.answer});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      addQuestion: json[QuestionKeys.addQuestion],
      correctAnswer: json[QuestionKeys.correctAnswer],
      id: json[CommonKeys.id],
      imageUrl: json[QuestionKeys.imageUrl],
      optionList: json[QuestionKeys.optionList] != null ? new List<String>.from(json[QuestionKeys.optionList]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[QuestionKeys.addQuestion] = this.addQuestion;
    data[QuestionKeys.correctAnswer] = this.correctAnswer;
    data[QuestionKeys.imageUrl] = this.imageUrl;
    data[CommonKeys.id] = this.id;
    if (this.optionList != null) {
      data[QuestionKeys.optionList] = this.optionList;
    }
    return data;
  }
}
