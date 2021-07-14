import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class PasscodeDot extends StatelessWidget {
  final int inputLenght;
  final int position;
  final bool passwordIsWrong;

  const PasscodeDot({
    Key key,
    @required this.inputLenght,
    @required this.position,
    this.passwordIsWrong = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      margin: position != 0 ? const EdgeInsets.only(left: 32) : null,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: !passwordIsWrong
              ? inputLenght >= position + 1
                  // ? Get.theme.customColors().onBackground
                  ? Get.theme.colors().primary
                  : Get.theme.colors().onBackground.withOpacity(0.2)
              : Get.theme.colors().colorError),
    );
  }
}
