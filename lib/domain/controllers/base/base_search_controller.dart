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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

abstract class BaseSearchController extends GetxController {
  BaseSearchController({this.paginationController});

  final PaginationController? paginationController;
  final TextEditingController textController = TextEditingController();

  String? _query;

  final loaded = false.obs;
  final switchToSearchView = false.obs;

  bool get nothingFound =>
      switchToSearchView.value &&
      paginationController!.data.isEmpty &&
      textController.text.isNotEmpty &&
      loaded.value;

  bool get hasResult =>
      loaded.isTrue && switchToSearchView.isTrue && paginationController!.data.isNotEmpty;

  Future search(String? query, {bool needToClear = true});

  Future<void> performSearch({needToClear = true, String? query}) async {}

  // TODO: refact
  void addData(var result, bool needToClear) {
    if (result != null) {
      paginationController!.total.value = result.total as int;
      if (needToClear) paginationController!.data.clear();
      paginationController!.data.addAll(result.response as Iterable<dynamic>);
    }
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await performSearch(needToClear: true, query: _query);
    loaded.value = true;
  }

  void clearSearch() {
    paginationController!.data.clear();
    textController.clear();
    _query = null;
  }
}
