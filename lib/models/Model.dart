import 'package:flutter/material.dart';

class DrawerItemModel {
  String? name;
  String? image;
  IconData? icon;
  Widget? widget;

  DrawerItemModel({this.name, this.image, this.icon, this.widget});
}

class WalkThroughItemModel {
  String? image;
  String? title;
  String? subTitle;

  WalkThroughItemModel({this.image, this.title, this.subTitle});
}
