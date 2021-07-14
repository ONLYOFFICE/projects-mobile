part of '../discussions_filter_screen.dart';

class _Status extends StatelessWidget {
  final DiscussionsFilterController filterController;
  const _Status({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('status'),
        options: <Widget>[
          FilterElement(
              title: tr('open'),
              titleColor: Theme.of(context).colors().onSurface,
              isSelected: filterController.status['open'],
              onTap: () => filterController.changeStatus('open')),
          FilterElement(
              title: tr('archived'),
              titleColor: Theme.of(context).colors().onSurface,
              isSelected: filterController.status['archived'],
              onTap: () => filterController.changeStatus('archived')),
        ],
      ),
    );
  }
}
