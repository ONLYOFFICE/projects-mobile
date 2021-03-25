import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/ui_helpers.dart';

class TaskView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UIHelper.verticalSpaceLarge(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Welcome ',
              style: TextStyleHelper.headerStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Here are all your projects',
              style: TextStyleHelper.subHeaderStyle,
            ),
          ),
          UIHelper.verticalSpaceSmall(),
        ],
      ),
    );
  }
}
