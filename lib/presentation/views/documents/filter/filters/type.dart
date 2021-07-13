part of '../documents_filter.dart';

class _Type extends StatelessWidget {
  final filterController;

  const _Type({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('type'),
        options: <Widget>[
          FilterElement(
              title: tr('folders'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['folders'],
              onTap: () => filterController.changeContentTypeFilter('folders')),
          FilterElement(
              title: tr('documents'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['documents'],
              onTap: () =>
                  filterController.changeContentTypeFilter('documents')),
          FilterElement(
              title: tr('presentations'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['presentations'],
              onTap: () =>
                  filterController.changeContentTypeFilter('presentations')),
          FilterElement(
              title: tr('spreadsheets'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['spreadsheets'],
              onTap: () =>
                  filterController.changeContentTypeFilter('spreadsheets')),
          FilterElement(
              title: tr('images'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['images'],
              onTap: () => filterController.changeContentTypeFilter('images')),
          FilterElement(
              title: tr('media'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['media'],
              onTap: () => filterController.changeContentTypeFilter('media')),
          FilterElement(
              title: tr('archives'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['archives'],
              onTap: () =>
                  filterController.changeContentTypeFilter('archives')),
          FilterElement(
              title: tr('allFiles'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.contentTypes['allFiles'],
              onTap: () =>
                  filterController.changeContentTypeFilter('allFiles')),
        ],
      ),
    );
  }
}
