import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';

class ProjectDetailedView extends StatelessWidget {
  const ProjectDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectCellController controller = Get.arguments['controller'];

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: StyledAppBar(
          actions: [
            IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            IconButton(icon: Icon(Icons.check_rounded), onPressed: () {})
          ],
          bottom: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).customColors().onSurface,
              labelColor: Theme.of(context).customColors().onSurface,
              unselectedLabelColor:
                  Theme.of(context).customColors().onSurface.withOpacity(0.6),
              labelStyle: TextStyleHelper.subtitle2(),
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Tasks'),
                Tab(text: 'Milestones'),
                Tab(text: 'Discussions'),
                Tab(text: 'Documents'),
                Tab(text: 'Team'),
              ]),
        ),
        body: TabBarView(
          children: [
            ProjectOverview(controller: controller),
            for (var i = 0; i < 5; i++)
              ProjectOverview(
                controller: controller,
              )
          ],
        ),
      ),
    );
  }
}
