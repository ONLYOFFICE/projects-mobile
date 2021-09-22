import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StatusButton extends StatelessWidget {
  final bool canEdit;
  final String text;
  final Function() onPressed;

  const StatusButton({
    Key key,
    @required this.canEdit,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: canEdit ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
          return canEdit
              ? const Color(0xff81C4FF).withOpacity(0.2)
              : Get.theme.colors().bgDescription;
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
                  color: canEdit
                      ? Get.theme.colors().primary
                      : Get.theme.colors().onBackground.withOpacity(0.75),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          if (canEdit)
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
