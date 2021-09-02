import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_keyboard_items.dart';

mixin PasscodeScreenMixin on StatelessWidget {
  void onBackPressed();
  void onNumberPressed(int number);
  void onDeletePressed();

  RxInt get enteredCodeLen;
  RxBool get hasError => false.obs;

  final bool hasBackButton = true;

  final String title = tr('enterPasscode');
  final String caption = null;
  final String errorText = null;

  final Widget keyboardLastRow = null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasBackButton) onBackPressed();
        return hasBackButton;
      },
      child: Scaffold(
        appBar: hasBackButton
            ? StyledAppBar(elevation: 0, onLeadingPressed: onBackPressed)
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: hasBackButton ? h(114) : h(170)),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground)),
              SizedBox(
                  height: h(72),
                  child: Obx(() {
                    return Column(children: [
                      const Flexible(flex: 1, child: SizedBox(height: 16)),
                      if (hasError.isTrue)
                        Text(errorText,
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme.colors().colorError)),
                      if (hasError.isFalse && caption != null)
                        Text(caption,
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme
                                    .colors()
                                    .onBackground
                                    .withOpacity(0.6))),
                      const Flexible(flex: 2, child: SizedBox(height: 32)),
                    ]);
                  })),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      PasscodeDot(
                        position: i,
                        inputLenght: enteredCodeLen.value,
                        passwordIsWrong: hasError.value,
                      ),
                  ],
                ),
              ),
              SizedBox(height: h(165)),
              PasscodeNumbersRow(
                numbers: [1, 2, 3],
                onPressed: onNumberPressed,
              ),
              PasscodeNumbersRow(
                numbers: [4, 5, 6],
                onPressed: onNumberPressed,
              ),
              PasscodeNumbersRow(
                numbers: [7, 8, 9],
                onPressed: onNumberPressed,
              ),
              keyboardLastRow ??
                  PasscodeRowWithZero(
                    onZeroPressed: onNumberPressed,
                    onDeletePressed: onDeletePressed,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
