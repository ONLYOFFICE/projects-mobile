import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

SnackBar styledSnackBar({
  @required BuildContext context,
  @required String text,
  String buttonText,
  Function() buttonOnTap,
}) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(text,
                style: TextStyleHelper.body2(color: lightColors.surface))),
        if (buttonText != null && buttonText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: buttonOnTap,
              child: SizedBox(
                height: 16,
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyleHelper.button(
                            color: Get.theme.colors().primary.withOpacity(0.5))
                        .copyWith(height: 1),
                  ),
                ),
              ),
            ),
          ),
        if (buttonText == null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar(),
              child: SizedBox(
                height: 16,
                width: 65,
                child: Center(
                  child: Text(tr('ok'),
                      style: TextStyleHelper.button(
                              color:
                                  Get.theme.colors().primary.withOpacity(0.5))
                          .copyWith(height: 1)),
                ),
              ),
            ),
          ),
      ],
    ),
    backgroundColor: Get.theme.colors().snackBarColor,
    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 10),
    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 9),
    behavior: SnackBarBehavior.floating,
  );
}
