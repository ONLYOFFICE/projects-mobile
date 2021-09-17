import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class MessagesHandler {
  static String _lastMessage;

  static var isDisplayed = ValueNotifier<bool>(Get.isSnackbarOpen);

  static final Queue _a = Queue();

  static void showSnackBar({
    @required BuildContext context,
    @required String text,
    bool showOkButton = false,
    String buttonText,
    Function buttonOnTap,
  }) async {
    isDisplayed.value = true;

    if (text == _lastMessage) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    _a.addLast(text);

    await ScaffoldMessenger.of(context)
        .showSnackBar(
          _styledSnackBar(
            context: context,
            text: text,
            showOkButton: showOkButton,
            buttonText: buttonText,
            buttonOnTap: buttonOnTap,
          ),
        )
        .closed
        .then((_) {
      _a.removeFirst();
      if (_a.isEmpty) isDisplayed.value = false;
    });
    _lastMessage = text;
  }
}

SnackBar _styledSnackBar({
  @required BuildContext context,
  @required String text,
  bool showOkButton = false,
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
        if (showOkButton)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldMessenger.maybeOf(context).removeCurrentSnackBar(),
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
