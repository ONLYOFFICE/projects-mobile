import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/new_discussion_controller.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_title_text_field.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_project_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_subscribers_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_text_tile.dart';

class NewDiscussionScreen extends StatelessWidget {
  const NewDiscussionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectId;
    var projectTitle;

    try {
      projectId = Get.arguments['projectId'];
      projectTitle = Get.arguments['projectTitle'];
    } catch (_) {}

    var controller = Get.put(NewDiscussionController(
      specifiedProjectId: projectId,
      specifiedProjectTitle: projectTitle,
    ));

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('newDiscussion'),
        actions: [
          IconButton(
              onPressed: () => controller.confirm(context),
              icon: const Icon(Icons.done_rounded))
        ],
        onLeadingPressed: controller.discardDiscussion,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DiscussionTitleTextField(controller: controller),
            Listener(
              onPointerDown: (_) {
                if (controller.title.isNotEmpty &&
                    controller.titleFocus.hasFocus)
                  controller.titleFocus.unfocus();
              },
              child: Column(
                children: [
                  DiscussionTextTile(controller: controller),
                  DiscussionProjectTile(
                    ignoring: projectId != null,
                    controller: controller,
                  ),
                  DiscussionSubscribersTile(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
