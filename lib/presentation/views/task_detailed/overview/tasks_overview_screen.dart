import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/status_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

part 'task.dart';

class TasksOverviewScreen extends StatelessWidget {
  final TaskItemController taskController;

  const TasksOverviewScreen({Key key, @required this.taskController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (taskController.loaded.isTrue || taskController.firstReload.isTrue) {
          taskController.firstReload.value = false;
          var task = taskController.task.value;
          return SmartRefresher(
            controller: taskController.refreshController,
            onRefresh: () => taskController.reloadTask(showLoading: true),
            child: ListView(
              children: [
                _Task(taskController: taskController),
                if (task.description != null && task.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 21),
                    child: InfoTile(
                      caption: '${tr('description')}:',
                      icon: AppIcon(
                          icon: SvgIcons.description,
                          color: const Color(0xff707070)),
                      subtitleWidget: ReadMoreText(
                        task.description,
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
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project, color: const Color(0xff707070)),
                  caption: '${tr('project')}:',
                  subtitle: task.projectOwner.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().links),
                ),
                if (task.milestone != null) const SizedBox(height: 20),
                if (task.milestone != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.milestone,
                          color: const Color(0xff707070)),
                      caption: '${tr('milestone')}:',
                      subtitle: task.milestone.title,
                      subtitleStyle: TextStyleHelper.subtitle1(
                          color: Theme.of(context).customColors().links)),
                if (task.startDate != null) const SizedBox(height: 20),
                if (task.startDate != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: '${tr('startDate')}:',
                      subtitle: task.startDate),
                if (task.deadline != null) const SizedBox(height: 20),
                if (task.deadline != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.due_date,
                          color: const Color(0xff707070)),
                      caption: '${tr('dueDate')}:',
                      subtitle: formatedDateFromString(
                          now: DateTime.now(), stringDate: task.deadline)),
                const SizedBox(height: 20),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.priority,
                        color: const Color(0xff707070)),
                    caption: '${tr('priority')}:',
                    subtitle: task.priority == 1 ? tr('high') : tr('normal')),
                if (task.responsibles != null && task.responsibles.isNotEmpty)
                  const SizedBox(height: 20),
                if (task.responsibles != null && task.responsibles.isNotEmpty)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.person,
                          color: const Color(0xff707070)),
                      caption: '${tr('assignedTo')}:',
                      subtitle: task.responsibles.length >= 2
                          ? plural('responsibles', task.responsibles.length)
                          : task.responsibles[0].displayName,
                      suffix: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6)),
                          onPressed: () {})),
                const SizedBox(height: 20),
                InfoTile(
                    caption: '${tr('createdBy')}:',
                    subtitle: task.createdBy.displayName),
                const SizedBox(height: 20),
                InfoTile(
                    caption: '${tr('creationDate')}:',
                    subtitle: formatedDateFromString(
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
