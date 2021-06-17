import 'package:flutter/material.dart';
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
          return const Color(0xff81C4FF).withOpacity(0.1);
        }),
        side: MaterialStateProperty.resolveWith((_) {
          return const BorderSide(color: Color(0xff0C76D5), width: 1.5);
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(text, style: TextStyleHelper.subtitle2()),
            ),
          ),
          const Icon(Icons.arrow_drop_down_sharp)
        ],
      ),
    );
  }
}
