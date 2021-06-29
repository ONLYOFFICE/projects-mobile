import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:readmore/readmore.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectDetailed projectDetailed;
  final TabController tabController;

  const ProjectOverview(
      {Key key, @required this.projectDetailed, this.tabController})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    var projectController = Get.find<ProjectDetailsController>();

    return Obx(
      () {
        if (projectController.loaded.isTrue) {
          return ListView(
            children: [
              const SizedBox(height: 26),
              Obx(() => InfoTile(
                    caption: tr('project').toUpperCase(),
                    subtitle: projectController.projectTitleText.value,
                    subtitleStyle: TextStyleHelper.headline7(
                        color: Theme.of(context).customColors().onBackground),
                  )),
              const SizedBox(height: 20),
              ProjectStatusButton(projectController: projectController),
              const SizedBox(height: 20),
              if (projectController.descriptionText != null &&
                  projectController.descriptionText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InfoTile(
                    caption: tr('description'),
                    icon: AppIcon(
                        icon: SvgIcons.description,
                        color: const Color(0xff707070)),
                    subtitleWidget: ReadMoreText(
                      projectController.descriptionText.value,
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
              Obx(() => InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.user, color: const Color(0xff707070)),
                    caption: tr('projectManager'),
                    subtitle: projectController.managerText.value,
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Theme.of(context).customColors().onSurface),
                  )),
              const SizedBox(height: 20),
              Obx(
                () => InfoTileWithButton(
                  icon: AppIcon(
                      icon: SvgIcons.users, color: const Color(0xff707070)),
                  onTapFunction: () {
                    tabController.animateTo(5);
                  },
                  caption: tr('team'),
                  iconData: Icons.navigate_next,
                  subtitle: plural(
                      'members', projectController.teamMembersCount.value),
                  subtitleStyle: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().onSurface),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.calendar, color: const Color(0xff707070)),
                  caption: tr('creationDate'),
                  subtitle: projectController.creationDateText.value)),
              const SizedBox(height: 20),
              Obx(() => InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.tag, color: const Color(0xff707070)),
                  caption: tr('tags'),
                  subtitle: projectController.tagsText.value)),
            ],
          );
        }
      },
    );
  }
}

class ProjectStatusButton extends StatelessWidget {
  final ProjectDetailsController projectController;

  const ProjectStatusButton({Key key, @required this.projectController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
            onPressed: () => {
              showsStatusesBS(
                  context: context, itemController: projectController),
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
                return const Color(0xff81C4FF).withOpacity(0.1);
              }),
              side: MaterialStateProperty.resolveWith((_) {
                return const BorderSide(color: Color(0xff0C76D5), width: 1.5);
              }),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Obx(() => Text(projectController.statusText.value,
                        style: TextStyleHelper.subtitle2())),
                  ),
                ),
                const Icon(Icons.arrow_drop_down_sharp)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
