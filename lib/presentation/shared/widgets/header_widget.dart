import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/domain/controllers/user_controller.dart';
import 'package:only_office_mobile/presentation/shared/svg_manager.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserController controller = Get.put(UserController());
    return new Container(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 72,
            child: SVG.createSized(
                'lib/assets/images/icons/project_icon.svg', 40, 40),
          ),
          Expanded(
            child: Text(
              'Projects',
              style: TextStyleHelper.headerStyle,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(icon: const Icon(Icons.filter), onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
