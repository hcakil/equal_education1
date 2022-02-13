import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp_flutter/models/UserModel.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';

import '../main.dart';
import 'BaseService.dart';

class UserDBService extends BaseService {
  UserDBService() {
    ref = db.collection('Users');
  }

  Future<UserModel> getUserById(String id) {
    return ref.where(CommonKeys.id, isEqualTo: id).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<UserModel> getUserByEmail(String? email) {
    return ref.where(UserKeys.email, isEqualTo: email).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref.limit(1).where(UserKeys.loginType, isEqualTo: loginType).where(UserKeys.email, isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<bool> isUserExists(String? id) async {
    return await getUserByEmail(id).then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<UserModel> loginUser(String email, String password) async {
    var data = await ref.where(UserKeys.email, isEqualTo: email).where(UserKeys.password, isEqualTo: password).limit(1).get();

    if (data.docs.isNotEmpty) {
      return UserModel.fromJson(data.docs.first.data() as Map<String, dynamic>);
    } else {
      throw 'User not found';
    }
  }
}
