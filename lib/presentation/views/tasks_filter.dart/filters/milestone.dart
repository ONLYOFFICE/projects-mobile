part of '../tasks_filter.dart';

class _Milestone extends StatelessWidget {
  const _Milestone({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Milestone',
        options: <Widget>[
          FilterElement(
              title: 'Milestones with my tasks',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.milestone['My'],
              onTap: () => filterController.changeMilestone('My')),
          FilterElement(
              title: 'No milestone',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.milestone['No'],
              onTap: () => filterController.changeMilestone('No')),
          FilterElement(
              title: filterController.milestone['Other'].isEmpty
                  ? 'Other milestones'
                  : filterController.milestone['Other'],
              isSelected: filterController.milestone['Other'].isNotEmpty,
              onTap: () async {
                var milestone =
                    await Get.bottomSheet(const MilestonesBottomSheet());
                filterController.changeMilestone('Other', milestone);
              },
              cancelButtonEnabled:
                  filterController.milestone['Other'].isNotEmpty,
              onCancelTap: () =>
                  filterController.changeMilestone('Other', null)),
        ],
      ),
    );
  }
}
