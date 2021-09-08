import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StatusButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const StatusButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
          return const Color(0xff81C4FF).withOpacity(0.2);
        }),
        side: MaterialStateProperty.resolveWith((_) {
          return const BorderSide(color: Colors.transparent, width: 0);
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
              child: Text(
                text,
                style: TextStyleHelper.subtitle2(
                  color: Get.theme.colors().primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Get.theme.colors().primary,
              size: 19,
            ),
          )
        ],
      ),
    );
  }
}
