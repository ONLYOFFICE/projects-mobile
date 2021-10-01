import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
// import 'package:projects/internal/locator.dart';

import 'package:projects/main_controller.dart';

import 'package:projects/presentation/views/no_internet_view.dart';

class MainView extends StatelessWidget {
  MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // setupGetX();
    return GetBuilder<MainController>(builder: (controller) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.setupMainPage();
      });

      return Obx(() {
        if (controller.noInternet.isTrue)
          return const NoInternetScreen();
        else
          return controller.mainPage.value;
      });
    });
  }
}
