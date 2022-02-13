import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/UserModel.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/constants.dart';

import '../main.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn? buildGoogleSignInScope() {
    return GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/plus.me',
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      AuthCredential credential = await getGoogleAuthCredential();
      UserCredential authResult = await _auth.signInWithCredential(credential);

      final User user = authResult.user!;

      await _auth.signOut();

      await buildGoogleSignInScope()?.signOut();

      return await loginFromFirebaseUser(user, LoginTypeGoogle);
    } catch (e) {
      throw errorSomethingWentWrong;
    }
  }

  Future<AuthCredential> getGoogleAuthCredential() async {
    GoogleSignInAccount? googleAccount = await (buildGoogleSignInScope()?.signIn());
    GoogleSignInAuthentication? googleAuthentication = await googleAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );
    return credential;
  }

  Future<void> signUpWithEmailPassword({required String email, required String password, String? name, String? age, String? job, String? learningStyle, String? disparity }) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
      await signInWithEmailPassword(email: value.user!.email!, password: password, displayName: name, age: age, job : job,learningStyle: learningStyle, disparity : disparity);
    }).catchError((error) {
      throw 'Email already exists';
    });
  }

  Future<void> signInWithEmailPassword({required String email, required String password, String? displayName, String? age, String? job, String? learningStyle, String? disparity}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      final User user = value.user!;

      UserModel userModel = UserModel();

      userModel.email = user.email;
      userModel.id = user.uid;
      userModel.name = displayName.validate();
      userModel.age = age.validate();
      userModel.job = job.validate();
      userModel.learningStyle = learningStyle.validate();
      userModel.disparity = disparity.validate();
      userModel.password = password.validate();
      userModel.createdAt = DateTime.now();
      userModel.photoUrl = user.photoURL.validate();
      userModel.loginType = LoginTypeEmail;
      userModel.isAdmin = false;
      //userModel.masterPwd = '';

      if (!(await userDBService.isUserExists(user.email))) {
        log('User not exits');

        await userDBService.addDocumentWithCustomId(user.uid, userModel.toJson()).then((value) {
          print("value after added ** ** ");
        }).catchError((e) {
          throw e;
        });
      }

      //in here we should add user job disparity and learningStyle
      return userDBService.getUserByEmail(email).then((user) async {
        await setValue(USER_ID, user.id);
        await setValue(USER_DISPLAY_NAME, user.name);
         await setValue(USER_JOB, user.job);
         await setValue(USER_LEARNING_STYLE, user.learningStyle);
         await setValue(USER_DISPARITY, user.disparity);
        await setValue(USER_EMAIL, user.email);
        await setValue(USER_POINTS, user.points.validate());
        await setValue(USER_PHOTO_URL, user.photoUrl.validate());
        // await setValue(USER_MASTER_PWD, user.masterPwd.validate());
        await setValue(LOGIN_TYPE, user.loginType.validate());
        await setValue(IS_LOGGED_IN, true);

        appStore.setLoggedIn(true);
        appStore.setUserId(user.id);
        appStore.setName(user.name);
         appStore.setUserJob(user.job);
         appStore.setUserLearningStyle(user.learningStyle);
         appStore.setUserDisparity(user.disparity);
        appStore.setProfileImage(user.photoUrl);
        appStore.setUserEmail(user.email);

        await userDBService.updateDocument({CommonKeys.updatedAt: DateTime.now()}, user.id);
      }).catchError((e) {
        throw e;
      });
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw 'Please check network connection';
      }
      log(error.toString());
      throw 'Enter valid email and password';
    });
  }

  Future<void> logout() async {
    await removeKey(USER_DISPLAY_NAME);
    await removeKey(USER_EMAIL);
    await removeKey(USER_PHOTO_URL);
    await removeKey(IS_LOGGED_IN);
    await removeKey(LOGIN_TYPE);
    await removeKey(USER_AGE);
    await removeKey(USER_POINTS);

    appStore.setLoggedIn(false);
    appStore.setUserId('');
    appStore.setName('');
    appStore.setUserEmail('');
    appStore.setProfileImage('');
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    await setValue(USER_ID, user.id);
    await setValue(USER_DISPLAY_NAME, user.name);
    await setValue(USER_EMAIL, user.email);
    await setValue(USER_POINTS, user.points);
    await setValue(USER_AGE, user.age.validate());
    await setValue(USER_PHOTO_URL, user.photoUrl.validate());
    // await setValue(USER_MASTER_PWD, user.masterPwd.validate());
    await setValue(IS_LOGGED_IN, true);
  }

  Future<UserModel> loginFromFirebaseUser(User currentUser, String loginType, {String? fullName}) async {
    UserModel userModel = UserModel();

    if (await userDBService.isUserExist(currentUser.email, loginType)) {
      ///Return user data
      await userDBService.getUserByEmail(currentUser.email).then((user) async {
        log('value');
        print("user ** ** "+user.job.toString());
        userModel = user;
      }).catchError((e) {
        print("hata ** ** $e");
        throw e;
      });
    } else {
      /// Create user
      userModel.id = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.photoUrl = currentUser.photoURL;
      userModel.name = (currentUser.displayName) ?? fullName;
      userModel.loginType = loginType;
      userModel.updatedAt = DateTime.now();
      userModel.createdAt = DateTime.now();

      await userDBService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) {
        //
      }).catchError((e) {
        throw e;
      });
    }

    await setValue(LOGIN_TYPE, loginType);

    appStore.setLoggedIn(true);
    appStore.setUserId(currentUser.uid);
    appStore.setName(currentUser.displayName);
    appStore.setProfileImage(currentUser.photoURL);
    appStore.setUserEmail(currentUser.email);

    await setUserDetailPreference(userModel);

    return userModel;
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }

  Future<void> resetPassword({required String newPassword}) async {
    await _auth.currentUser!.updatePassword(newPassword).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}

