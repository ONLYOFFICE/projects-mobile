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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/projects_view/search_appbar.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';

class NewProject extends StatelessWidget {
  const NewProject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewProjectController());

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchAppBar(
        title: CustomHeader(
          function: controller.confirm,
          title: 'Project',
        ),
      ),
      body: ListView(
        children: [
          TitleInput(controller: controller),
          ProjectManager(
            controller: controller,
          ),
          TeamMembers(
            controller: controller,
          ),
          InkWell(
            onTap: () {
              Get.toNamed('NewProjectDescription');
            },
            child: Obx(
              () => controller.descriptionText.isEmpty
                  ? DescriptionButton(controller: controller)
                  : DescriptionText(controller: controller),
            ),
          ),
          AdvancedOptions(controller: controller),
        ],
      ),
    );
  }
}

class OptionWithSwitch extends StatelessWidget {
  const OptionWithSwitch({
    Key key,
    @required this.title,
    @required this.switcher,
  }) : super(key: key);

  final String title;
  final Obx switcher;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(56, 0, 16, 0),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                title,
                style: TextStyleHelper.subtitle1(),
              ),
              switcher,
            ],
          ),
        ],
      ),
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
          SizedBox(
            width: 56,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: controller.titleController,
                          obscureText: false,
                          style: TextStyleHelper.headline7(
                              color:
                                  Theme.of(context).customColors().onSurface),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Project Title',
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

  final NewProjectController controller;

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
                SizedBox(height: 10),
                Obx(
                  () => controller.projectManager.value != null
                      ? Tile(
                          subtitle: controller.managerName.value,
                          closeFunction: controller.removeManager,
                          title: 'Project manager:',
                          iconData: Icons.close,
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed('ProjectManagerSelectionView');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Choose project manager',
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

class Tile extends StatelessWidget {
  const Tile(
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
            onTap: () {
              closeFunction();
            },
            child: Icon(
              iconData,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 23),
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

  final NewProjectController controller;

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
                SizedBox(height: 10),
                Obx(
                  () => controller.teamMembers.isNotEmpty
                      ? Tile(
                          subtitle: controller.teamMembersTitle,
                          closeFunction: controller.editTeamMember,
                          title: 'Team',
                          iconData: controller.teamMembers.length >= 2
                              ? Icons.navigate_next
                              : Icons.close,
                        )
                      : Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed('TeamMembersSelectionView');
                                },
                                child: Text(
                                  'Add team members',
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
          SizedBox(
            width: 56,
          ),
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
                          'Add description',
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
                SizedBox(
                  height: 18,
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
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
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
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Advanced options',
                          style: TextStyleHelper.subtitle1(
                              color:
                                  Theme.of(context).customColors().onSurface),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      OptionWithSwitch(
                        // controller: controller,
                        title: 'Notify Project Manager by email',
                        switcher: Obx(
                          () => Switch(
                            value: controller.notificationEnabled.value,
                            onChanged: (value) {
                              controller.enableNotification(value);
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
                      ),
                      OptionWithSwitch(
                        // controller: controller,
                        title: 'Save this project as private',
                        switcher: Obx(
                          () => Switch(
                            value: controller.isPrivate.value,
                            onChanged: (value) {
                              controller.setPrivate(value);
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
                      ),
                      OptionWithSwitch(
                        // controller: controller,
                        title: 'Follow this project',
                        switcher: Obx(
                          () => Switch(
                            value: controller.isFolowed.value,
                            onChanged: (value) {
                              controller.folow(value);
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
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
