import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PortalDiscussionsView extends StatelessWidget {
  const PortalDiscussionsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'DiscussionsView placeholder',
              style: TextStyleHelper.subHeaderStyle,
            ),
          ),
        ],
      ),
    );
  }
}
