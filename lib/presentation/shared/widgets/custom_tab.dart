import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final int count;
  final bool currentTab;
  const CustomTab({
    Key key,
    this.title,
    this.count,
    this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(title),
          if (count != null && count >= 0) const SizedBox(width: 8),
          if (count != null && count >= 0)
            Container(
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.colors().onSurface.withOpacity(0.3),
                // TODO change active tabs color
                // color: currentTab
                //     ? Get.theme.customColors().primary
                //     : Get.theme
                //         .customColors()
                //         .onSurface
                //         .withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Get.theme.colors().surface,
                      letterSpacing: 0.1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
