import 'package:flutter/material.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
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
    return Stack(
      children: [
        DiscussionsList(
            controller: controller, scrollController: ScrollController()),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            child: StyledFloatingActionButton(
              onPressed: controller.toNewDiscussionScreen,
              child: AppIcon(icon: SvgIcons.add_fab),
            ),
          ),
        ),
      ],
    );
  }
}
