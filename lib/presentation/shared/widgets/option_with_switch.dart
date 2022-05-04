import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class OptionWithSwitch extends StatelessWidget {
  const OptionWithSwitch(
      {Key? key,
      required this.title,
      required this.switchOnChanged,
      required this.switchValue,
      this.style})
      : super(key: key);

  final RxBool switchValue;
  final Function(bool)? switchOnChanged;
  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: switchOnChanged != null ? () => switchOnChanged!.call(!switchValue.value) : null,
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: style ?? TextStyleHelper.subtitle1(),
              ),
            ),
            const SizedBox(width: 20),
            Obx(
              () => PlatformSwitch(
                value: switchValue.value,
                onChanged: switchOnChanged,
                activeColor: Theme.of(context).colors().primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
