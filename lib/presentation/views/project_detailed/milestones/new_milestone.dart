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
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';

class NewMilestoneView extends StatelessWidget {
  const NewMilestoneView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewMilestoneController>();
    var projectDetailed = Get.arguments['projectDetailed'];
    controller.setup(projectDetailed);

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: StyledAppBar(
          titleText: tr('newMilestone'),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: () => controller.confirm(context))
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => controller.discard())),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 16),
              MilestoneInput(controller: controller),
              ProjectTile(controller: controller),
              if (controller.slectedProjectTitle.value.isNotEmpty)
                ResponsibleTile(controller: controller),
              // if (controller.responsibles.isNotEmpty)
              //   NotifyResponsiblesTile(controller: controller),
              DescriptionTile(controller: controller),
              DueDateTile(controller: controller),
              const SizedBox(height: 5),
              AdvancedOptions(controller: controller)
            ],
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
      padding: const EdgeInsets.only(left: 56, right: 16),
      child: Obx(
        () => TextField(
          // autofocus: controller.titleController.text.isEmpty,
          maxLines: 2,
          controller: controller.titleController,
          // onChanged: (value) => controller.changeTitle(value),
          style: TextStyleHelper.headline6(
              color: Theme.of(context).customColors().onBackground),
          cursorColor:
              Theme.of(context).customColors().primary.withOpacity(0.87),
          decoration: InputDecoration(
              hintText: tr('milestoneTitle'),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              hintStyle: TextStyleHelper.headline6(
                  color: controller.needToSetTitle.value
                      ? Theme.of(context).customColors().error
                      : Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.5)),
              border: InputBorder.none),
        ),
      ),
    );
  }
}

class AdvancedOptions extends StatelessWidget {
  const AdvancedOptions({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final NewMilestoneController controller;

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
                        title: tr('keyMilestone'),
                        switchValue: controller.keyMilestone,
                        switchOnChanged: (value) {
                          if (!FocusScope.of(context).hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          controller.setKeyMilestone(value);
                        },
                      ),
                      OptionWithSwitch(
                        title: tr('remindBeforeDue'),
                        switchValue: controller.remindBeforeDueDate,
                        switchOnChanged: (value) {
                          if (!FocusScope.of(context).hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }

                          controller.enableRemindBeforeDueDate(value);
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
            onTap: () => Get.toNamed('NewMilestoneDescription'));
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
        return NewMilestoneInfo(
            text: _isSelected
                ? controller.slectedProjectTitle.value
                : tr('selectProject'),
            icon: SvgIcons.project,
            textColor: controller.needToSelectProject.value
                ? Theme.of(context).customColors().error
                : null,
            isSelected: _isSelected,
            caption: _isSelected ? tr('project') : null,
            onTap: () => {
                  // if (!FocusScope.of(context).hasPrimaryFocus)
                  //   {FocusScope.of(context).unfocus()},
                  Get.toNamed('SelectProjectForMilestone'),
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
    var _isSelected = controller.responsible != null;
    return Obx(
      () => NewMilestoneInfo(
        isSelected: _isSelected,
        caption: _isSelected ? tr('assignedTo') : null,
        text: _isSelected ? plural('responsibles', 1) : tr('addResponsible'),
        textColor: controller.needToSelectResponsible.value
            ? Theme.of(context).customColors().error
            : null,
        suffix: _isSelected
            ? Icon(Icons.arrow_forward_ios_outlined,
                size: 20,
                color:
                    Theme.of(context).customColors().onSurface.withOpacity(0.6))
            : null,
        icon: SvgIcons.person,
        onTap: () => {
          if (!FocusScope.of(context).hasPrimaryFocus)
            {FocusScope.of(context).unfocus()},
          Get.to(const SelectMilestoneResponsible())
        },
      ),
    );
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
        return NewMilestoneInfo(
            icon: SvgIcons.due_date,
            text: _isSelected ? controller.dueDateText.value : tr('setDueDate'),
            caption: _isSelected ? tr('startDate') : null,
            isSelected: _isSelected,
            suffix: _isSelected
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 23,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6)),
                    onPressed: () => controller.changeDueDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 10),
            onTap: () => {
                  if (!FocusScope.of(context).hasPrimaryFocus)
                    {FocusScope.of(context).unfocus()},
                  controller.onDueDateTilePressed()
                }
            // Get.toNamed('SelectDateView',
            //     arguments: {'controller': controller, 'startDate': false})
            );
      },
    );
  }
}

