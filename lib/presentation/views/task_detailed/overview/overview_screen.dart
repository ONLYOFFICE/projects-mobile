import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart'
    as bottom_sheet;
import 'package:projects/presentation/views/task_detailed/readmore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'task.dart';

class OverviewScreen extends StatelessWidget {
  final TaskItemController taskController;

  const OverviewScreen({Key key, @required this.taskController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (taskController.loaded.isTrue) {
          var task = taskController.task.value;
          return SmartRefresher(
            controller: taskController.refreshController.value,
            onRefresh: () => taskController.reloadTask(),
            child: ListView(
              children: [
                Task(taskController: taskController),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project, color: const Color(0xff707070)),
                  caption: 'Project:',
                  subtitle: task.projectOwner.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().links),
                ),
                const SizedBox(height: 20),
                if (task.milestone != null)
                  InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.milestone,
                        color: const Color(0xff707070)),
                    caption: 'Milestone:',
                    subtitle: task.milestone.title,
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Theme.of(context).customColors().links),
                  ),
                if (task.description != null)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 56, right: 32, top: 42, bottom: 42),
                    child: ReadMoreText(task.description,
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        style: TextStyleHelper.body1,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyleHelper.body2(
                            color: Theme.of(context).customColors().links)),
                  ),
                const SizedBox(height: 20),
                if (task.startDate != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Start date:',
                      subtitle: task.startDate),
                const SizedBox(height: 20),
                if (task.deadline != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.due_date,
                          color: const Color(0xff707070)),
                      caption: 'Due date:',
                      subtitle: formatedDate(
                          now: DateTime.now(), stringDate: task.deadline)),
                const SizedBox(height: 20),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.priority,
                        color: const Color(0xffff7793)),
                    caption: 'Priority:',
                    subtitle: 'High'),
                const SizedBox(height: 20),
                if (task.responsible != null || task.responsibles.length >= 2)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.person,
                          color: const Color(0xff707070)),
                      caption: 'Assigned to:',
                      subtitle: task.responsibles.length >= 2
                          ? '${task.responsibles.length} responsibles'
                          : task.responsible.id),
                const SizedBox(height: 20),
                InfoTile(
                    caption: 'Created by:',
                    subtitle: task.createdBy.displayName),
                const SizedBox(height: 20),
                InfoTile(
                    caption: 'Creation date:',
                    subtitle: formatedDate(
                        now: DateTime.now(), stringDate: task.created)),
                const SizedBox(height: 110)
              ],
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class InfoTile extends StatelessWidget {
  final Widget icon;
  final String caption;
  final String subtitle;
  final TextStyle captionStyle;
  final TextStyle subtitleStyle;

  const InfoTile({
    Key key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 56, child: icon),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caption, style: captionStyle ?? TextStyleHelper.caption()),
                Text(subtitle,
                    style: subtitleStyle ?? TextStyleHelper.subtitle1())
              ],
            ),
          )
        ],
      ),
    );
  }
}
