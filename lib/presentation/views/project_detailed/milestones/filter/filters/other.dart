part of '../milestones_filter.dart';

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
              isSelected: filterController.other['followed'],
              onTap: () => filterController.changeOther('followed')),
          FilterElement(
              title: filterController.other['withTag'].isEmpty
                  ? 'With Tag'
                  : filterController.other['withTag'],
              isSelected: filterController.other['withTag'].isNotEmpty,
              cancelButtonEnabled: filterController.other['withTag'].isNotEmpty,
              onTap: () async {
                var selectedTag =
                    await Get.bottomSheet(const TagsBottomSheet());
                filterController.changeOther('withTag', selectedTag);
              },
              onCancelTap: () => filterController.changeOther('withTag', null)),
          FilterElement(
              title: 'Without Tag',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.other['withoutTag'],
              onTap: () => filterController.changeOther('withoutTag')),
        ],
      ),
    );
  }
}
