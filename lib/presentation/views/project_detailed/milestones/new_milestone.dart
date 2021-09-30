import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';

class NewMilestoneView extends StatelessWidget {
  const NewMilestoneView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newMilestoneController = Get.find<NewMilestoneController>();
    var projectDetailed = Get.arguments['projectDetailed'];
    newMilestoneController.setup(projectDetailed);

    return WillPopScope(
      onWillPop: () async {
        newMilestoneController.discard();
        return false;
      },
      child: Scaffold(
        backgroundColor: Get.theme.colors().backgroundColor,
        appBar: StyledAppBar(
            titleText: tr('newMilestone'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: () => newMilestoneController.confirm(context))
            ],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => newMilestoneController.discard())),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 16),
                MilestoneInput(controller: newMilestoneController),
                ProjectTile(controller: newMilestoneController),
                if (newMilestoneController.slectedProjectTitle.value.isNotEmpty)
                  ResponsibleTile(controller: newMilestoneController),
                DescriptionTile(newMilestoneController: newMilestoneController),
                DueDateTile(controller: newMilestoneController),
                const SizedBox(height: 5),
                AdvancedOptions(
                  options: <Widget>[
                    OptionWithSwitch(
                      title: tr('keyMilestone'),
                      switchValue: newMilestoneController.keyMilestone,
                      switchOnChanged: (value) {
                        if (!FocusScope.of(context).hasPrimaryFocus) {
                          FocusScope.of(context).unfocus();
                        }
                        newMilestoneController.setKeyMilestone(value);
                      },
                    ),
                    OptionWithSwitch(
                      title: tr('remindBeforeDue'),
                      switchValue: newMilestoneController.remindBeforeDueDate,
                      switchOnChanged: (value) {
                        if (!FocusScope.of(context).hasPrimaryFocus) {
                          FocusScope.of(context).unfocus();
                        }

                        newMilestoneController.enableRemindBeforeDueDate(value);
                      },
                    ),
                    OptionWithSwitch(
                      title: tr('notifyResponsible'),
                      switchValue: newMilestoneController.notificationEnabled,
                      switchOnChanged: (value) {
                        newMilestoneController.enableNotification(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MilestoneInput extends StatelessWidget {
  final controller;
  const MilestoneInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72, right: 25),
      child: Obx(
        () => TextField(
          maxLines: 2,
          controller: controller.titleController,
          style:
              TextStyleHelper.headline6(color: Get.theme.colors().onBackground),
          cursorColor: Get.theme.colors().primary.withOpacity(0.87),
          decoration: InputDecoration(
              hintText: tr('milestoneTitle'),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              hintStyle: TextStyleHelper.headline6(
                  color: controller.needToSetTitle.value
                      ? Get.theme.colors().colorError
                      : Get.theme.colors().onSurface.withOpacity(0.5)),
              border: InputBorder.none),
        ),
      ),
    );
  }
}

class DescriptionTile extends StatelessWidget {
  final newMilestoneController;
  const DescriptionTile({
    Key key,
    @required this.newMilestoneController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSletected =
            newMilestoneController.descriptionText.value.isNotEmpty;
        return NewItemTile(
            text: _isSletected
                ? newMilestoneController.descriptionText.value
                : tr('addDescription'),
            maxLines: 1,
            icon: SvgIcons.description,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            caption: _isSletected ? tr('description') : null,
            isSelected: _isSletected,
            suffix: _isSletected
                ? Icon(Icons.navigate_next,
                    size: 24, color: Get.theme.colors().onBackground)
                : null,
            onTap: () => Get.find<NavigationController>()
                    .toScreen(const NewMilestoneDescription(), arguments: {
                  'newMilestoneController': newMilestoneController,
                }));
      },
    );
  }
}

class ProjectTile extends StatelessWidget {
  final controller;
  const ProjectTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.slectedProjectTitle.value.isNotEmpty;
        return NewItemTile(
            text: _isSelected
                ? controller.slectedProjectTitle.value
                : tr('selectProject'),
            icon: SvgIcons.project,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            textColor: controller.needToSelectProject.value
                ? Get.theme.colors().colorError
                : null,
            isSelected: _isSelected,
            caption: _isSelected ? tr('project') : null,
            suffix: _isSelected
                ? IconButton(
                    icon: Icon(Icons.navigate_next,
                        size: 24, color: Get.theme.colors().onBackground),
                    onPressed: () => controller.changeDueDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 13),
            onTap: () => {
                  // if (!FocusScope.of(context).hasPrimaryFocus)
                  //   {FocusScope.of(context).unfocus()},
                  Get.find<NavigationController>()
                      .toScreen(const SelectProjectView(), arguments: {
                    'controller': controller,
                  }),
                });
      },
    );
  }
}

class ResponsibleTile extends StatelessWidget {
  final controller;
  const ResponsibleTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //strange behavior of obx if rx value is used like this:
      //var _isSelected = controller.responsible != null;
      return NewItemTile(
        isSelected: controller.responsible?.value != null,
        caption:
            controller.responsible?.value != null ? tr('assignedTo') : null,
        text: controller.responsible?.value != null
            ? '${controller.responsible.value.portalUser.displayName}'
            : tr('addResponsible'),
        textColor: controller.needToSelectResponsible.value
            ? Get.theme.colors().colorError
            : null,
        suffix: controller.responsible?.value != null
            ? Icon(Icons.navigate_next,
                size: 24, color: Get.theme.colors().onBackground)
            : null,
        icon: SvgIcons.person,
        iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
        selectedIconColor: Get.theme.colors().onBackground,
        onTap: () => {
          if (!FocusScope.of(context).hasPrimaryFocus)
            {FocusScope.of(context).unfocus()},
          Get.find<NavigationController>().to(const SelectProjectView(),
              arguments: {'controller': controller})
          // Get.find<NavigationController>().toScreen(
          //     const ProjectTeamResponsibleSelectionView(),
          //     arguments: {'controller': controller})
        },
      );
    });
  }
}

class DueDateTile extends StatelessWidget {
  final controller;
  const DueDateTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.dueDateText.value.isNotEmpty;
        return NewItemTile(
            icon: SvgIcons.due_date,
            iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
            selectedIconColor: Get.theme.colors().onBackground,
            text: _isSelected ? controller.dueDateText.value : tr('setDueDate'),
            caption: _isSelected ? tr('startDate') : null,
            isSelected: _isSelected,
            textColor: controller.needToSetDueDate.value
                ? Get.theme.colors().colorError
                : null,
            suffix: _isSelected
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 24, color: Get.theme.colors().onBackground),
                    onPressed: () => controller.changeDueDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 13),
            onTap: () => {
                  if (!FocusScope.of(context).hasPrimaryFocus)
                    {FocusScope.of(context).unfocus()},
                  controller.onDueDateTilePressed()
                });
      },
    );
  }
}
