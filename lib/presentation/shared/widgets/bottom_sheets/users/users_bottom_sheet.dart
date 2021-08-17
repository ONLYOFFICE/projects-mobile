/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/users/user_search_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/template/select_item_template.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';

part 'user_tile.dart';
part 'search_result.dart';
part 'user_list.dart';
part '../template/app_bar_icon.dart';
part '../template/app_bar_title.dart';

class UsersBottomSheet extends StatelessWidget with SelectItemMixin {
  const UsersBottomSheet({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectUser');

  @override
  BaseSearchController get searchController => Get.put(UserSearchController());

  @override
  UsersController get controller => Get.find<UsersController>();

  @override
  VoidCallback get getItemsFunction => () async => await controller.getUsers();

  @override
  Widget get nothingFound =>
      Column(children: const [Expanded(child: NothingFound())]);

  @override
  Widget get itemList => const _UserList();

  @override
  Widget get searchResult => _SearchResult(searchController: searchController);
}


// // TODO RENAME
// class UsersBottomSheet extends StatelessWidget {
//   const UsersBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final usersController = Get.find<UsersController>();
//     final searchController = Get.put(UserSearchController());

//     usersController.getUsers();

//     return SelectItemTemplate(
//       searchController: searchController,
//       titleText: tr('selectUser'),
//       body: Obx(
//         () {
//           if (usersController.loaded.isTrue &&
//               searchController.textController.text.isEmpty)
//             return const _UserList();

//           if (searchController.hasResult) return const _SearchResult();
//           if (searchController.nothingFound)
//             return Column(children: [const NothingFound()]);

//           return const ListLoadingSkeleton();
//         },
//       ),
//     );
//   }
// }
// // TODO RENAME
// class UsersBottomSheet extends StatelessWidget {
//   const UsersBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final usersController = Get.find<UsersController>();
//     final searchController = Get.put(UserSearchController());

//     usersController.getUsers();

//     return SelectItemTemplate(
//       searchController: searchController,
//       titleText: tr('selectUser'),
//       body: Obx(
//         () {
//           if (usersController.loaded.isTrue &&
//               searchController.textController.text.isEmpty)
//             return const _UserList();

//           if (searchController.hasResult) return const _SearchResult();
//           if (searchController.nothingFound)
//             return Column(children: [const NothingFound()]);

//           return const ListLoadingSkeleton();
//         },
//       ),
//     );
//   }
// }

// // TODO RENAME
// class UsersBottomSheet extends StatelessWidget {
//   const UsersBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final searchFieldController = TextEditingController();
//     final usersController = Get.find<UsersController>();

//     final searchController = Get.put(UserSearchController());
//     const searchIconKey = Key('srh');
//     const clearIconKey = Key('clr');

//     usersController.getUsers();

//     return Scaffold(
//       appBar: StyledAppBar(
//         showBackButton: true,
//         title: _AppBarTitle(
//           searchController: searchController,
//           searchFieldController: searchFieldController,
//         ),
//         actions: [
//           _AppBarIcon(
//               searchController: searchController,
//               searchIconKey: searchIconKey,
//               clearIconKey: clearIconKey,
//               searchFieldController: searchFieldController),
//         ],
//       ),
//       body: Obx(
//         () {
//           if (searchController.loaded.isTrue &&
//               searchController.switchToSearchView.isTrue &&
//               searchFieldController.text.isNotEmpty) {
//             return const _SearchResult();
//           }
//           if (searchController.loaded.isTrue &&
//               searchController.switchToSearchView.isTrue &&
//               searchController.paginationController.data.isEmpty &&
//               searchFieldController.text.isNotEmpty) {
//             return Column(children: [const NothingFound()]);
//           }
//           if (usersController.loaded.isTrue &&
//               searchFieldController.text.isEmpty) return const _UserList();
//           return const ListLoadingSkeleton();
//         },
//       ),
//     );
//   }
// }
