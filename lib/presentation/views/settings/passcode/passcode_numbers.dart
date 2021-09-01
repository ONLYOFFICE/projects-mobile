import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class PasscodeNumbersRow extends StatelessWidget {
  final List<int> numbers;
  final Function(int number) onPressed;
  const PasscodeNumbersRow({
    Key key,
    @required this.numbers,
    @required this.onPressed,
  })  : assert(numbers.length == 3),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PasscodeNumber(
          number: numbers[0],
          onPressed: (number) => onPressed(numbers[0]),
        ),
        const SizedBox(width: 20),
        PasscodeNumber(
          number: numbers[1],
          onPressed: (number) => onPressed(numbers[1]),
        ),
        const SizedBox(width: 20),
        PasscodeNumber(
          number: numbers[2],
          onPressed: (number) => onPressed(numbers[2]),
        ),
      ],
    );
  }
}

class PasscodeNumber extends StatelessWidget {
  final int number;
  final Function(int number) onPressed;
  final PasscodeSettingsController controller;

  const PasscodeNumber({
    Key key,
    @required this.number,
    @required this.onPressed,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onPressed(number),
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyleHelper.headline4(
              color: Get.theme.colors().onBackground,
            ).copyWith(height: 1),
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: AppIcon(
            icon: SvgIcons.delete_number,
            color: Theme.of(context).colors().onBackground,
          ),
        ),
      ),
    );
  }
}

class FingerprintButton extends StatelessWidget {
  const FingerprintButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(child: AppIcon(icon: SvgIcons.finger_print)),
      ),
    );
  }
}
