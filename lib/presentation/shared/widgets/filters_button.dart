import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({
    Key key,
    this.controler,
  }) : super(key: key);
  final controler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => AppIcon(
          width: 24,
          height: 24,
          icon: controler.filterController.hasFilters == false
              ? SvgIcons.preferences
              : Get.theme.brightness == Brightness.dark
                  ? SvgIcons.preferences_active_dark_theme
                  : SvgIcons.preferences_active,
          color: controler.filterController.hasFilters == false
              ? Get.theme.colors().primary
              : null,
        ),
      ),
    );
  }
}
