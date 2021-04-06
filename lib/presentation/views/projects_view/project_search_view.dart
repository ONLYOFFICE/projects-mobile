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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/views/projects_view/search_appbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProjectSearchController());
    controller.clearSearch();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchAppBar(
        title: SearchHeader(controller: controller),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (controller.loaded.isFalse) ListLoadingSkeleton(),
            if (controller.nothingFound.isTrue)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Not found',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            if (controller.loaded.isTrue && controller.searchResult.isNotEmpty)
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: controller.searchResult.length >= 25,
                  controller: controller.refreshController,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectCell(item: controller.searchResult[i]),
                    itemExtent: 100.0,
                    itemCount: controller.searchResult.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final ProjectSearchController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Material(
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: controller.searchInputController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter your query',
                  ),
                  onSubmitted: (value) {
                    controller.newSearch(value);
                  },
                  // onChanged: (value) {
                  //   controller.performSearch(value);
                  // },
                ),
              ),
              InkWell(
                onTap: () {
                  controller.clearSearch();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
