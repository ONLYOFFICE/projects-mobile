import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

Future showStyledDateRangePicker({
  @required BuildContext context,
  @required DateTimeRange initialDateRange,
  DateTime firstDate,
  DateTime lastDate,
  String helpText,
  String cancelText,
  String confirmText,
  String saveText,
  String errorFormatText,
  String errorInvalidText,
  String errorInvalidRangeText,
  String fieldStartHintText,
  String fieldEndLabelText,
}) async {
  var dateRange = await showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate ?? DateTime(1970),
    lastDate: lastDate ?? DateTime(2100),
    helpText: helpText ?? tr('selectDateRange'),
    cancelText: cancelText ?? tr('cancel'),
    confirmText: confirmText ?? tr('ok'),
    saveText: saveText ?? tr('save'),
    errorFormatText: errorFormatText ?? tr('invalidFormat'),
    errorInvalidText: errorInvalidText ?? tr('outOfRange'),
    errorInvalidRangeText: errorInvalidRangeText ?? tr('invalidRange'),
    fieldStartHintText: fieldStartHintText ?? tr('startDate'),
    fieldEndLabelText: fieldEndLabelText ?? tr('endDate'),
    builder: (_, child) {
      return Theme(
        data: ThemeData(
          colorScheme: Get.isDarkMode ?? Get.isPlatformDarkMode
              ? ColorScheme.dark(
                  onSurface: darkColors.onSurface,
                  onPrimary: darkColors.onBackground,
                  primary: darkColors.primary,
                  surface: darkColors.systemBlue,
                )
              : ColorScheme.light(
                  onPrimary: lightColors.onBackground,
                  primary: darkColors.primary.withOpacity(0.3),
                  surface: darkColors.systemBlue,
                  onSurface: darkColors.surface,
                ),
          primaryColor: Theme.of(context).colors().surface,
        ),
        child: child,
      );
    },
  );
  return dateRange;
}
