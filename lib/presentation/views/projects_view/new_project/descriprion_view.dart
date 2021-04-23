import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewProjectDescription extends StatelessWidget {
  const NewProjectDescription({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    return WillPopScope(
      onWillPop: () async {
        return controller.canPopBack();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: StyledAppBar(
          titleText: 'Description',
          actions: [
            IconButton(
                icon: const Icon(Icons.check_outlined),
                onPressed: () => controller.confirmDescription)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller.descriptionController,
            decoration: const InputDecoration.collapsed(
                hintText: 'Enter your text here'),
          ),
        ),
      ),
    );
  }
}
