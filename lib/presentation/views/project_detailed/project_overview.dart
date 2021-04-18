import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectCellController controller;

  const ProjectOverview({Key key, @required this.controller})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    //  return Obx(
    //   () {
    //     if (controller.loaded.isTrue) {
    var _text =
        'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m';
    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: () => {},
      child: ListView(
        children: [
          // Task(
          //   taskController: controller,
          // ),
          InfoTile(
            icon: AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
            caption: 'Project manager:',
            subtitle: 'Sergey Petrov',
            subtitleStyle: TextStyleHelper.subtitle1(
                color: Theme.of(context).customColors().onSurface),
          ),
          const SizedBox(height: 20),
          InfoTile(
            icon: AppIcon(icon: SvgIcons.users, color: const Color(0xff707070)),
            caption: 'Team:',
            subtitle: '2 members',
            subtitleStyle: TextStyleHelper.subtitle1(
                color: Theme.of(context).customColors().onSurface),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 56, right: 32, top: 42, bottom: 42),
            child: ReadMoreText(
              _text,
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
          const SizedBox(height: 20),
          InfoTile(
              icon:
                  AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
              caption: 'Creation date:',
              subtitle: '21 Mar 2021'),
          const SizedBox(height: 20),

          InfoTile(
              icon:
                  AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
              caption: 'Tags',
              subtitle: 'app, new task, app, new task'),
        ],
      ),
    );
    //   } else {
    //     return const Material(
    //       child: Center(child: Text('LOADING')),
    //     );
    //   }
    // },
    // );
  }
}
