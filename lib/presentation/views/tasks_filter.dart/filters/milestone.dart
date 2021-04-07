part of '../tasks_filter.dart';

class _Milestone extends StatelessWidget {
  const _Milestone({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FilterLabel(label: 'Milestone'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Milestones with my tasks',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.milestone['My'],
                  onTap: () => filterController.changeMilestone('My')),
              _FilterElement(
                  title: 'No milestone',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.milestone['No'],
                  onTap: () => filterController.changeMilestone('No')),
              _FilterElement(
                  title: filterController.milestone['Other'].isEmpty
                      ? 'Other milestones'
                      : filterController.milestone['Other'],
                  selected: filterController.milestone['Other'].isNotEmpty,
                  onTap: () async {
                    var milestone = await Get.bottomSheet(SelectMilestone());
                    filterController.changeMilestone('Other', milestone);
                  },
                  cancelButton: filterController.milestone['Other'].isNotEmpty,
                  onCancelTap: () =>
                      filterController.changeMilestone('Other', null)),
            ]),
          ),
        ],
      ),
    );
  }
}
