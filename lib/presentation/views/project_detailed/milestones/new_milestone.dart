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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/presentation/shared/project_team_responsible.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';

class NewMilestoneView extends StatelessWidget {
  const NewMilestoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newMilestoneController = Get.find<NewMilestoneController>();
    final platformController = Get.find<PlatformController>();
    final projectDetailed = Get.arguments['projectDetailed'] as ProjectDetailed;
    newMilestoneController.setup(projectDetailed);

    return WillPopScope(
        onWillPop: () async {
          newMilestoneController.discard();
          return false;
        },
        child: Scaffold(
          backgroundColor: platformController.isMobile
              ? Get.theme.colors().backgroundColor
              : Get.theme.colors().surface,
          appBar: StyledAppBar(
            leadingWidth: GetPlatform.isIOS ? 100 : null,
            centerTitle: !GetPlatform.isAndroid,
            backgroundColor: platformController.isMobile
                ? Get.theme.colors().backgroundColor
                : Get.theme.colors().surface,
            titleText: tr('newMilestone'),
            actions: [
              PlatformWidget(
                material: (_, __) => IconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: newMilestoneController.confirm,
                ),
                cupertino: (_, __) => CupertinoButton(
                  onPressed: newMilestoneController.confirm,
                  padding: const EdgeInsets.only(right: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('done'),
                    style: TextStyleHelper.headline7(),
                  ),
                ),
              )
            ],
            leading: PlatformWidget(
              cupertino: (_, __) => CupertinoButton(
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                onPressed: newMilestoneController.discard,
                child: Text(
                  tr('cancel').toLowerCase().capitalizeFirst!,
                  style: TextStyleHelper.button(),
                ),
              ),
              material: (_, __) => IconButton(
                onPressed: newMilestoneController.discard,
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          body: Listener(
            onPointerDown: (_) {
              if (newMilestoneController.titleController.text.isNotEmpty &&
                  newMilestoneController.titleFocus.hasFocus)
                newMilestoneController.titleFocus.unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MilestoneInput(controller: newMilestoneController),
                  const StyledDivider(leftPadding: 72.5),
                  ProjectTile(controller: newMilestoneController),
                  Obx(() => newMilestoneController.slectedProjectTitle.value.isNotEmpty
                      ? ResponsibleTile(controller: newMilestoneController)
                      : const SizedBox()),
                  DescriptionTile(newMilestoneController: newMilestoneController),
                  DueDateTile(controller: newMilestoneController),
                  const SizedBox(height: 5),
                  AdvancedOptions(
                    options: [
                      const StyledDivider(
                        leftPadding: 72,
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                        child: OptionWithSwitch(
                          title: tr('keyMilestone'),
                          switchValue: newMilestoneController.keyMilestone,
                          switchOnChanged: (bool value) {
                            newMilestoneController.setKeyMilestone(value);
                          },
                        ),
                      ),
                      const StyledDivider(
                        leftPadding: 72,
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                        child: OptionWithSwitch(
                          title: tr('remindBeforeDue'),
                          switchValue: newMilestoneController.remindBeforeDueDate,
                          switchOnChanged: (bool value) {
                            newMilestoneController.enableRemindBeforeDueDate(value);
                          },
                        ),
                      ),
                      const StyledDivider(
                        leftPadding: 72,
                        height: 1,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                        child: OptionWithSwitch(
                          title: tr('notifyResponsible'),
                          switchValue: newMilestoneController.notificationEnabled,
                          switchOnChanged: (bool value) {
                            newMilestoneController.enableNotification(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class MilestoneInput extends StatelessWidget {
  final NewMilestoneController controller;

  final bool focusOnTitle;
  const MilestoneInput({
    Key? key,
    required this.controller,
    this.focusOnTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Obx(
              () => AppIcon(
                icon: SvgIcons.milestone,
                color: controller.titleIsEmpty.isTrue
                    ? Get.theme.colors().onBackground.withOpacity(0.4)
                    : Get.theme.colors().onBackground.withOpacity(0.75),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final needToSetTitle = controller.needToSetTitle.value;
              return PlatformTextField(
                focusNode: focusOnTitle ? controller.titleFocus : null,
                maxLines: null,
                controller: controller.titleController,
                style: TextStyleHelper.headline6(color: Get.theme.colors().onBackground),
                cursorColor: Get.theme.colors().primary.withOpacity(0.87),
                hintText: tr('milestoneTitle'),
                cupertino: (_, __) => CupertinoTextFieldData(
                  padding: EdgeInsets.zero,
                  placeholderStyle: TextStyleHelper.headline6(
                      color: needToSetTitle
                          ? Get.theme.colors().colorError
                          : Get.theme.colors().onSurface.withOpacity(0.5)),
                ),
                material: (_, __) => MaterialTextFieldData(
                  decoration: InputDecoration(
                      hintText: tr('milestoneTitle'),
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyleHelper.headline6(
                          color: needToSetTitle
                              ? Get.theme.colors().colorError
                              : Get.theme.colors().onSurface.withOpacity(0.5)),
                      border: InputBorder.none),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class DescriptionTile extends StatelessWidget {
  final NewMilestoneController newMilestoneController;
  const DescriptionTile({
    Key? key,
    required this.newMilestoneController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final _isSletected = newMilestoneController.descriptionText.value.isNotEmpty;
        return NewItemTile(
            text:
                _isSletected ? newMilestoneController.descriptionText.value : tr('addDescription'),
            maxLines: 1,
            icon: SvgIcons.description,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            caption: _isSletected ? tr('description') : null,
            isSelected: _isSletected,
            suffix: _isSletected
                ? Icon(PlatformIcons(context).rightChevron,
                    size: 24, color: Get.theme.colors().onBackground)
                : null,
            onTap: () => Get.find<NavigationController>().toScreen(
                  const NewMilestoneDescription(),
                  arguments: {'newMilestoneController': newMilestoneController},
                  transition: Transition.rightToLeft,
                  isRootModalScreenView: false,
                ));
      },
    );
  }
}

class ProjectTile extends StatelessWidget {
  final NewMilestoneController controller;
  const ProjectTile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  void _onPressed() => Get.find<NavigationController>().toScreen(
        const SelectProjectView(),
        arguments: {'controller': controller},
        transition: Transition.rightToLeft,
        isRootModalScreenView: false,
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final _isSelected = controller.slectedProjectTitle.value.isNotEmpty;
        return NewItemTile(
            text: _isSelected ? controller.slectedProjectTitle.value : tr('selectProject'),
            icon: SvgIcons.project,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            textColor: controller.needToSelectProject.value ? Get.theme.colors().colorError : null,
            isSelected: _isSelected,
            caption: _isSelected ? tr('project') : null,
            suffix: _isSelected
                ? PlatformIconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      PlatformIcons(context).rightChevron,
                      size: 24,
                      color: Get.theme.colors().onBackground.withOpacity(0.6),
                    ),
                    onPressed: _onPressed,
                  )
                : null,
            suffixPadding: const EdgeInsets.only(right: 8),
            onTap: _onPressed);
      },
    );
  }
}

class ResponsibleTile extends StatelessWidget {
  final NewMilestoneController controller;
  const ResponsibleTile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _isSelected = controller.responsible.value != null;
      return NewItemTile(
        isSelected: _isSelected,
        caption: _isSelected ? tr('assignedTo') : null,
        text: _isSelected
            ? '${controller.responsible.value?.portalUser.displayName}'
            : tr('addResponsible'),
        textColor: controller.needToSelectResponsible.value ? Get.theme.colors().colorError : null,
        suffix: _isSelected
            ? Icon(PlatformIcons(context).rightChevron,
                size: 24, color: Get.theme.colors().onBackground)
            : null,
        icon: SvgIcons.person,
        iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
        selectedIconColor: Get.theme.colors().onBackground,
        onTap: () => {
          Get.find<NavigationController>().toScreen(
            const ProjectTeamResponsibleSelectionView(),
            arguments: {'controller': controller},
            transition: Transition.rightToLeft,
            isRootModalScreenView: false,
          )
        },
      );
    });
  }
}

class DueDateTile extends StatelessWidget {
  final NewMilestoneController controller;
  const DueDateTile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final _isSelected = controller.dueDateText.value.isNotEmpty;
        return NewItemTile(
            icon: SvgIcons.due_date,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            text: _isSelected ? controller.dueDateText.value : tr('setDueDate'),
            caption: _isSelected ? tr('dueDate') : null,
            isSelected: _isSelected,
            textColor: controller.needToSetDueDate.value ? Get.theme.colors().colorError : null,
            suffix: _isSelected
                ? PlatformIconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      PlatformIcons(context).clear,
                      size: 24,
                      color: Get.theme.colors().onBackground,
                    ),
                    onPressed: () => controller.changeDueDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 8),
            onTap: controller.onDueDateTilePressed);
      },
    );
  }
}
