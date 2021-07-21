import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/domain/controllers/discussions/actions/discussion_editing_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_title_text_field.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_project_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_subscribers_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_text_tile.dart';

class DiscussionEditingScreen extends StatelessWidget {
  const DiscussionEditingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Discussion discussion;

    try {
      discussion = Get.arguments['discussion'];
    } catch (_) {}

    var controller = Get.put(
      DiscussionEditingController(
        id: discussion.id,
        title: discussion.title.obs,
        text: discussion.text.obs,
        projectId: discussion.project.id,
        selectedProjectTitle: discussion.project.title.obs,
        initialSubscribers: discussion.subscribers,
      ),
    );

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('editDiscussion'),
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
                  DiscussionProjectTile(ignoring: true, controller: controller),
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
