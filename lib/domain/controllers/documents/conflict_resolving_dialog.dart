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

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/files_api.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/wrappers/platform_dialog_action.dart';

Future<ConflictResolveType?> showConflictResolvingDialog(List<String> titles) async {
  if (GetPlatform.isIOS) return await _showForIOS(titles);

  return await _showForAndroid(titles);
}

Future<ConflictResolveType?> _showForIOS(List<String> titles) async {
  return await Get.dialog(StyledAlertDialog(
    titleText: tr('overwriteDialogTitle'),
    content: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyleHelper.body2(color: Get.theme.colors().onSurface),
        children: [
          TextSpan(text: tr('overwriteDialogContent.beforeText')),
          TextSpan(
              text: '"${titles.join(', ')}"',
              style: TextStyleHelper.body2(color: Get.theme.colors().onSurface)
                  .copyWith(fontWeight: FontWeight.w700)),
          TextSpan(text: tr('overwriteDialogContent.afterText')),
        ],
      ),
    ),
    actions: [
      PlatformDialogAction(
        onPressed: () {
          Get.back(result: ConflictResolveType.Overwrite);
        },
        child: Text(
          tr('overwriteConfirmation'),
          textAlign: TextAlign.center,
        ),
      ),
      PlatformDialogAction(
        onPressed: () {
          Get.back(result: ConflictResolveType.Duplicate);
        },
        child: Text(
          tr('duplicateConfirmation'),
          softWrap: false,
          textAlign: TextAlign.center,
        ),
      ),
      PlatformDialogAction(
        onPressed: () {
          Get.back(result: ConflictResolveType.Skip);
        },
        child: Text(
          tr('skipConfirmation'),
          softWrap: false,
          textAlign: TextAlign.center,
        ),
      ),
      PlatformDialogAction(
        onPressed: Get.back,
        child: Text(
          tr('cancel').toLowerCase().capitalizeFirst!,
          softWrap: false,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ));
}

Future<ConflictResolveType?> _showForAndroid(List<String> titles) async {
  ConflictResolveType? type;

  return await Get.dialog(StyledAlertDialog(
    titleText: tr('overwriteDialogTitle'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyleHelper.body2(color: Get.theme.colors().onSurface),
            children: [
              TextSpan(text: tr('overwriteDialogContent.beforeText')),
              TextSpan(
                  text: '"${titles.join(', ')}"',
                  style: TextStyleHelper.body2(color: Get.theme.colors().onSurface)
                      .copyWith(fontWeight: FontWeight.w700)),
              TextSpan(text: tr('overwriteDialogContent.afterText')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _DialogContent(
          onChanged: (value) {
            type = value;
          },
        ),
      ],
    ),
    cancelText: tr('cancel'),
    acceptText: tr('confirm'),
    onCancelTap: () {
      Get.back();
    },
    onAcceptTap: () {
      Get.back(result: type ?? ConflictResolveType.Overwrite);
    },
  ));
}

class _DialogContent extends StatefulWidget {
  const _DialogContent({Key? key, required this.onChanged}) : super(key: key);

  final void Function(ConflictResolveType? value) onChanged;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  ConflictResolveType? _character = ConflictResolveType.Overwrite;

  void _onChanged(ConflictResolveType? value) {
    setState(() {
      _character = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          onTap: () {
            _onChanged(ConflictResolveType.Overwrite);
          },
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          title: Text(
            tr('overwriteConfirmation'),
            style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
          ),
          leading: Radio<ConflictResolveType>(
              value: ConflictResolveType.Overwrite, groupValue: _character, onChanged: _onChanged),
        ),
        ListTile(
          onTap: () {
            _onChanged(ConflictResolveType.Duplicate);
          },
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          title: Text(
            tr('duplicateConfirmation'),
            style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
          ),
          leading: Radio<ConflictResolveType>(
              value: ConflictResolveType.Duplicate, groupValue: _character, onChanged: _onChanged),
        ),
        ListTile(
          onTap: () {
            _onChanged(ConflictResolveType.Skip);
          },
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          title: Text(
            tr('skipConfirmation'),
            style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
          ),
          leading: Radio<ConflictResolveType>(
              value: ConflictResolveType.Skip, groupValue: _character, onChanged: _onChanged),
        ),
      ],
    );
  }
}
