import 'package:quizapp_flutter/models/QuizModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

import '../main.dart';

class QuizService extends BaseService {
  QuizService() {
    ref = db.collection('Quiz');
  }

  Future<List<QuizModel>> getQuizByCatId(String? id) async {
    print(id.toString() +"  id geldi");
   // print(QuizKeys.categoryId +" cat id id geldi");

    return await ref.where(QuizKeys.categoryId, isEqualTo: id).get().then((event) => event.docs.map((e) => QuizModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
  //.where(QuizKeys.categoryId, isEqualTo: id)

}
