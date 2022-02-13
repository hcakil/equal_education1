import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

class QuizHistoryModel {
  String? id;
  String? userId;
  List<QuizAnswer>? quizAnswers;
  String? quizTitle;
  String? image;
  String? quizType;
  int? totalQuestion;
  int? rightQuestion;
  DateTime? createdAt;

  QuizHistoryModel({
    this.id,
    this.quizAnswers,
    this.quizType,
    this.createdAt,
    this.totalQuestion,
    this.rightQuestion,
    this.quizTitle,
    this.image,
    this.userId,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      id: json[CommonKeys.id],
      userId: json[QuizHistoryKeys.userId],
      quizAnswers: json[QuizHistoryKeys.quizAnswers] != null ? (json[QuizHistoryKeys.quizAnswers] as List).map((i) => QuizAnswer.fromJson(i)).toList() : null,
      quizTitle: json[QuizHistoryKeys.quizTitle],
      image: json[QuizHistoryKeys.image],
      quizType: json[QuizHistoryKeys.quizType],
      totalQuestion: json[QuizHistoryKeys.totalQuestion],
      rightQuestion: json[QuizHistoryKeys.rightQuestion],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[QuizHistoryKeys.userId] = this.userId;
    data[QuizHistoryKeys.quizTitle] = this.quizTitle;
    data[QuizHistoryKeys.image] = this.image;
    data[QuizHistoryKeys.quizType] = this.quizType;
    data[QuizHistoryKeys.totalQuestion] = this.totalQuestion;
    data[QuizHistoryKeys.rightQuestion] = this.rightQuestion;
    data[CommonKeys.createdAt] = this.createdAt;
    if (this.quizAnswers != null) {
      data[QuizHistoryKeys.quizAnswers] = this.quizAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizAnswer {
  String? answers;
  String? correctAnswer;
  String? question;

  QuizAnswer({this.answers, this.correctAnswer, this.question});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      question: json[QuizAnswerKeys.question],
      answers: json[QuizAnswerKeys.answers],
      correctAnswer: json[QuizAnswerKeys.correctAnswer],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[QuizAnswerKeys.question] = this.question;
    data[QuizAnswerKeys.answers] = this.answers;
    data[QuizAnswerKeys.correctAnswer] = this.correctAnswer;
    return data;
  }
}
