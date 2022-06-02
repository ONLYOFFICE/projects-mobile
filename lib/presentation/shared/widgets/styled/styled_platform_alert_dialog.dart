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

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_cupertino_alert_dialog.dart';

const EdgeInsets _defaultInsetPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 24);

class StyledPlatformAlertDialog
    extends PlatformWidgetBase<StyledCupertinoAlertDialog, AlertDialog> {
  final Key? widgetKey;
  final List<Widget>? actions;
  final Widget? content;
  final Widget? title;

  final PlatformBuilder<MaterialAlertDialogData>? material;
  final PlatformBuilder<CupertinoAlertDialogData>? cupertino;

  StyledPlatformAlertDialog({
    Key? key,
    this.widgetKey,
    this.actions,
    this.content,
    this.title,
    this.material,
    this.cupertino,
  }) : super(
          key: key,
        );

  @override
  StyledCupertinoAlertDialog createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    final curve = data?.insetAnimationCurve;

    return StyledCupertinoAlertDialog(
      key: data?.widgetKey ?? widgetKey,
      actions: data?.actions ?? actions ?? const <Widget>[],
      content: data?.content ?? content,
      scrollController: data?.scrollController,
      actionScrollController: data?.actionScrollController,
      title: data?.title ?? title,
      insetAnimationCurve: curve ?? Curves.decelerate,
      insetAnimationDuration: data?.insetAnimationDuration ?? const Duration(milliseconds: 100),
    );
  }

  @override
  AlertDialog createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    return AlertDialog(
      key: data?.widgetKey ?? widgetKey,
      actions: data?.actions ?? actions,
      content: data?.content ?? content,
      contentPadding: data?.contentPadding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
      semanticLabel: data?.semanticLabel,
      title: data?.title ?? title,
      titlePadding: data?.titlePadding,
      contentTextStyle: data?.contentTextStyle,
      backgroundColor: data?.backgroundColor,
      elevation: data?.elevation,
      shape: data?.shape,
      titleTextStyle: data?.titleTextStyle,
      scrollable: data?.scrollable ?? false,
      actionsOverflowDirection: data?.actionsOverflowDirection,
      actionsPadding: data?.actionsPadding ?? EdgeInsets.zero,
      buttonPadding: data?.buttonPadding,
      actionsOverflowButtonSpacing: data?.actionsOverflowButtonSpacing,
      clipBehavior: data?.clipBehavior ?? Clip.none,
      insetPadding: data?.insetPadding ?? _defaultInsetPadding,
      actionsAlignment: data?.actionsAlignment,
      alignment: data?.alignment,
    );
  }
}
