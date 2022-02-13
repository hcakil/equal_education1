import 'package:intl/intl.dart';
import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import '../main.dart';

class DailyQuizService extends BaseService {
  DailyQuizService() {
    ref = db.collection('DailyQuiz');
  }

  Future<QuizModel> dailyQuiz() async {
    return await ref.doc(DateFormat(CurrentDateFormat).format(DateTime.now()) /*'06-05-2021'*/).get().then((value) => QuizModel.fromJson(value.data() as Map<String, dynamic>));
  }
}
