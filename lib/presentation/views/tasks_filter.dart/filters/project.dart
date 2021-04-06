part of '../tasks_filter.dart';

class _Project extends StatelessWidget {
  const _Project({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FilterLabel(label: 'Project'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'My projects',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.project['My'],
                  onTap: () => filterController.changeProject('My')),
              _FilterElement(
                  title: filterController.project['Other'].isEmpty
                      ? 'Other projects'
                      : filterController.project['Other'],
                  selected: filterController.project['Other'].isNotEmpty,
                  cancelButton: filterController.project['Other'].isNotEmpty,
                  onTap: () async {
                    var selectedProject =
                        await Get.bottomSheet(SelectProject());
                    filterController.changeProject('Other', selectedProject);
                  },
                  onCancelTap: () =>
                      filterController.changeProject('Other', null)),
              _FilterElement(
                  title: 'With tag',
                  selected: filterController.project['With tag'],
                  onTap: () async {
                    var selectedTag = await Get.bottomSheet(SelectTag());
                    filterController.changeProject('With tag', selectedTag);
                  }),
              _FilterElement(
                  title: 'Without tag',
                  selected: filterController.project['Without tag'],
                  onTap: () => filterController.changeProject('Without tag')),
            ]),
          ),
        ],
      ),
    );
  }
}
