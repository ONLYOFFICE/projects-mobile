part of '../documents_filter.dart';

class _SearchSettings extends StatelessWidget {
  final filterController;

  const _SearchSettings({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('searchSettings'),
        options: <Widget>[
          FilterElement(
              title: tr('inContent'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.searchSettings['in_content'],
              onTap: () =>
                  filterController.changeSearchSettingsFilter('in_content')),
          FilterElement(
              title: tr('excludeSubfolders'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.searchSettings['exclude_subfolders'],
              onTap: () => filterController
                  .changeSearchSettingsFilter('exclude_subfolders')),
        ],
      ),
    );
  }
}
