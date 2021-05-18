import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

// TODO shared snackBar
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
        Flexible(child: Text(text)),
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
                            color: Theme.of(context)
                                .customColors()
                                .primary
                                .withOpacity(0.5))
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
                  child: Text('OK',
                      style: TextStyleHelper.button(
                              color: Theme.of(context)
                                  .customColors()
                                  .primary
                                  .withOpacity(0.5))
                          .copyWith(height: 1)),
                ),
              ),
            ),
          ),
      ],
    ),
    backgroundColor: Theme.of(context).customColors().snackBarColor,
    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 10),
    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 9),
    behavior: SnackBarBehavior.floating,
  );
}
