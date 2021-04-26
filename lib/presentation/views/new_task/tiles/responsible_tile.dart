import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class ResponsibleTile extends StatelessWidget {
  final controller;
  const ResponsibleTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.responsibles.isNotEmpty;
        return NewTaskInfo(
          isSelected: _isSelected,
          caption: _isSelected ? 'Assigned to:' : null,
          text: _isSelected
              ? '${controller.responsibles.length} responsibles'
              : 'Add responsible',
          suffix: _isSelected
              ? Icon(Icons.arrow_forward_ios_outlined,
                  size: 20,
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6))
              : null,
          icon: SvgIcons.person,
          onTap: () => Get.toNamed('SelectResponsiblesView'),
        );
      },
    );
  }
}
