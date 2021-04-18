import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewTaskDescription extends StatelessWidget {
  const NewTaskDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    var controller = Get.find<NewTaskController>();
    _controller.text =
        'Description of task. Description of task. AdDescription of task. Description of task. Description of task|';
    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Description',
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => controller.leaveDescriptionView(_controller.text)),
        actions: [
          IconButton(
              icon: Icon(Icons.check_rounded),
              onPressed: () => controller.confirmDescription(_controller.text))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          style: TextStyleHelper.subtitle1(
              color: Theme.of(context).customColors().onSurface),
          decoration: InputDecoration.collapsed(
              hintText: 'Task description',
              hintStyle: TextStyleHelper.subtitle1()),
        ),
      ),
    );
  }
}
