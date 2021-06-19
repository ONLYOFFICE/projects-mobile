import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/discussions/discussions_view.dart';

class ProjectDiscussionsScreen extends StatelessWidget {
  final ProjectDiscussionsController controller;
  const ProjectDiscussionsScreen({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.paginationController.data.isEmpty)
      controller.loadProjectDiscussions();
    return DiscussionsList(controller: controller);
  }
}
