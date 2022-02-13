import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quizapp_flutter/utils/images.dart';

class UpgradeLevelDialogComponent extends StatefulWidget {
  static String tag = '/UpgradeLevelDialogComponent';

  final String? level;

  UpgradeLevelDialogComponent({this.level});

  @override
  UpgradeLevelDialogComponentState createState() => UpgradeLevelDialogComponentState();
}

class UpgradeLevelDialogComponentState extends State<UpgradeLevelDialogComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Image.asset(NewLevelImage, width: context.width(), height: 200),
            30.height,
            Text(widget.level!, style: boldTextStyle(size: 30)),
            16.height,
          ],
        ),
        Icon(Icons.close).onTap(() {
          finish(context);
        }),
      ],
    );
  }
}
