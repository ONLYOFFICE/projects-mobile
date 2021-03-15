import 'package:flutter/material.dart';

import 'package:only_office_mobile/data/models/project_detailed.dart';
import 'package:only_office_mobile/presentation/shared/svg_manager.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';

class ProjectItem extends StatelessWidget {
  final ProjectDetailed project;
  const ProjectItem({this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProjectIcon(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProjectTitle(project: project),
                      const SizedBox(width: 16),
                      ProjectSubtitle(project: project),
                      const SizedBox(width: 16),
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

class ProjectIcon extends StatelessWidget {
  const ProjectIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          SVG.createSized('lib/assets/images/icons/project_icon.svg', 40, 40),
          Positioned(
            bottom: 0,
            right: 0,
            child: SVG.createSized(
                'lib/assets/images/icons/project_attribute.svg', 16, 16),
            // IconButton(
            //   onPressed: () {},
            //   icon: SVG.createSized(
            //       'lib/assets/images/icons/project_attribute.svg', 16, 16),
            // ),
          ),
        ],
      ),
    );
  }
}

class ProjectTitle extends StatelessWidget {
  const ProjectTitle({
    Key key,
    @required this.project,
  }) : super(key: key);

  final ProjectDetailed project;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              project.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.projectTitle,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/project_statuses/pause.svg', 16, 16),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '•',
                  style: TextStyleHelper.projectResponsible,
                ),
              ),
              Text(
                project.responsible.displayName,
                style: TextStyleHelper.projectResponsible,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectSubtitle extends StatelessWidget {
  const ProjectSubtitle({
    Key key,
    @required this.project,
  }) : super(key: key);

  final ProjectDetailed project;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            project.createdDate(),
            style: TextStyleHelper.projectDate,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/check_round.svg', 20, 20),
              Text(
                project.taskCount.toString(),
                style: TextStyleHelper.projectCompleatetTasks,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
