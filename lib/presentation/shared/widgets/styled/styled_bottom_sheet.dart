import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class StyledButtomSheet extends StatelessWidget {
  final double height;
  final Widget title;
  final List<Widget> actions;
  final Widget content;
  const StyledButtomSheet({
    Key key,
    this.height,
    this.title,
    this.actions,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Get.theme.colors().onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null) title,
              if (actions != null) Row(children: actions),
            ],
          ),
          if (content != null) Expanded(child: content)
        ],
      ),
    );
  }
}
