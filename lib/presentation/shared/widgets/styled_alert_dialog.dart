import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

// TODO: Alert dialog. Давай использовать общий. Удали, как увидишь, пожалуйста.
class StyledAlertDialog extends StatelessWidget {
  final Widget title;
  final String titleText;
  final Widget content;
  final String contentText;
  final String cancelText;
  final String acceptText;
  final Function() onCancelTap;
  final Function() onAcceptTap;
  const StyledAlertDialog({
    Key key,
    this.cancelText = 'CANCEL',
    this.acceptText = 'ACCEPT',
    this.title,
    this.content,
    this.titleText,
    this.contentText,
    this.onAcceptTap,
    // Default: pop window
    this.onCancelTap,
  })  : assert(titleText != null || title != null,
            content != null || contentText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: title ?? Text(titleText),
      content: content ?? Text(contentText),
      actions: [
        TextButton(
          onPressed: onCancelTap ?? () => Get.back(),
          child: Text(cancelText, style: TextStyleHelper.button()),
        ),
        TextButton(
          onPressed: onAcceptTap,
          child: Text(acceptText,
              style: TextStyleHelper.button(
                  color: Theme.of(context).customColors().error)),
        ),
      ],
    );
  }
}
