part of '../tasks_filter.dart';

class _Milestone extends StatelessWidget {
  final TaskFilterController filterController;
  const _Milestone({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('milestone'),
        options: <Widget>[
          FilterElement(
              title: tr('milestonesWithMyTasks'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.milestone['my'],
              onTap: () => filterController.changeMilestone('my')),
          FilterElement(
              title: tr('noMilestone'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.milestone['no'],
              onTap: () => filterController.changeMilestone('no')),
          FilterElement(
              title: filterController.milestone['other'].isEmpty
                  ? tr('otherMilestones')
                  : filterController.milestone['other'],
              isSelected: filterController.milestone['other'].isNotEmpty,
              onTap: () async {
                var milestone = await Get.find<NavigationController>()
                    .toScreen(const SelectMilestoneScreen());
                filterController.changeMilestone('other', milestone);
              },
              cancelButtonEnabled:
                  filterController.milestone['other'].isNotEmpty,
              onCancelTap: () =>
                  filterController.changeMilestone('other', null)),
        ],
      ),
    );
  }
}
