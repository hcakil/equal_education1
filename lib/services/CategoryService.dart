import 'package:quizapp_flutter/main.dart';
import 'package:quizapp_flutter/models/CategoryModel.dart';
import 'package:quizapp_flutter/services/BaseService.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection('Categories');
  }

  Future<List<CategoryModel>> categories() async {
    return await ref.get().then((event) => event.docs.map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
