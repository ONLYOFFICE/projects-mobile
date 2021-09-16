import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';

class ProjectTeamView extends StatelessWidget {
  final ProjectDetailed projectDetailed;

  final fabAction;

  const ProjectTeamView({
    Key key,
    @required this.projectDetailed,
    @required this.fabAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectTeamDataSource = Get.find<ProjectTeamController>();
    projectTeamDataSource.projectId = projectDetailed.id;
    projectTeamDataSource.getTeam();
    return Stack(
      children: [
        _Content(projectTeamDataSource: projectTeamDataSource),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            child: StyledFloatingActionButton(
              onPressed: fabAction,
              child: AppIcon(
                icon: SvgIcons.fab_user,
                color: Get.theme.colors().onPrimarySurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key key,
    @required this.projectTeamDataSource,
  }) : super(key: key);

  final ProjectTeamController projectTeamDataSource;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (projectTeamDataSource.loaded.value == true) {
        return SmartRefresher(
            enablePullDown: false,
            enablePullUp: projectTeamDataSource.pullUpEnabled,
            controller: projectTeamDataSource.refreshController,
            onLoading: projectTeamDataSource.onLoading,
            child: ListView(
              children: <Widget>[
                Column(
                  children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController: projectTeamDataSource.usersList[i],
                          onTapFunction: () => {}),
                      itemExtent: 65.0,
                      itemCount: projectTeamDataSource.usersList.length,
                    )
                  ],
                ),
              ],
            ));
      }
      return const ListLoadingSkeleton();
    });
  }
}
