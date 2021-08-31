import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_team_datasource.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamView extends StatelessWidget {
  final ProjectDetailed projectDetailed;

  const ProjectTeamView({
    Key key,
    @required this.projectDetailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectTeamDataSource = Get.find<ProjectTeamDataSource>();
    projectTeamDataSource.projectDetailed = projectDetailed;
    projectTeamDataSource.getTeam();
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
