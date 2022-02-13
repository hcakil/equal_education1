import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/models/Model.dart';
import 'package:quizapp_flutter/screens/AboutUsScreen.dart';
import 'package:quizapp_flutter/screens/DailyQuizDescriptionScreen.dart';
import 'package:quizapp_flutter/screens/EarnPointScreen.dart';
import 'package:quizapp_flutter/screens/MyQuizHistoryScreen.dart';
import 'package:quizapp_flutter/screens/ProfileScreen.dart';
import 'package:quizapp_flutter/screens/QuizCategoryScreen.dart';
import 'package:quizapp_flutter/screens/SelfChallengeFormScreen.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/utils/images.dart';
import 'package:quizapp_flutter/utils/strings.dart';

String description =
    "Equal Education";

List<DrawerItemModel> getDrawerItems() {
  List<DrawerItemModel> drawerItems = [];
  drawerItems.add(DrawerItemModel(name: lbl_home, image: HomeImage));
  drawerItems.add(DrawerItemModel(name: lbl_profile, image: ProfileImage, widget: ProfileScreen()));
  drawerItems.add(DrawerItemModel(name: lbl_daily_education, image: DailyQuizImage, widget: DailyQuizDescriptionScreen()));
  drawerItems.add(DrawerItemModel(name: lbl_education_category, image: QuizCategoryImage, widget: QuizCategoryScreen()));
  drawerItems.add(DrawerItemModel(name: lbl_self_challenge, image: SelfChallengeImage, widget: SelfChallengeFormScreen()));
  drawerItems.add(DrawerItemModel(name: lbl_my_education_history, image: QuizHistoryImage, widget: MyQuizHistoryScreen()));
  if (!getBoolAsync(DISABLE_AD)) drawerItems.add(DrawerItemModel(name: lbl_earn_points, image: EarnPointsImage, widget: EarnPointScreen()));
  drawerItems.add(DrawerItemModel(name: lbl_about_us, image: AboutUsImage, widget: AboutUsScreen()));
 // drawerItems.add(DrawerItemModel(name: lbl_rate_us, image: RateUsImage));
 // drawerItems.add(DrawerItemModel(name: lbl_privacy_policy, image: PrivacyPolicyImage));
 // drawerItems.add(DrawerItemModel(name: lbl_terms_and_conditions, image: TermsAndConditionsImage));
  drawerItems.add(DrawerItemModel(name: lbl_logout, image: LogoutImage));
  return drawerItems;
}

List<WalkThroughItemModel> getWalkThroughItems() {
  List<WalkThroughItemModel> walkThroughItems = [];
  walkThroughItems.add(WalkThroughItemModel(
    image: WalkThroughImage1,
    title: 'Learning to Learn',
    subTitle: 'Reach your goal with learn which path is suitable for you at first..',
  ));
  walkThroughItems.add(WalkThroughItemModel(
    image: WalkThroughImage2,
    title: 'No Obstacles in this Learning Way',
    subTitle: 'Autism, deaf and blind learners do not hesitate to join this family..',
  ));
  walkThroughItems.add(WalkThroughItemModel(
    image: WalkThroughImage3,
    title: 'Dreams at Beyond',
    subTitle: 'With the help between together, Reach beyond your dreams and lifetime free..',
  ));
  return walkThroughItems;
}
