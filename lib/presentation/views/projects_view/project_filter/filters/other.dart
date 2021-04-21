part of '../projects_filter.dart';

class _Other extends StatelessWidget {
  const _Other({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<ProjectsFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Other',
        options: <Widget>[
          FilterElement(
              title: 'Followed',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.other['Followed'],
              onTap: () => filterController.changeOther('Followed')),
          FilterElement(
              title: filterController.other['With tag'].isEmpty
                  ? 'With tag'
                  : filterController.other['With tag'],
              isSelected: filterController.other['With tag'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.other['With tag'].isNotEmpty,
              onTap: () async {
                var selectedTag = await Get.bottomSheet(TagsBottomSheet());
                filterController.changeOther('With tag', selectedTag);
              },
              onCancelTap: () =>
                  filterController.changeOther('With tag', null)),
          FilterElement(
              title: 'Without tag',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.other['Without tag'],
              onTap: () => filterController.changeOther('Without tag')),
        ],
      ),
    );
  }
}
