import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsController());

    return WillPopScope(
      onWillPop: () async {
        controller.leave();
        return true;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: tr('settings'),
          onLeadingPressed: controller.leave,
        ),
        body: Obx(
          () {
            if (controller.loaded.isTrue) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SettingTile(
                      text: tr('passcodeLock'),
                      loverText: controller.isPasscodeEnable == true
                          ? tr('enabled')
                          : tr('disabled'),
                      icon: SvgIcons.passcode,
                      // onTap: () => Get.toNamed('NewPasscodeScreen1'),
                      onTap: () => Get.toNamed('PasscodeSettingsScreen'),
                    ),
                    SettingTile(
                      text: tr('colorTheme'),
                      loverText: tr(controller.currentTheme.value),
                      icon: SvgIcons.color_scheme,
                      onTap: () => Get.toNamed('ColorThemeSelectionScreen'),
                    ),
                    SettingTile(
                      text: tr('clearCache'),
                      icon: SvgIcons.clean,
                    ),
                    const SizedBox(height: 70),
                    SettingTile(
                      text: tr('support'),
                      icon: SvgIcons.support,
                    ),
                    SettingTile(
                      text: tr('feedback'),
                      icon: SvgIcons.feedback,
                    ),
                    SettingTile(
                      text: tr('aboutApp'),
                      icon: SvgIcons.about_app,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String loverText;
  final String icon;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const SettingTile({
    Key key,
    this.enableBorder = true,
    this.icon,
    this.loverText,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      // constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: icon != null
                      ? AppIcon(
                          icon: icon,
                          color: Get.theme.colors().onSurface.withOpacity(0.6))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            loverText != null && loverText.isNotEmpty ? 8 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor != null
                                        ? textColor
                                        : Get.theme.colors().onBackground)),
                        if (loverText != null && loverText.isNotEmpty)
                          Text(loverText,
                              style: TextStyleHelper.body2(
                                  color: Get.theme
                                      .colors()
                                      .onBackground
                                      .withOpacity(0.75))),
                      ],
                    ),
                  ),
                ),
                if (suffix != null)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(padding: suffixPadding, child: suffix)),
              ],
            ),
            if (enableBorder) const StyledDivider(leftPadding: 56.5),
          ],
        ),
      ),
    );
  }
}
