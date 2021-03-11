import 'package:flutter/material.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';
import 'package:only_office_mobile/presentation/shared/ui_helpers.dart';

class TaskView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UIHelper.verticalSpaceLarge(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Welcome ',
              style: headerStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Here are all your projects', style: subHeaderStyle),
          ),
          UIHelper.verticalSpaceSmall(),
        ],
      ),
    );
  }
}
