/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/tag_item_DTO.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tags_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/platform_alert_dialog.dart';
import 'package:projects/presentation/shared/wrappers/platform_dialog_action.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/projects_view/widgets/tag_item.dart';

class TagsSelectionView extends StatelessWidget {
  const TagsSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projController = Get.arguments['controller'];

    final controller = Get.put(ProjectTagsController());
    controller.setup(projController);

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      floatingActionButton: AnimatedPadding(
        padding: EdgeInsets.zero,
        duration: const Duration(milliseconds: 100),
        child: Obx(
          () => Visibility(
            visible: controller.fabIsVisible.value,
            child: StyledFloatingActionButton(
              onPressed: () => showTagAddingDialog(controller, context),
              child: Icon(
                PlatformIcons(context).plus,
                color: Get.theme.colors().onPrimarySurface,
              ),
            ),
          ),
        ),
      ),
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        title: _Header(
          controller: controller,
          title: tr('tags'),
        ),
        actions: [
          PlatformIconButton(
            icon: Icon(PlatformIcons(context).checkMark),
            onPressed: controller.confirm,
          )
        ],
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
          } else if (controller.loaded.value == true && controller.tags.isEmpty) {
            return Column(children: const [NothingFound()]);
          } else
            return const ListLoadingSkeleton();
        },
      ),
    );
  }

  Future showTagAddingDialog(ProjectTagsController controller, BuildContext context) async {
    final inputController = TextEditingController();

    await showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        material: (_, __) => MaterialAlertDialogData(
          title: Text(tr('enterTag')),
          content: TextField(
            autofocus: true,
            textInputAction: TextInputAction.done,
            controller: inputController,
            decoration: const InputDecoration.collapsed(hintText: ''),
            onSubmitted: (value) {
              controller.createTag(value);
            },
          ),
          actions: <Widget>[
            PlatformDialogAction(
              child: Text(
                tr('cancel'),
                style: TextStyleHelper.button(),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            PlatformDialogAction(
              child: Text(
                tr('confirm').toUpperCase(),
                style: TextStyleHelper.button(color: Get.theme.colors().colorError),
              ),
              onPressed: () {
                controller.createTag(inputController.text);
                Get.back();
              },
            ),
          ],
        ),
        cupertino: (_, __) => CupertinoAlertDialogData(
          title: Text(tr('enterTag')),
          content: CupertinoTextField(
            autofocus: true,
            textInputAction: TextInputAction.done,
            controller: inputController,
            // decoration: const InputDecoration.collapsed(hintText: ''),
            onSubmitted: (value) {
              controller.createTag(value);
            },
          ),
          actions: <Widget>[
            PlatformDialogAction(
              child: Text(
                tr('cancel'),
                style: TextStyleHelper.button(),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            PlatformDialogAction(
              child: Text(
                tr('confirm').toUpperCase(),
                style: TextStyleHelper.button(color: Get.theme.colors().colorError),
              ),
              onPressed: () {
                controller.createTag(inputController.text);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final String title;
  final controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
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
                    style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsSearchBar extends StatelessWidget {
  const _TagsSearchBar({
    Key? key,
    required this.controller,
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
          const SizedBox(width: 20),
          SizedBox(
            height: 24,
            width: 24,
            child: InkWell(
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsList extends StatelessWidget {
  const _TagsList({
    Key? key,
    required this.controller,
    required this.onTapFunction,
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
              tagItemDTO: controller.tags[i] as TagItemDTO?,
              onTapFunction: () {
                controller.changeTagSelection(controller.tags[i]);
              },
            ),
            itemExtent: 65,
            itemCount: controller.tags.length as int?,
          ),
        )
      ],
    );
  }
}
