import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? age;
  String? job;
  String? learningStyle;
  String? disparity;
  String? loginType;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? points;
  String? photoUrl;
  bool? isAdmin = false;

  UserModel({this.email, this.password, this.name, this.age, this.id, this.loginType, this.updatedAt, this.createdAt, this.points = 50, this.photoUrl, this.isAdmin, this.job, this.disparity,this.learningStyle});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json[UserKeys.email],
      password: json[UserKeys.password],
      name: json[UserKeys.name],
      learningStyle: json[UserKeys.learningStyle],
      job: json[UserKeys.job],
      disparity: json[UserKeys.disparity],
      age: json[UserKeys.age],
      id: json[CommonKeys.id],
      points: json[UserKeys.points],
      loginType: json[UserKeys.loginType],
      photoUrl: json[UserKeys.photoUrl],
      isAdmin: json[UserKeys.isAdmin],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserKeys.email] = this.email;
    data[UserKeys.password] = this.password;
    data[UserKeys.name] = this.name;
    data[UserKeys.disparity] = this.disparity;
    data[UserKeys.learningStyle] = this.learningStyle;
    data[UserKeys.job] = this.job;
    data[UserKeys.age] = this.age;
    data[CommonKeys.id] = this.id;
    data[UserKeys.points] = this.points;
    data[UserKeys.photoUrl] = this.photoUrl;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isAdmin] = this.isAdmin;
    return data;
  }
}

