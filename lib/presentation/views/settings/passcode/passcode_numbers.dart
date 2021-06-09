import 'package:flutter/material.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

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
    return IconButton(
      onPressed: () => onPressed(number),
      iconSize: 60,
      icon: Text(
        number.toString(),
        style: TextStyleHelper.headline3(
          color: Theme.of(context).customColors().onBackground,
        ).copyWith(height: 1),
      ),
    );
  }
}

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
        const SizedBox(width: 30),
        PasscodeNumber(
          number: numbers[1],
          onPressed: (number) => onPressed(numbers[1]),
        ),
        const SizedBox(width: 30),
        PasscodeNumber(
          number: numbers[2],
          onPressed: (number) => onPressed(numbers[2]),
        ),
      ],
    );
  }
}