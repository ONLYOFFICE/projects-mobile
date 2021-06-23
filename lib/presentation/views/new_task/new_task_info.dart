part of 'new_task_view.dart';

class NewTaskInfo extends StatelessWidget {
  final int maxLines;
  final bool isSelected;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const NewTaskInfo({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.isSelected = false,
    this.maxLines,
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
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: icon != null
                      ? AppIcon(
                          icon: icon,
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.4))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            caption != null && caption.isNotEmpty ? 10 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caption != null && caption.isNotEmpty)
                          Text(caption,
                              style: TextStyleHelper.caption(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onBackground
                                      .withOpacity(0.75))),
                        Text(text,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor != null
                                        ? textColor
                                        : isSelected
                                            ? Theme.of(context)
                                                .customColors()
                                                .onBackground
                                            : Theme.of(context)
                                                .customColors()
                                                .onSurface
                                                .withOpacity(0.4))),
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
            if (enableBorder) const StyledDivider(leftPadding: 72.5),
          ],
        ),
      ),
    );
  }
}

class TileWithSwitch extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool enableBorder;
  final Function(bool value) onChanged;
  const TileWithSwitch({
    Key key,
    @required this.title,
    @required this.isSelected,
    @required this.onChanged,
    this.enableBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 72, top: 18, bottom: 18),
                child: Text(title,
                    style: TextStyleHelper.subtitle1(
                        color: Theme.of(context).customColors().onSurface)),
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: onChanged,
            ),
            const SizedBox(width: 3)
          ],
        ),
        if (enableBorder) const StyledDivider(leftPadding: 72),
      ],
    );
  }
}
