import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/internal/utils/debug_print.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icon = Get.theme.brightness == Brightness.light
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
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  tr('noInternetConnectionSubtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.subtitle1(
                      color: Get.theme.colors().onSurface.withOpacity(0.75)),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: SizedBox(
                    width: 280,
                    height: 48,
                    child: TextButton(
                      onPressed: () async {
                        await Connectivity().checkConnectivity();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith<
                                EdgeInsetsGeometry>(
                            (_) => const EdgeInsets.fromLTRB(10, 10, 10, 12)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (_) => Get.theme.colors().primary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                      child: Text(tr('tryAgain'),
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.button(
                              color: Get.theme.colors().onPrimary)),
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