class NewMilestoneInfo extends StatelessWidget {
  final int maxLines;
  final bool isSelected;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;

  const NewMilestoneInfo({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.isSelected = false,
    this.maxLines,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: icon != null
                    ? AppIcon(
                        icon: icon,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical:
                          caption != null && caption.isNotEmpty ? 10 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (caption != null && caption.isNotEmpty)
                        Text(caption,
                            style: TextStyleHelper.caption(
                                color: Theme.of(context)
                                    .customColors()
                                    .onBackground
                                    .withOpacity(0.75))),
                      Text(text,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle ??
                              TextStyleHelper.subtitle1(
                                  // ignore: prefer_if_null_operators
                                  color: textColor != null
                                      ? textColor
                                      : isSelected
                                          ? Theme.of(context)
                                              .customColors()
                                              .onBackground
                                          : Theme.of(context)
                                              .customColors()
                                              .onSurface
                                              .withOpacity(0.6))),
                    ],
                  ),
                ),
              ),
              if (suffix != null)
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(padding: suffixPadding, child: suffix)),
            ],
          ),
          if (enableBorder) const StyledDivider(leftPadding: 56.5),
        ],
      ),
    );
  }
}

class SelectProjectForMilestone extends StatelessWidget {
  const SelectProjectForMilestone({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.put(
        ProjectsController(
          Get.put(ProjectsFilterController(), tag: 'SelectProjectForMilestone'),
          Get.put(PaginationController(), tag: 'SelectProjectForMilestone'),
        ),
        tag: 'SelectProjectForMilestone');

    _projectsController.loadProjects();

    var _searchController =
        Get.put(ProjectSearchController(), tag: 'SelectProjectForMilestone');

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('selectProject'),
        bottomHeight: 44,
        bottom: SearchField(
          hintText: tr('searchProjects'),
          controller: _searchController.searchInputController,
          showClearIcon: true,
          onSubmitted: (value) => _searchController.newSearch(value),
          onClearPressed: () => _searchController.clearSearch(),
        ),
      ),
      body: Obx(() {
        if (_searchController.switchToSearchView.isTrue &&
            _searchController.searchResult.isNotEmpty) {
          return ProjectsList(projects: _searchController.searchResult);
        }
        if (_searchController.switchToSearchView.isTrue &&
            _searchController.searchResult.isEmpty &&
            _searchController.loaded.isTrue) {
          return const NothingFound();
        }
        if (_projectsController.loaded.isTrue &&
            _searchController.switchToSearchView.isFalse) {
          return ProjectsList(
              projects: _projectsController.paginationController.data);
        }
        return const ListLoadingSkeleton();
      }),
    );
  }
}

class ProjectsList extends StatelessWidget {
  final List projects;
  const ProjectsList({
    Key key,
    @required this.projects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewMilestoneController>();
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) {
        return const StyledDivider(leftPadding: 16, rightPadding: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {
              controller.changeProjectSelection(
                  id: projects[index].id, title: projects[index].title);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projects[index].title,
                          style: TextStyleHelper.projectTitle,
                        ),
                        // Text(projects[index].milestoneResponsible.displayName,
                        //     style: TextStyleHelper.caption(
                        //             color: Theme.of(context)
                        //                 .customColors()
                        //                 .onSurface
                        //                 .withOpacity(0.6))
                        //         .copyWith(height: 1.667)),
                      ],
                    ),
                  ),
                  // Icon(Icons.check_rounded)
                ],
              ),
            ),
          ),
        );
      },
    );
    // },
    // );
  }
}

class SelectMilestoneResponsible extends StatelessWidget {
  const SelectMilestoneResponsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    var controller = Get.find<NewMilestoneController>();

    controller.setupResponsibleSelection();

    usersDataSource.selectionMode = UserSelectionMode.Single;
    return Scaffold(
      appBar: StyledAppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('selectResponsible')),
            ],
          ),
          bottom: SearchField(
            hintText: tr('usersSearch'),
            onSubmitted: (value) => usersDataSource.searchUsers(value),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: () => controller.confirmResponsiblesSelection())
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => controller.leaveResponsiblesSelectionView())),
      body: Obx(
        () {
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.addResponsible,
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: () => controller.addResponsible,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
