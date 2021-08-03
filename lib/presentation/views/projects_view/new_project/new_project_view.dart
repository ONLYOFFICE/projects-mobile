import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';
import 'package:projects/presentation/views/projects_view/new_project/descriprion_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:readmore/readmore.dart';

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class NewProject extends StatelessWidget {
  const NewProject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewProjectController());

    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('project'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_outlined),
            onPressed: () => {
              controller.confirm(),
            },
          )
        ],
      ),
      body: Listener(
        onPointerDown: (_) {
          if (controller.titleController.text.isNotEmpty &&
              controller.titleFocus.hasFocus) controller.titleFocus.unfocus();
        },
        child: ListView(
          children: [
            TitleInput(controller: controller),
            InkWell(
              onTap: () {
                Get.find<NavigationController>().showScreen(
                    const ProjectManagerSelectionView(),
                    arguments: {'controller': controller});
              },
              child: ProjectManager(
                controller: controller,
              ),
            ),
            InkWell(
              onTap: () {
                Get.find<NavigationController>().showScreen(
                    const TeamMembersSelectionView(),
                    arguments: {'controller': controller});
              },
              child: TeamMembers(
                controller: controller,
              ),
            ),
            DescriptionTile(controller: controller),
            AdvancedOptions(controller: controller),
          ],
        ),
      ),
    );
  }
}

class DescriptionTile extends StatelessWidget {
  final controller;
  const DescriptionTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSletected = controller.descriptionText.value.isNotEmpty;
        return NewMilestoneInfo(
          text: _isSletected
              ? controller.descriptionText.value
              : tr('addDescription'),
          maxLines: 1,
          icon: SvgIcons.description,
          caption: _isSletected ? tr('description') : null,
          isSelected: _isSletected,
          suffix: _isSletected
              ? Icon(Icons.arrow_forward_ios_outlined,
                  size: 20,
                  color: Get.theme.colors().onSurface.withOpacity(0.6))
              : null,
          onTap: () => Get.find<NavigationController>().showScreen(
              const NewProjectDescription(),
              arguments: {'controller': controller}),
        );
      },
    );
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final NewProjectController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 56),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Obx(
                          () => TextFormField(
                            controller: controller.titleController,
                            focusNode: controller.titleFocus,
                            obscureText: false,
                            style: TextStyleHelper.headline7(
                                color: Get.theme.colors().onSurface),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: tr('projectTitle'),
                              hintStyle: TextStyleHelper.headline7(
                                  color:
                                      controller.needToFillTitle.value == true
                                          ? Get.theme.colors().colorError
                                          : Get.theme
                                              .colors()
                                              .onSurface
                                              .withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectManager extends StatelessWidget {
  const ProjectManager({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            child: AppIcon(
                icon: SvgIcons.user, color: Get.theme.colors().onSurface),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => controller.isPMSelected.value
                      ? NewProjectTile(
                          subtitle: controller.managerName.value,
                          onTapFunction: controller.removeManager,
                          title: tr('projectManager'),
                          iconData: Icons.close,
                        )
                      : Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.find<NavigationController>().showScreen(
                                      const ProjectManagerSelectionView(),
                                      arguments: {'controller': controller});
                                },
                                child: Obx(
                                  () => Text(
                                    tr('choosePM'),
                                    style: TextStyleHelper.subtitle1(
                                      color: controller.needToFillManager.value
                                          ? Get.theme.colors().colorError
                                          : Get.theme
                                              .colors()
                                              .onSurface
                                              .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewProjectTile extends StatelessWidget {
  const NewProjectTile(
      {Key key,
      @required this.subtitle,
      @required this.title,
      @required this.onTapFunction,
      @required this.iconData})
      : super(key: key);

  final String subtitle;
  final String title;
  final IconData iconData;
  final Function() onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyleHelper.caption()),
                Text(subtitle, style: TextStyleHelper.subtitle1())
              ],
            ),
          ),
          InkWell(
            onTap: onTapFunction,
            child: Icon(
              iconData,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 23),
        ],
      ),
    );
  }
}

class TeamMembers extends StatelessWidget {
  const TeamMembers({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            child: AppIcon(
                icon: SvgIcons.users, color: Get.theme.colors().onSurface),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => controller.selectedTeamMembers.isNotEmpty
                      ? NewProjectTile(
                          subtitle: controller.teamMembersTitle,
                          onTapFunction: controller.editTeamMember,
                          title: tr('team'),
                          iconData: controller.selectedTeamMembers.length >= 2
                              ? Icons.navigate_next
                              : Icons.close,
                        )
                      : Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.find<NavigationController>().showScreen(
                                      const TeamMembersSelectionView(),
                                      arguments: {'controller': controller});
                                },
                                child: Text(
                                  tr('addTeamMembers'),
                                  style: TextStyleHelper.subtitle1(
                                    color: Get.theme
                                        .colors()
                                        .onSurface
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionButton extends StatelessWidget {
  const DescriptionButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final NewProjectController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 56),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          tr('addDescription'),
                          style: TextStyleHelper.subtitle1(
                              color: Get.theme
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.4)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final NewProjectController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 56, right: 16, top: 12, bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Get.theme.colors().bgDescription, //.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ReadMoreText(
              controller.descriptionText.value,
              trimLines: 3,
              colorClickableText: Colors.pink,
              style: TextStyleHelper.body1,
              trimMode: TrimMode.Line,
              trimCollapsedText: tr('showMore'),
              trimExpandedText: tr('showLess'),
              moreStyle: TextStyleHelper.body2(color: Get.theme.colors().links),
            ),
          ),
        ),
      ],
    );
  }
}

class AdvancedOptions extends StatelessWidget {
  const AdvancedOptions({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final NewProjectController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: Get.theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: AppIcon(
                              icon: SvgIcons.preferences,
                              height: 24,
                              width: 24,
                              color: Get.theme
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          tr('advancedOptions'),
                          style: TextStyleHelper.subtitle1(
                              color: Get.theme.colors().onSurface),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      OptionWithSwitch(
                        title: tr('notifyPM'),
                        switchValue: controller.notificationEnabled,
                        switchOnChanged: (value) {
                          controller.enableNotification(value);
                        },
                      ),
                      OptionWithSwitch(
                        title: tr('privateProject'),
                        switchValue: controller.isPrivate,
                        switchOnChanged: (value) {
                          controller.setPrivate(value);
                        },
                      ),
                      Obx(() {
                        if (controller.selfUserItem?.id ==
                            controller.selectedProjectManager.value?.id)
                          return OptionWithSwitch(
                            title: tr('followProject'),
                            switchValue: false.obs,
                            switchOnChanged: null,
                          );
                        else
                          return OptionWithSwitch(
                            title: tr('followProject'),
                            switchValue: controller.isFolowed,
                            switchOnChanged: (value) {
                              controller.folow(value);
                            },
                          );
                      }),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 56,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionWithSwitch extends StatelessWidget {
  const OptionWithSwitch({
    Key key,
    @required this.title,
    @required this.switchOnChanged,
    @required this.switchValue,
  }) : super(key: key);

  final RxBool switchValue;
  final Function switchOnChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(56, 0, 16, 0),
      height: 60,
      child: Column(
        children: <Widget>[
          Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Get.theme.colors().outline,
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: FittedBox(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyleHelper.subtitle1(),
                  ),
                ),
              ),
              Obx(
                () => Switch(
                  value: switchValue.value,
                  onChanged: switchOnChanged,
                  activeTrackColor:
                      Get.theme.colors().primary.withOpacity(0.54),
                  activeColor: Get.theme.colors().primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
