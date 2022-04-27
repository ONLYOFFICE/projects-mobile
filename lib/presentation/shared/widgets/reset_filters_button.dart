import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class ResetFiltersButton extends StatelessWidget {
  const ResetFiltersButton({Key? key, required this.filterController}) : super(key: key);

  final BaseFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (filterController.hasFilters.value)
        return PlatformWidget(
          material: (platformContext, __) => TextButton(
            onPressed: filterController.resetFilters,
            child: Text(
              tr('reset'),
              style: TextStyleHelper.button(color: Get.theme.colors().systemBlue),
            ),
          ),
          cupertino: (platformContext, __) => CupertinoButton(
            onPressed: filterController.resetFilters,
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              tr('reset').toLowerCase().capitalizeFirst!,
              style: TextStyleHelper.button(),
            ),
          ),
        );
      else
        return const SizedBox();
    });
  }
}
