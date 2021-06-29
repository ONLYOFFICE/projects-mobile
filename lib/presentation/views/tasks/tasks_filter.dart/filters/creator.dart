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
              isSelected: filterController.creator['me'],
              onTap: () => filterController.changeCreator('me')),
          FilterElement(
            title: filterController.creator['other'].isEmpty
                ? tr('otherUser')
                : filterController.creator['other'],
            isSelected: filterController.creator['other'].isNotEmpty,
            cancelButtonEnabled: filterController.creator['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              await filterController.changeCreator('other', newUser);
            },
            onCancelTap: () => filterController.changeCreator('other', null),
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
//                   title: 'me',
//                   titleColor: Theme.of(context).customColors().onSurface,
//                   selected: filterController.creator['me'],
//                   onTap: () => filterController.changeCreator('me')),
//               _FilterElement(
//                 title: filterController.creator['other'].isEmpty
//                     ? 'other user'
//                     : filterController.creator['other'],
//                 selected: filterController.creator['other'].isNotEmpty,
//                 cancelButton: filterController.creator['other'].isNotEmpty,
//                 onTap: () async {
//                   var newUser = await Get.bottomSheet(SelectUser());
//                   filterController.changeCreator('other', newUser);
//                 },
//                 onCancelTap: () =>
//                     filterController.changeCreator('other', null),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
