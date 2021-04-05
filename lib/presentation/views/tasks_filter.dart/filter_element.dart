part of 'tasks_filter.dart';

class _FilterElement extends StatelessWidget {
  final bool selected;
  final String title;
  final Color titleColor;
  final bool cancelButton;
  final Function() onTap;
  final Function() onCancelTap;

  const _FilterElement(
      {Key key,
      this.selected = false,
      this.title,
      this.titleColor,
      this.onTap,
      this.cancelButton = false,
      this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffD8D8D8), width: 0.5),
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? Theme.of(context).customColors().primary
              : Theme.of(context).customColors().bgDescription,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.body2(
                      color: selected
                          ? Theme.of(context).customColors().onPrimarySurface
                          : titleColor ??
                              Theme.of(context).customColors().primary)),
            ),
            if (cancelButton)
              Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: InkWell(
                      onTap: onCancelTap,
                      child:
                          Icon(Icons.cancel, color: Colors.white, size: 18))),
          ],
        ),
      ),
    );
  }
}
