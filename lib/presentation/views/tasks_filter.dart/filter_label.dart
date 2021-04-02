part of 'tasks_filter.dart';

class _FilterLabel extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  const _FilterLabel({
    Key key,
    this.label,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ??
            const EdgeInsets.only(left: 16, top: 36.5, bottom: 20.05),
        child: Text(label,
            style: TextStyleHelper.h6(
                color: Theme.of(context).customColors().onSurface)));
  }
}
