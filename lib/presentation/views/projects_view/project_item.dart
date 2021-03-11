import 'package:flutter/material.dart';

import 'package:only_office_mobile/data/models/project.dart';
import 'package:only_office_mobile/presentation/shared/svg_manager.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  const ProjectItem({this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SVG.create('resources/icons/project_icon.svg'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              Text(project.title),
              const SizedBox(height: 8),
              Text(project.responsible.displayName),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
      // Center(child: Text(project.title))
    );
  }
}
