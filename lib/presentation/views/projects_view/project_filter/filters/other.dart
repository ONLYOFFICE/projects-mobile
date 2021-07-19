part of '../projects_filter.dart';

class _Other extends StatelessWidget {
  const _Other({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController =
        Get.find<ProjectsFilterController>(tag: 'ProjectsView');
    return Obx(
      () => FiltersRow(
        title: tr('other'),
        options: <Widget>[
          FilterElement(
            title: tr('followed'),
            titleColor: Get.theme.colors().onSurface,
            isSelected: filterController.other['followed'],
            onTap: () => filterController.changeOther('followed'),
          ),
          FilterElement(
            title: filterController.other['withTag'].isEmpty
                ? tr('withTag')
                : filterController.other['withTag'],
            isSelected: filterController.other['withTag'].isNotEmpty,
            cancelButtonEnabled: filterController.other['withTag'].isNotEmpty,
            onTap: () async {
              var selectedTag = await Get.bottomSheet(const TagsBottomSheet());
              await filterController.changeOther('withTag', selectedTag);
            },
            onCancelTap: () => filterController.changeOther('withTag', null),
          ),
          FilterElement(
            title: tr('withoutTag'),
            titleColor: Get.theme.colors().onSurface,
            isSelected: filterController.other['withoutTag'],
            onTap: () => filterController.changeOther('withoutTag'),
          ),
        ],
      ),
    );
  }
}
