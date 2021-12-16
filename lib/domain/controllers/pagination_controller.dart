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

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginationController<T> extends GetxController {
  static const PAGINATION_LENGTH = 25;
  RxList<T> data = <T>[].obs;

  RefreshController _refreshController = RefreshController();

  RefreshController get refreshController {
    if (!_refreshController.isLoading && !_refreshController.isRefresh)
      _refreshController = RefreshController();
    return _refreshController;
  }

  int startIndex = 0;
  RxInt total = 0.obs;

  late Function refreshDelegate;
  late Function loadDelegate;

  bool pullDownEnabled = false;

  bool get pullUpEnabled => data.length != total.value;

  Future<void> onRefresh() async {
    startIndex = 0;
    await refreshDelegate();
    refreshController.refreshCompleted();

    // update the user data in case of changing user rights on the server side
    Get.find<UserController>()
      ..clear()
      // ignore: unawaited_futures
      ..getUserInfo()
      // ignore: unawaited_futures
      ..getSecurityInfo();
  }

  Future<void> onLoading() async {
    startIndex += PAGINATION_LENGTH;
    if (startIndex >= total.value) {
      _refreshController.loadComplete();
      startIndex -= PAGINATION_LENGTH;
      return;
    }
    await loadDelegate();
    _refreshController.loadComplete();
  }

  void setup() {
    total.value = 0;
    startIndex = 0;
  }
}
