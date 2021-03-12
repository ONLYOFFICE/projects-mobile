import 'package:flutter/material.dart';

import 'package:only_office_mobile/data/models/project_detailed.dart';
import 'package:only_office_mobile/presentation/shared/svg_manager.dart';

class ProjectItem extends StatelessWidget {
  final ProjectDetailed project;
  const ProjectItem({this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            padding: const EdgeInsets.all(16),
            child: SVG.createSized('resources/icons/project_icon.svg', 40, 40),
          ),
          Expanded(
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(project.responsible.displayName),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(project.createdDate()),
                const SizedBox(height: 8),
                Text(project.taskCount.toString()),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
