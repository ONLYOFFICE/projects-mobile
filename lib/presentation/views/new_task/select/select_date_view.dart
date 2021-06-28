import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class SelectDateView extends StatelessWidget {
  const SelectDateView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];
    bool startDate = Get.arguments['startDate'];
    return Scaffold(
      appBar: StyledAppBar(
          titleText: startDate ? tr('selectStartDate') : tr('selectDueDate')),
      body: CalendarDatePicker(
          initialDate: DateTime.now(),
          currentDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3000),
          onDateChanged: (value) {
            return startDate
                ? controller.changeStartDate(value)
                : controller.changeDueDate(value);
          }),
      // ),
    );
  }
}
