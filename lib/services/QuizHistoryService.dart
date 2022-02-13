import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/QuizHistoryModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/constants.dart';

class QuizHistoryService extends BaseService {
  QuizHistoryService() {
    ref = db.collection('QuizHistory');
  }

  Future<List<QuizHistoryModel>> quizHistoryByQuizType({String? quizType}) async {
    if (quizType == All) {
      print(appStore.userId.toString() + " gelen user id");
      return await ref.where(QuizHistoryKeys.userId, isEqualTo: appStore.userId).orderBy('createdAt', descending: true).get().then((value) => value.docs.map((e) => QuizHistoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
    }
    return await ref
        .where(QuizHistoryKeys.userId, isEqualTo: appStore.userId)
        .where(QuizHistoryKeys.quizType, isEqualTo: quizType)
        .orderBy(CommonKeys.createdAt, descending: true)
        .get()
        .then((value) => value.docs.map((e) => QuizHistoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
