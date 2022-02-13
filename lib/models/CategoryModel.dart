import 'package:quizapp_flutter/utils/ModelKeys.dart';

class CategoryModel {
  String? id;
  String? image;
  String? name;

  CategoryModel({this.id, this.image, this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CommonKeys.id],
      image: json[CategoryKeys.image],
      name: json[CategoryKeys.name],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CategoryKeys.image] = this.image;
    data[CategoryKeys.name] = this.name;
    return data;
  }
}
