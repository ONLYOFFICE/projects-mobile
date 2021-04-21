part of '../tasks_filter.dart';

class _Responsible extends StatelessWidget {
  const _Responsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Responsible',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              isSelected: filterController.responsible['Me'],
              onTap: () => filterController.changeResponsible('Me')),
          FilterElement(
              title: filterController.responsible['Other'].isEmpty
                  ? 'Other user'
                  : filterController.responsible['Other'],
              isSelected: filterController.responsible['Other'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Other'].isNotEmpty,
              onTap: () async {
                var newUser = await Get.bottomSheet(UsersBottomSheet());
                filterController.changeResponsible('Other', newUser);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Other', null)),
          FilterElement(
              title: filterController.responsible['Groups'].isEmpty
                  ? 'Groups'
                  : filterController.responsible['Groups'],
              isSelected: filterController.responsible['Groups'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Groups'].isNotEmpty,
              onTap: () async {
                var newGroup = await Get.bottomSheet(GroupsBottomSheet());
                filterController.changeResponsible('Groups', newGroup);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Groups', null)),
          FilterElement(
              title: 'No responsible',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.responsible['No'],
              onTap: () => filterController.changeResponsible('No'))
        ],
      ),
    );
  }
}

// class _Responsible extends StatelessWidget {
//   const _Responsible({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var filterController = Get.find<TaskFilterController>();
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const _FilterLabel(
//               label: 'Responsible',
//               padding: EdgeInsets.only(left: 16, bottom: 20.05)),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Wrap(runSpacing: 16, spacing: 16, children: [
//               _FilterElement(
//                   title: 'Me',
//                   selected: filterController.responsible['Me'],
//                   onTap: () => filterController.changeResponsible('Me')),
//               _FilterElement(
//                   title: filterController.responsible['Other'].isEmpty
//                       ? 'Other user'
//                       : filterController.responsible['Other'],
//                   selected: filterController.responsible['Other'].isNotEmpty,
//                   cancelButton:
//                       filterController.responsible['Other'].isNotEmpty,
//                   onTap: () async {
//                     var newUser = await Get.bottomSheet(SelectUser());
//                     filterController.changeResponsible('Other', newUser);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeResponsible('Other', null)),
//               _FilterElement(
//                   title: filterController.responsible['Groups'].isEmpty
//                       ? 'Groups'
//                       : filterController.responsible['Groups'],
//                   selected: filterController.responsible['Groups'].isNotEmpty,
//                   cancelButton:
//                       filterController.responsible['Groups'].isNotEmpty,
//                   onTap: () async {
//                     var newGroup = await Get.bottomSheet(SelectGroup());
//                     filterController.changeResponsible('Groups', newGroup);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeResponsible('Groups', null)),
//               _FilterElement(
//                   title: 'No responsible',
//                   titleColor: Theme.of(context).customColors().onSurface,
//                   selected: filterController.responsible['No'],
//                   onTap: () => filterController.changeResponsible('No'))
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
