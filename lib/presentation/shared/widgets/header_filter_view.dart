import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class HeaderFilterView extends StatelessWidget {
  const HeaderFilterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Filter',
                  style: TextStyleHelper.h6(
                      color: Theme.of(context).customColors().onSurface))),
          const SizedBox(height: 14.5),
          const Divider(height: 9),
          const _FilterLabel(
              label: 'Responsible',
              padding: EdgeInsets.only(left: 16, bottom: 20.05)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              const _FilterElement(selected: true, title: 'Me'),
              const _FilterElement(title: 'Other user'),
              const _FilterElement(title: 'Groups'),
              _FilterElement(
                  title: 'No responsible',
                  titleColor: Theme.of(context).customColors().onSurface),
            ]),
          ),
          const _FilterLabel(label: 'Creator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Me',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other user'),
            ]),
          ),
          const _FilterLabel(label: 'Project'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'My projects',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other projects'),
              const _FilterElement(title: 'With tag'),
              const _FilterElement(title: 'Without tag'),
            ]),
          ),
          const _FilterLabel(label: 'Milestone'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Milestones with my tasks',
                  titleColor: Theme.of(context).customColors().onSurface),
              _FilterElement(
                  title: 'No milestone',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other milestones'),
            ]),
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}

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

class _FilterElement extends StatelessWidget {
  final bool selected;
  final String title;
  final Color titleColor;
  const _FilterElement(
      {Key key, this.selected = false, this.title, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD8D8D8), width: 0.5),
        borderRadius: BorderRadius.circular(16),
        color: selected
            ? Theme.of(context).customColors().primary
            : Theme.of(context).customColors().bgDescription,
      ),
      child: Text(
        title,
        style: TextStyleHelper.body2(
            color: selected
                ? Theme.of(context).customColors().onPrimarySurface
                : titleColor ?? Theme.of(context).customColors().primary),
      ),
    );
  }
}
