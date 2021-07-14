import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/detailed_project/tags_controller.dart';

import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/projects_view/widgets/tag_item.dart';

class TagsSelectionView extends StatelessWidget {
  const TagsSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projController = Get.arguments['controller'];

    var controller = Get.put(TagsController());
    controller.setup(projController);

    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: AnimatedPadding(
        padding: const EdgeInsets.only(bottom: 0),
        duration: const Duration(milliseconds: 100),
        child: StyledFloatingActionButton(
          onPressed: () => showTagAddingDialog(controller),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      appBar: StyledAppBar(
        title: _Header(
          controller: controller,
          title: tr('tags'),
        ),
        bottom: _TagsSearchBar(controller: controller),
      ),
      body: Obx(
        () {
          if (controller.loaded.value == true &&
              controller.tags.isNotEmpty &&
              controller.isSearchResult.value == false) {
            return _TagsList(
              controller: controller,
              onTapFunction: () => {},
            );
          }
          if (controller.nothingFound.value == true) {
            return const NothingFound();
          } else
            return const ListLoadingSkeleton();
        },
      ),
    );
  }

  Future showTagAddingDialog(controller) async {
    var inputController = TextEditingController();

    await Get.dialog(StyledAlertDialog(
      titleText: tr('enterTag'),
      content: TextField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        controller: inputController,
        decoration: const InputDecoration.collapsed(hintText: ''),
        onSubmitted: (value) {
          controller.createTag(value);
        },
      ),
      acceptText: tr('confirm').toUpperCase(),
      onAcceptTap: () {
        controller.createTag(inputController.text);
        Get.back();
      },
      onCancelTap: Get.back,
    ));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.title,
    @required this.controller,
  }) : super(key: key);

  final String title;
  final controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyleHelper.headline6(
                          color: Get.theme.colors().onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsSearchBar extends StatelessWidget {
  const _TagsSearchBar({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 16, right: 20, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Expanded(child: TagsSearchBar(controller: controller)),
          const SizedBox(width: 20),
          Container(
            height: 24,
            width: 24,
            child: InkWell(
              onTap: () {
                // Get.toNamed('');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsList extends StatelessWidget {
  const _TagsList({
    Key key,
    @required this.controller,
    @required this.onTapFunction,
  }) : super(key: key);
  final Function onTapFunction;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (c, i) => TagItem(
              tagItemDTO: controller.tags[i],
              onTapFunction: () {
                controller.changeTagSelection(controller.tags[i]);
              },
            ),
            itemExtent: 65.0,
            itemCount: controller.tags.length,
          ),
        )
      ],
    );
  }
}
