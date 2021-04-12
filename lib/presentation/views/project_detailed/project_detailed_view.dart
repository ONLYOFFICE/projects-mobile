import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
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
        appBar: CustomAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          bottom: SizedBox(
            height: 25,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).customColors().onSurface,
                  labelColor: Theme.of(context).customColors().onSurface,
                  unselectedLabelColor: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                  labelStyle: TextStyleHelper.subtitle2,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Tasks'),
                    Tab(text: 'Milestones'),
                    Tab(text: 'Discussions'),
                    Tab(text: 'Documents'),
                    Tab(text: 'Team'),
                  ]),
            ),
          ),
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
