import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/presentation/views/projects_view/search_appbar.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';

class NewProjectDescription extends StatelessWidget {
  const NewProjectDescription({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchAppBar(
        title: CustomHeader(
          function: controller.confirmDescription,
          title: 'Description',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: controller.descriptionController,
          decoration:
              InputDecoration.collapsed(hintText: 'Enter your text here'),
        ),
      ),
    );
  }
}
