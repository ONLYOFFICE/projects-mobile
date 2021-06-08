part of '../documents_filter.dart';

class _Type extends StatelessWidget {
  final filterController;

  const _Type({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: 'Type',
        options: <Widget>[
          FilterElement(
              title: 'folders',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['folders'],
              onTap: () => filterController.changeContentTypeFilter('folders')),
          FilterElement(
              title: 'Documents',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['documents'],
              onTap: () =>
                  filterController.changeContentTypeFilter('documents')),
          FilterElement(
              title: 'Presentations',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['presentations'],
              onTap: () =>
                  filterController.changeContentTypeFilter('presentations')),
          FilterElement(
              title: 'Spreadsheets',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['spreadsheets'],
              onTap: () =>
                  filterController.changeContentTypeFilter('spreadsheets')),
          FilterElement(
              title: 'Images',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['images'],
              onTap: () => filterController.changeContentTypeFilter('images')),
          FilterElement(
              title: 'Media',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['media'],
              onTap: () => filterController.changeContentTypeFilter('media')),
          FilterElement(
              title: 'Archives',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['archives'],
              onTap: () =>
                  filterController.changeContentTypeFilter('archives')),
          FilterElement(
              title: 'All files',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.contentTypes['allFiles'],
              onTap: () =>
                  filterController.changeContentTypeFilter('allFiles')),
        ],
      ),
    );
  }
}
