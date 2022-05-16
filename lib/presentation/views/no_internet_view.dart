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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/internal/utils/debug_print.dart';
import 'package:projects/main_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = Theme.of(context).brightness == Brightness.light
        ? SvgIcons.no_internet
        : SvgIcons.no_internet.replaceFirst('.', '_dark.');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 144,
                  width: 144,
                  child: Builder(
                    builder: (_) {
                      try {
                        return AppIcon(icon: icon);
                      } catch (e) {
                        printError(e);
                        return AppIcon(icon: icon);
                      }
                    },
                  ),
                ),
                Text(
                  tr('noInternetConnectionTitle'),
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  tr('noInternetConnectionSubtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.subtitle1(
                      color: Theme.of(context).colors().onSurface.withOpacity(0.75)),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: SizedBox(
                    width: 280,
                    height: 48,
                    child: PlatformTextButton(
                      onPressed: () async {
                        if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
                          if (Get.find<MainController>().isSessionStarted)
                            Get.back();
                          else {} // TODO refactor UserController
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                      material: (context, platform) => MaterialTextButtonData(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (_) => Theme.of(context).colors().primary),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      cupertino: (context, platform) => CupertinoTextButtonData(
                          color: Theme.of(context).colors().primary,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(tr('tryAgain'),
                          textAlign: TextAlign.center,
                          style:
                              TextStyleHelper.button(color: Theme.of(context).colors().onPrimary)),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
