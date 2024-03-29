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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tags_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/platform_icons_ext.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/projects_view/widgets/tag_item.dart';

class TagsSelectionView extends StatelessWidget {
  const TagsSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final projController = args['controller'] as BaseProjectEditorController;
    final previousPage = args['previousPage'] as String?;

    final controller = Get.put(ProjectTagsController());
    controller.setup(projController);

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
      floatingActionButton: AnimatedPadding(
        padding: EdgeInsets.zero,
        duration: const Duration(milliseconds: 100),
        child: Obx(
          () => Visibility(
            visible: controller.fabIsVisible.value,
            child: StyledFloatingActionButton(
              onPressed: () => showTagAddingDialog(controller),
              child: Icon(
                PlatformIcons(context).plus,
                color: Theme.of(context).colors().onPrimarySurface,
              ),
            ),
          ),
        ),
      ),
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        title: Text(
          tr('tags'),
          style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
        ),
        titleWidth: TextUtils.getTextWidth(
            tr('tags'), TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface)),
        previousPageTitle: previousPage,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: PlatformIconButton(
                icon: Icon(PlatformIcons(context).checkMark), onPressed: controller.confirm),
          ),
        ],
        bottom: SearchField(
          hintText: tr('searchTags'),
          controller: controller.searchInputController,
          onChanged: controller.newSearch,
          onSubmitted: controller.newSearch,
          onClearPressed: controller.clearSearch,
        ),
      ),
      body: Obx(
        () {
          if (controller.loaded.value == true &&
              controller.filteredTags.isNotEmpty &&
              controller.isSearchResult.value == false) {
            return _TagsList(
              controller: controller,
              onTapFunction: () => {},
            );
          } else if (controller.loaded.value == true && controller.filteredTags.isEmpty) {
            return const NothingFound();
          } else
            return const ListLoadingSkeleton();
        },
      ),
    );
  }

  Future showTagAddingDialog(controller) async {
    final inputController = TextEditingController();
    final validate = ValueNotifier(true);
    void onSubmited(String text) {
      controller.createTag(text);
      Get.back();
    }

    await Get.find<NavigationController>().showPlatformDialog(
      ValueListenableBuilder<bool>(
        valueListenable: validate,
        builder: (context, value, child) {
          return StyledAlertDialog(
            titleText: tr('enterTag'),
            content: _TagTextFieldWidget(
              inputController: inputController,
              onSubmited: onSubmited,
              validate: validate,
            ),
            acceptText: tr('confirm').toUpperCase(),
            onAcceptTap: () {
              if (inputController.text.isNotEmpty) {
                onSubmited(inputController.text);
              } else {
                validate.value = false;
              }
            },
            onCancelTap: Get.back,
          );
        },
      ),
    );
  }
}

class _TagTextFieldWidget extends StatelessWidget {
  final TextEditingController inputController;
  final Function(String) onSubmited;
  final ValueNotifier<bool> validate;

  const _TagTextFieldWidget({
    Key? key,
    required this.inputController,
    required this.onSubmited,
    required this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).errorColor;
    return Container(
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
      margin: const EdgeInsets.only(top: 10),
      child: PlatformTextField(
        makeCupertinoDecorationNull: true,
        autofocus: true,
        textInputAction: TextInputAction.done,
        controller: inputController,
        onChanged: (str) {
          if (str.isNotEmpty) validate.value = true;
        },
        hintText: '',
        material: (_, __) => MaterialTextFieldData(
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            errorText: !validate.value ? tr('newTagNoTitleErrorMessage') : null,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colors().onSurface.withOpacity(0.42))),
            focusedErrorBorder: !validate.value
                ? UnderlineInputBorder(borderSide: BorderSide(color: errorColor))
                : null,
            errorBorder: !validate.value
                ? UnderlineInputBorder(borderSide: BorderSide(color: errorColor))
                : null,
          ),
        ),
        cupertino: (_, __) => CupertinoTextFieldData(
          decoration: BoxDecoration(
            color: Theme.of(context).colors().background,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Theme.of(context).colors().outline, width: 0.5),
          ),
          placeholderStyle: TextStyleHelper.body2(
            color: Theme.of(context).colors().onSurface.withOpacity(0.5),
          ),
        ),
        style: TextStyleHelper.body2(color: Theme.of(context).colors().onSurface),
        onSubmitted: (value) {
          if (inputController.text.isNotEmpty) {
            onSubmited(value);
          } else {
            validate.value = false;
          }
        },
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
  final ProjectTagsController controller;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, i) => !platformController.isMobile
                ? const StyledDivider(
                    leftPadding: 16,
                    rightPadding: 16,
                  )
                : const SizedBox(),
            itemBuilder: (c, i) => TagItem(
              tagItemDTO: controller.filteredTags[i],
              onTapFunction: () {
                controller.changeTagSelection(controller.filteredTags[i]);
              },
            ),
            itemCount: controller.filteredTags.length,
          ),
        )
      ],
    );
  }
}
