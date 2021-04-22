part of '../tasks_filter.dart';

class _Project extends StatelessWidget {
  const _Project({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Project',
        options: <Widget>[
          FilterElement(
              title: 'My projects',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.project['My'],
              onTap: () => filterController.changeProject('My')),
          FilterElement(
              title: filterController.project['Other'].isEmpty
                  ? 'Other projects'
                  : filterController.project['Other'],
              isSelected: filterController.project['Other'].isNotEmpty,
              cancelButtonEnabled: filterController.project['Other'].isNotEmpty,
              onTap: () async {
                var selectedProject =
                    await Get.bottomSheet(const ProjectsBottomSheet());
                filterController.changeProject('Other', selectedProject);
              },
              onCancelTap: () => filterController.changeProject('Other', null)),
          FilterElement(
              title: filterController.project['With tag'].isEmpty
                  ? 'With tag'
                  : filterController.project['With tag'],
              isSelected: filterController.project['With tag'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.project['With tag'].isNotEmpty,
              onTap: () async {
                var selectedTag =
                    await Get.bottomSheet(const TagsBottomSheet());
                filterController.changeProject('With tag', selectedTag);
              },
              onCancelTap: () =>
                  filterController.changeProject('With tag', null)),
          FilterElement(
              title: 'Without tag',
              isSelected: filterController.project['Without tag'],
              onTap: () => filterController.changeProject('Without tag')),
        ],
      ),
    );
  }
}

// class _Project extends StatelessWidget {
//   const _Project({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var filterController = Get.find<TaskFilterController>();
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const _FilterLabel(label: 'Project'),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Wrap(runSpacing: 16, spacing: 16, children: [
//               _FilterElement(
//                   title: 'My projects',
//                   titleColor: Theme.of(context).customColors().onSurface,
//                   selected: filterController.project['My'],
//                   onTap: () => filterController.changeProject('My')),
//               _FilterElement(
//                   title: filterController.project['Other'].isEmpty
//                       ? 'Other projects'
//                       : filterController.project['Other'],
//                   selected: filterController.project['Other'].isNotEmpty,
//                   cancelButton: filterController.project['Other'].isNotEmpty,
//                   onTap: () async {
//                     var selectedProject =
//                         await Get.bottomSheet(SelectProject());
//                     filterController.changeProject('Other', selectedProject);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeProject('Other', null)),
//               _FilterElement(
//                   title: filterController.project['With tag'].isEmpty
//                       ? 'With tag'
//                       : filterController.project['With tag'],
//                   selected: filterController.project['With tag'].isNotEmpty,
//                   cancelButton: filterController.project['With tag'].isNotEmpty,
//                   onTap: () async {
//                     var selectedTag = await Get.bottomSheet(SelectTag());
//                     filterController.changeProject('With tag', selectedTag);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeProject('With tag', null)),
//               _FilterElement(
//                   title: 'Without tag',
//                   selected: filterController.project['Without tag'],
//                   onTap: () => filterController.changeProject('Without tag')),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
