import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PriorityTile extends StatelessWidget {
  final controller;
  const PriorityTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Text('High priority',
                style: TextStyleHelper.subtitle1(
                    color: Theme.of(context).customColors().onSurface)),
          ),
          Switch(
            value: controller.highPriority.value,
            onChanged: (value) => controller.changePriority(value),
          )
        ],
      ),
    );
  }
}
