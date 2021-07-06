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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
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
                Get.toNamed('ProjectManagerSelectionView',
                    arguments: {'controller': controller});
              },
              child: ProjectManager(
                controller: controller,
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed('TeamMembersSelectionView',
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
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6))
                : null,
            onTap: () => Get.toNamed('NewProjectDescription',
                arguments: {'controller': controller}));
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
                                color:
                                    Theme.of(context).customColors().onSurface),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: tr('projectTitle'),
                              hintStyle: TextStyleHelper.headline7(
                                  color: controller.needToFillTitle.isTrue
                                      ? Theme.of(context).customColors().error
                                      : Theme.of(context)
                                          .customColors()
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
                icon: SvgIcons.user,
                color: Theme.of(context).customColors().onSurface),
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
                          closeFunction: controller.removeManager,
                          title: tr('projectManager'),
                          iconData: Icons.close,
                        )
                      : Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed('ProjectManagerSelectionView',
                                      arguments: {'controller': controller});
                                },
                                child: Obx(
                                  () => Text(
                                    tr('choosePM'),
                                    style: TextStyleHelper.subtitle1(
                                      color: controller.needToFillManager.value
                                          ? Theme.of(context)
                                              .customColors()
                                              .error
                                          : Theme.of(context)
                                              .customColors()
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
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color(0xffD8D8D8),
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
      @required this.closeFunction,
      @required this.iconData})
      : super(key: key);

  final String subtitle;
  final String title;
  final IconData iconData;
  final Function() closeFunction;

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
            onTap: closeFunction,
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
                icon: SvgIcons.users,
                color: Theme.of(context).customColors().onSurface),
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
                          closeFunction: controller.editTeamMember,
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
                                  Get.toNamed('TeamMembersSelectionView',
                                      arguments: {'controller': controller});
                                },
                                child: Text(
                                  tr('addTeamMembers'),
                                  style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onSurface
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color(0xffD8D8D8),
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
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.4)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color(0xffD8D8D8),
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
              color: Theme.of(context)
                  .customColors()
                  .bgDescription, //.withOpacity(0.2),
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
              moreStyle: TextStyleHelper.body2(
                  color: Theme.of(context).customColors().links),
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
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
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
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          tr('advancedOptions'),
                          style: TextStyleHelper.subtitle1(
                              color:
                                  Theme.of(context).customColors().onSurface),
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
                      OptionWithSwitch(
                        title: tr('followProject'),
                        switchValue: controller.isFolowed,
                        switchOnChanged: (value) {
                          controller.folow(value);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 56,
                  endIndent: 0,
                  color: Color(0xffD8D8D8),
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
          const Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Color(0xffD8D8D8),
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
                  activeTrackColor: Theme.of(context)
                      .customColors()
                      .primary
                      .withOpacity(0.54),
                  activeColor: Theme.of(context).customColors().primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
