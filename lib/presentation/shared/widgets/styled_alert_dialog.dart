import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StyledAlertDialog extends StatelessWidget {
  final Widget title;
  final String titleText;
  final Widget content;
  final String contentText;
  final String cancelText;
  final String acceptText;
  final Color acceptColor;
  final Function() onCancelTap;
  final Function() onAcceptTap;
  const StyledAlertDialog({
    Key key,
    this.cancelText,
    this.acceptColor,
    this.acceptText,
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
      contentPadding: contentText != null || content != null
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 24),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: title ?? Text(titleText),
      // ignore: prefer_if_null_operators
      content: content != null
          ? content
          : contentText != null
              ? Text(contentText)
              : null,
      actions: [
        TextButton(
          onPressed: onCancelTap ?? Get.back,
          child:
              Text(cancelText ?? tr('cancel'), style: TextStyleHelper.button()),
        ),
        TextButton(
          onPressed: onAcceptTap,
          child: Text(
            acceptText ?? tr('accept'),
            style: TextStyleHelper.button(
                color: acceptColor ?? Theme.of(context).customColors().error),
          ),
        ),
      ],
    );
  }
}

class SingleButtonDialog extends StatelessWidget {
  final Widget title;
  final String titleText;
  final Widget content;
  final String contentText;

  final String acceptText;
  final Color acceptColor;

  final Function() onAcceptTap;
  const SingleButtonDialog({
    Key key,
    this.acceptColor,
    this.acceptText,
    this.title,
    this.content,
    this.titleText,
    this.contentText,
    this.onAcceptTap,
  })  : assert(titleText != null || title != null,
            content != null || contentText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
      contentPadding: contentText != null || content != null
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 24),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: title ?? Text(titleText),
      // ignore: prefer_if_null_operators
      content: content != null
          ? content
          : contentText != null
              ? Text(contentText)
              : null,
      actions: [
        TextButton(
          onPressed: onAcceptTap,
          child: Text(
            acceptText ?? tr('accept'),
            style: TextStyleHelper.button(
                color: acceptColor ?? Theme.of(context).customColors().error),
          ),
        ),
      ],
    );
  }
}
