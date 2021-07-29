part of '../new_task_view.dart';

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
                    padding:
                        const EdgeInsets.only(left: 72, top: 18, bottom: 18),
                    child: Text(title,
                        style: TextStyleHelper.subtitle1(
                            color: Get.theme.colors().onSurface)))),
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
