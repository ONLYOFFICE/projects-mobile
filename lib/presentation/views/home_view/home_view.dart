import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/domain/controllers/home_controller.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';
import 'package:only_office_mobile/presentation/shared/ui_helpers.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(
        () => controller.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                    child: Text('Here are all your projects',
                        style: subHeaderStyle),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  // Expanded(child: getProjects(model.projects)),
                ],
              ),
      ),
    );
    // );
  }
}
