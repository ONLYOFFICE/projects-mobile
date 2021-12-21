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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double titleHeight;
  final double elevation;
  final double bottomHeight;
  final bool showBackButton;
  final bool? centerTitle;
  final Widget? title;
  final Widget? leading;
  final Widget? bottom;
  final String? titleText;
  final List<Widget>? actions;
  final Function()? onLeadingPressed;
  final Color? backgroundColor;

  final Icon? backButtonIcon;

  StyledAppBar({
    Key? key,
    this.actions,
    this.bottom,
    this.bottomHeight = 44,
    this.centerTitle,
    this.elevation = 1,
    this.leading,
    this.onLeadingPressed,
    this.showBackButton = true,
    this.backButtonIcon,
    this.title,
    this.titleHeight = 56,
    this.titleText,
    this.backgroundColor,
  })  : assert(titleText == null || title == null),
        assert(leading == null || onLeadingPressed == null),
        preferredSize = Size.fromHeight(bottom != null ? titleHeight + bottomHeight : titleHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.yellow.withOpacity(0.1),
    //     statusBarBrightness: Brightness.light));

    return AppBar(
      centerTitle: centerTitle,
      iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
      backgroundColor: backgroundColor,
      // backgroundColor: CupertinoColors.white, // TODO
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      shadowColor: Get.theme.colors().outline,

      // backwardsCompatibility: false,
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.dark,
      // ),
      leading: leading == null && showBackButton
          ? PlatformIconButton(
              icon: Icon(PlatformIcons(context).back),
              onPressed: onLeadingPressed ?? Get.back,
            )
          : leading,
      toolbarTextStyle: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
      actions: actions,
      // ignore: prefer_if_null_operators
      title: title != null
          ? PreferredSize(preferredSize: Size.fromHeight(titleHeight), child: title!)
          : titleText != null
              ? Text(
                  titleText!,
                  style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
                )
              : null,
      bottom: bottom == null
          ? null
          : PreferredSize(preferredSize: Size.fromHeight(bottomHeight), child: bottom!),
    );
  }
}
//
// class MaterialMainAppBar extends StatelessWidget {
//   const MaterialMainAppBar({Key? key, required this.controller, this.actions, this.bottom})
//       : super(key: key);
//
//   final BaseController controller;
//   final List<Widget>? actions;
//   final PreferredSizeWidget? bottom;
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       backgroundColor: Get.theme.colors().background,
//       pinned: true,
//       title: Text(
//         controller.screenName,
//         style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
//       ),
//       actions: actions,
//       bottom: bottom,
//     );
//   }
// }
//
// class CupertinoAppBar extends StatelessWidget {
//   const CupertinoAppBar(
//       {Key? key, required this.controller, this.children = const [], this.isCollapsed = false})
//       : super(key: key);
//
//   final BaseController controller;
//   final List<Widget> children;
//   final bool isCollapsed;
//
//   @override
//   Widget build(BuildContext context) {
//     return isCollapsed
//         ? SliverPersistentHeader(
//             pinned: true,
//             delegate: CupertinoCollapsedNavBar(
//                 controller: controller, persistentHeight: 44 + MediaQuery.of(context).padding.top),
//           )
//         : CupertinoSliverNavigationBar(
//             // border: Border.all(style: BorderStyle.none),
//             backgroundColor: Get.theme.colors().background,
//             padding: EdgeInsetsDirectional.zero,
//             largeTitle: Text(
//               controller.screenName,
//               style: TextStyle(color: Get.theme.colors().onSurface),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: children,
//             ),
//           );
//   }
// }
//
// class CupertinoCollapsedNavBar extends SliverPersistentHeaderDelegate {
//   const CupertinoCollapsedNavBar({required this.controller, required this.persistentHeight});
//   final BaseDocumentsController controller;
//   final double persistentHeight;
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return CupertinoNavigationBar(
//       backgroundColor: Get.theme.colors().background,
//       middle: Obx(
//         () => Text(
//           controller.screenName.value,
//           style: TextStyle(color: Get.theme.colors().onSurface),
//         ),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           IconButton(
//             icon: AppIcon(
//               width: 24,
//               height: 24,
//               icon: SvgIcons.search,
//               color: Get.theme.colors().primary,
//             ),
//             onPressed: () {
//               Get.find<NavigationController>()
//                   .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
//                 'folderName': controller.screenName.value,
//                 'folderId': controller.currentFolderID,
//                 'documentsController': controller,
//               });
//             },
//           ),
//           IconButton(
//             icon: FiltersButton(controller: controller),
//             onPressed: () async => Get.find<NavigationController>().toScreen(
//                 const DocumentsFilterScreen(),
//                 preventDuplicates: false,
//                 arguments: {'filterController': controller.filterController}),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: Icon(CupertinoIcons.ellipsis_circle, color: Get.theme.colors().primary, size: 24),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => persistentHeight;
//
//   @override
//   double get minExtent => persistentHeight;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     return false;
//   }
// }
