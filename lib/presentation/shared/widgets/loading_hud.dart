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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class LoadingWithoutProgress {
  /// [loadingText] is tr('loading') by default
  /// showLoading(true) - show dialog window
  /// showLoading(false) - close dialog window
  /// we can do: loaded.listen((value) => loadingHud.showLoading(!value));

  LoadingWithoutProgress({this.loadingText});

  String? loadingText;

  PopupRoute? _loadingHudRoute;

  void showLoading(bool value) {
    if (value) {
      if (GetPlatform.isIOS)
        _loadingHudRoute = CupertinoDialogRoute(
          builder: (_) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: CupertinoPopupSurface(
                isSurfacePainted: false,
                child: _LoadingContent(text: loadingText ?? tr('loading')),
              ),
            ),
          ),
          settings: const RouteSettings(name: _LoadingContent.name),
          context: Get.context!,
        );
      else
        _loadingHudRoute = DialogRoute(
          builder: (_) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: Center(
              child: Material(
                type: MaterialType.card,
                child: _LoadingContent(text: loadingText ?? tr('loading')),
              ),
            ),
          ),
          settings: const RouteSettings(name: _LoadingContent.name),
          context: Get.context!,
        );
      Navigator.push(Get.context!, _loadingHudRoute!);
      return;
    }
    if (!value && _loadingHudRoute?.isActive == true) {
      Navigator.removeRoute(Get.context!, _loadingHudRoute!);
      _loadingHudRoute = null;
    }
  }
}

class _LoadingContent extends StatelessWidget {
  _LoadingContent({Key? key, required this.text}) : super(key: key);

  final String text;

  static const name = '/Loading';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformCircularProgressIndicator(
            cupertino: (_, __) => CupertinoProgressIndicatorData(radius: 20),
          ),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: TextStyleHelper.caption(color: Theme.of(context).colors().onSurface),
            child: Text(text.capitalizeFirst!),
          ),
        ],
      ),
    );
  }
}

class LoadingWithProgress {
  /// [title] is tr('loading') by default
  /// showLoading(true) - show dialog window
  /// showLoading(false) - close dialog window

  LoadingWithProgress({
    this.title,
    required this.progress,
    this.onCancelTap,
  });

  final String? title;
  final Rx<double> progress;
  final void Function()? onCancelTap;

  PopupRoute? _loadingRoute;

  void showLoading(bool value) {
    if (value && _loadingRoute == null) {
      if (GetPlatform.isIOS)
        _loadingRoute = CupertinoDialogRoute(
          builder: (_) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: _LoadingWithProgressContent(
              title: title ?? tr('loading'),
              progress: progress,
              onCancelTap: onCancelTap,
            ),
          ),
          settings: const RouteSettings(name: _LoadingWithProgressContent.name),
          context: Get.context!,
        );
      else
        _loadingRoute = DialogRoute(
          builder: (_) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: _LoadingWithProgressContent(
              title: title ?? tr('loading'),
              progress: progress,
              onCancelTap: onCancelTap,
            ),
          ),
          settings: const RouteSettings(name: _LoadingWithProgressContent.name),
          context: Get.context!,
        );
      Navigator.push(Get.context!, _loadingRoute!);
      return;
    }
    if (!value && _loadingRoute?.isActive == true) {
      Navigator.removeRoute(Get.context!, _loadingRoute!);
      _loadingRoute = null;
    }
  }
}

class _LoadingWithProgressContent extends StatelessWidget {
  _LoadingWithProgressContent({
    Key? key,
    required this.title,
    required this.progress,
    this.onCancelTap,
  }) : super(key: key);

  static const name = '/LoadingWithProgress';

  final String title;
  final Rx<double> progress;
  final void Function()? onCancelTap;

  @override
  Widget build(BuildContext context) {
    return SingleButtonDialog(
      titleText: title,
      acceptText: onCancelTap != null ? tr('cancel') : tr('close').capitalizeFirst,
      onAcceptTap: onCancelTap,
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => LinearProgressIndicator(
                value: progress.value,
                color: Get.theme.colors().primary,
                backgroundColor: Get.theme.colors().backgroundSecond,
              ),
            ),
            if (Platform.isAndroid)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 0),
                child: Row(
                  children: [
                    const Spacer(),
                    Obx(
                      () => Text(
                        '${(progress.value * 100).toStringAsFixed(0)} %',
                        style: TextStyleHelper.body2(color: Get.theme.colors().onSurface),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
