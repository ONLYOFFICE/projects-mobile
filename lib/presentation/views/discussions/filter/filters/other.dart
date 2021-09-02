part of '../discussions_filter_screen.dart';

class _Other extends StatelessWidget {
  final DiscussionsFilterController filterController;
  const _Other({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('other'),
        options: <Widget>[
          FilterElement(
              title: tr('subscribedDiscussions'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.other['subscribed'],
              onTap: () => filterController.changeOther('subscribed')),
        ],
      ),
    );
  }
}
