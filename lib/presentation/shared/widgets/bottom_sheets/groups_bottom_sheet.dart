import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/groups/group_search_controller.dart';
import 'package:projects/domain/controllers/groups/groups_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/template/select_item_template.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class GroupsBottomSheet extends StatelessWidget with SelectItemMixin {
  const GroupsBottomSheet({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectUser');

  @override
  BaseSearchController get searchController => Get.put(GroupSearchController());

  @override
  GroupsController get controller => Get.find<GroupsController>();

  @override
  VoidCallback get getItemsFunction => () async => await controller.getGroups();

  @override
  Widget get nothingFound =>
      Column(children: const [Expanded(child: NothingFound())]);

  @override
  Widget get itemList => const _GroupList();

  @override
  Widget get searchResult => _SearchResult(searchController: searchController);
}

class _GroupList extends StatelessWidget {
  const _GroupList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsController = Get.find<GroupsController>();

    return Obx(
      () => PaginationListView(
        paginationController: groupsController.paginationController,
        child: ListView.separated(
          itemCount: groupsController.paginationController.data.length,
          separatorBuilder: (BuildContext context, int index) {
            return const StyledDivider(
              leftPadding: 16,
              rightPadding: 16,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return _GroupTile(
                group: groupsController.paginationController.data[index]);
          },
        ),
      ),
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    Key key,
    @required this.searchController,
  }) : super(key: key);

  final GroupSearchController searchController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PaginationListView(
        paginationController: searchController.paginationController,
        child: ListView.separated(
          itemCount: searchController.paginationController.data.length,
          separatorBuilder: (BuildContext context, int index) {
            return const StyledDivider(
              leftPadding: 16,
              rightPadding: 16,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return _GroupTile(
                group: searchController.paginationController.data[index]);
          },
        ),
      ),
    );
  }
}

// class GroupsBottomSheet extends StatelessWidget {
//   const GroupsBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final groupsController = Get.put(GroupsController());
//     final searchController = Get.put(GroupSearchController());

//     groupsController.getGroups();

//     return SelectItemTemplate(
//       searchController: searchController,
//       titleText: tr('selectGroup'),
//       body: Obx(
//         () {
//           if (searchController.switchToSearchView.isTrue &&
//               searchController.paginationController.data.isEmpty &&
//               searchController.textController.value.text.isNotEmpty) {
//             return Column(children: [const NothingFound()]);
//           }
//           if (searchController.switchToSearchView.isTrue &&
//               searchController.paginationController.data.isNotEmpty) {
//             var result = searchController.paginationController.data;

//             print(result.length);

//             return PaginationListView(
//               paginationController: searchController.paginationController,
//               child: ListView.separated(
//                 itemCount: searchController.paginationController.data.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return const StyledDivider(
//                     leftPadding: 16,
//                     rightPadding: 16,
//                     height: 5,
//                     thickness: 5,
//                   );
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   return _GroupTile(
//                       group: searchController.paginationController.data[index]);
//                 },
//               ),
//             );
//           }

//           if (groupsController.loaded.isTrue) {
//             return PaginationListView(
//               paginationController: groupsController.paginationController,
//               child: ListView.separated(
//                 itemCount: groupsController.paginationController.data.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return const StyledDivider(
//                     leftPadding: 16,
//                     rightPadding: 16,
//                   );
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   return _GroupTile(
//                       group: groupsController.paginationController.data[index]);
//                 },
//               ),
//             );
//           }
//           return const ListLoadingSkeleton();
//         },
//       ),
//     );
//   }
// }

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    Key key,
    @required this.group,
  }) : super(key: key);

  final PortalGroup group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(result: {'id': group.id, 'name': group.name}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    group.name,
                    style: TextStyleHelper.projectTitle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class GroupsBottomSheet extends StatelessWidget {
//   const GroupsBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final searchFieldController = TextEditingController();
//     final groupsController = Get.find<GroupsController>();

//     final searchController = Get.put(GroupSearchController());
//     const searchIconKey = Key('srh');
//     const clearIconKey = Key('clr');

//     groupsController.getGroups();

//     return Scaffold(
//       appBar: StyledAppBar(
//         showBackButton: true,
//         title: Obx(
//           () => AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             reverseDuration: const Duration(milliseconds: 300),
//             switchInCurve: Curves.easeOutSine,
//             switchOutCurve: Curves.fastOutSlowIn,
//             child: searchController.switchToSearchView.isTrue
//                 ? TextField(
//                     autofocus: true,
//                     controller: searchFieldController,
//                     decoration:
//                         InputDecoration.collapsed(hintText: tr('enterQuery')),
//                     style: TextStyleHelper.headline6(
//                       color: Get.theme.colors().onSurface,
//                     ),
//                     onSubmitted: (value) =>
//                         searchController.searchGroup(query: value),
//                   )
//                 : Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(tr('selectGroup')),
//                   ),
//           ),
//         ),
//         actions: [
//           Obx(
//             () => AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               reverseDuration: const Duration(milliseconds: 300),
//               switchInCurve: Curves.easeOutSine,
//               switchOutCurve: Curves.fastOutSlowIn,
//               child: searchController.switchToSearchView.isTrue
//                   ? IconButton(
//                       key: searchIconKey,
//                       onPressed: () {
//                         searchController.switchToSearchView.toggle();
//                         searchFieldController.clear();
//                         searchController.clear();
//                       },
//                       icon: const Icon(Icons.clear),
//                     )
//                   : IconButton(
//                       key: clearIconKey,
//                       onPressed: () =>
//                           searchController.switchToSearchView.toggle(),
//                       icon: const Icon(Icons.search),
//                     ),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(
//         () {
//           if (searchController.switchToSearchView.isTrue &&
//               searchController.itemList.isEmpty &&
//               searchFieldController.text.isNotEmpty) {
//             return Column(children: [const NothingFound()]);
//           }

//           if (groupsController.loaded.isTrue) {
//             return PaginationListView(
//               paginationController: groupsController.paginationController,
//               child: ListView.separated(
//                 itemCount: groupsController.paginationController.data.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return const StyledDivider(
//                     leftPadding: 16,
//                     rightPadding: 16,
//                   );
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   return _GroupTile(
//                       group: groupsController.paginationController.data[index]);
//                 },
//               ),
//             );
//           }
//           return const ListLoadingSkeleton();
//         },
//       ),
//     );
//   }
// }

// class _GroupTile extends StatelessWidget {
//   const _GroupTile({
//     Key key,
//     @required this.group,
//   }) : super(key: key);

//   final PortalGroup group;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Get.back(result: {'id': group.id, 'name': group.name}),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//             child: Row(
//               children: [
//                 Flexible(
//                   child: Text(
//                     group.name,
//                     style: TextStyleHelper.projectTitle,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
