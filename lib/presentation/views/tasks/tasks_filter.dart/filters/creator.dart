part of '../tasks_filter.dart';

class _Creator extends StatelessWidget {
  final TaskFilterController filterController;
  const _Creator({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('creator'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.creator['Me'],
              onTap: () => filterController.changeCreator('Me')),
          FilterElement(
            title: filterController.creator['Other'].isEmpty
                ? tr('otherUser')
                : filterController.creator['Other'],
            isSelected: filterController.creator['Other'].isNotEmpty,
            cancelButtonEnabled: filterController.creator['Other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              await filterController.changeCreator('Other', newUser);
            },
            onCancelTap: () => filterController.changeCreator('Other', null),
          ),
        ],
      ),
    );
  }
}

// class _Creator extends StatelessWidget {
//   const _Creator({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var filterController = Get.find<TaskFilterController>();
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const _FilterLabel(label: 'Creator'),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Wrap(runSpacing: 16, spacing: 16, children: [
//               _FilterElement(
//                   title: 'Me',
//                   titleColor: Theme.of(context).customColors().onSurface,
//                   selected: filterController.creator['Me'],
//                   onTap: () => filterController.changeCreator('Me')),
//               _FilterElement(
//                 title: filterController.creator['Other'].isEmpty
//                     ? 'Other user'
//                     : filterController.creator['Other'],
//                 selected: filterController.creator['Other'].isNotEmpty,
//                 cancelButton: filterController.creator['Other'].isNotEmpty,
//                 onTap: () async {
//                   var newUser = await Get.bottomSheet(SelectUser());
//                   filterController.changeCreator('Other', newUser);
//                 },
//                 onCancelTap: () =>
//                     filterController.changeCreator('Other', null),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
