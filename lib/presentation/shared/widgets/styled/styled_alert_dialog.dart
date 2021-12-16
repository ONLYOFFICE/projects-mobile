/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StyledAlertDialog extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? content;
  final String? contentText;
  final String? cancelText;
  final String? acceptText;
  final Color? acceptColor;
  final Function()? onCancelTap;
  final Function()? onAcceptTap;
  const StyledAlertDialog({
    Key? key,
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
  })  : assert(titleText != null || title != null, content != null || contentText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
      contentPadding: contentText != null || content != null
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 24),
      insetPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: title ?? Text(titleText!),
      content: content ?? (contentText != null ? Text(contentText!) : null),
      actions: [
        TextButton(
          onPressed: onCancelTap ?? Get.back,
          child: Text(cancelText ?? tr('cancel'), style: TextStyleHelper.button()),
        ),
        TextButton(
          onPressed: onAcceptTap,
          child: Text(
            acceptText ?? tr('accept'),
            style: TextStyleHelper.button(color: acceptColor ?? Get.theme.colors().colorError),
          ),
        ),
      ],
    );
  }
}

class SingleButtonDialog extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? content;
  final String? contentText;

  final String? acceptText;
  final Color? acceptColor;

  final Function()? onAcceptTap;
  const SingleButtonDialog({
    Key? key,
    this.acceptColor,
    this.acceptText,
    this.title,
    this.content,
    this.titleText,
    this.contentText,
    this.onAcceptTap,
  })  : assert(titleText != null || title != null, content != null || contentText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
      contentPadding: contentText != null || content != null
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 24),
      insetPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: title ?? Text(titleText!),
      // ignore: prefer_if_null_operators
      content: content != null
          ? content
          : contentText != null
              ? Text(contentText!)
              : null,
      actions: [
        TextButton(
          onPressed: onAcceptTap,
          child: Text(
            acceptText ?? tr('accept'),
            style: TextStyleHelper.button(color: acceptColor ?? Get.theme.colors().colorError),
          ),
        ),
      ],
    );
  }
}
