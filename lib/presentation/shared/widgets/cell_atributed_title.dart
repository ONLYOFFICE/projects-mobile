import 'package:flutter/material.dart';

class CellAtributedTitle extends StatelessWidget {
  const CellAtributedTitle({
    Key key,
    @required this.text,
    @required this.style,
    @required this.atributeIcon,
    @required this.atributeIconVisible,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final Widget atributeIcon;
  final bool atributeIconVisible;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          if (atributeIconVisible)
            WidgetSpan(
                child: atributeIcon, alignment: PlaceholderAlignment.middle),
          if (atributeIconVisible) TextSpan(text: ' $text'),
          if (!atributeIconVisible) TextSpan(text: text),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      softWrap: true,
    );
  }
}
