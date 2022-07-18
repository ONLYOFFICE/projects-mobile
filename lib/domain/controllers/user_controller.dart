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

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:synchronized/synchronized.dart';

class UserController extends GetxController {
  final user = Rxn<PortalUser>();
  final securityInfo = Rxn<SecurityInfo>();

  final dataUpdated = false.obs;

  static const _timeoutDuration = 3;

  Future<void> updateData() async {
    if (await getUserInfo() && await getSecurityInfo()) dataUpdated.value = !dataUpdated.value;
  }

  Timer? _userInfoTimeoutTimer;
  final _userInfoLock = Lock();

  Future<bool> getUserInfo() async {
    if (user.value != null && (_userInfoTimeoutTimer?.isActive == true || _userInfoLock.locked))
      return true;

    _userInfoTimeoutTimer = Timer(const Duration(seconds: _timeoutDuration), () {});

    final response = await _userInfoLock.synchronized(
      () async {
        final response = await locator<AuthService>().getSelfInfo();

        if (response.error == null) {
          user.value = response.response;

          return true;
        } else {
          if (response.error?.statusCode == 404) {
            await Get.find<ErrorDialog>().show(tr('selfUserNotFound'), awaited: true);

            await Get.find<LoginController>().logout();
          } else
            await Get.find<ErrorDialog>().show(response.error?.message ?? '');

          return false;
        }
      },
    );

    return response;
  }

  Timer? _securityInfoTimeoutTimer;
  final _securityInfoLock = Lock();

  Future<bool> getSecurityInfo() async {
    if (securityInfo.value != null &&
        (_securityInfoTimeoutTimer?.isActive == true || _securityInfoLock.locked)) return true;

    _securityInfoTimeoutTimer = Timer(const Duration(seconds: _timeoutDuration), () {});

    final response = await _securityInfoLock.synchronized(() async {
      final response = await locator<ProjectService>().getProjectSecurityinfo();
      if (response == null) return false;
      securityInfo.value = response;
      return true;
    });
    return response;
  }

  Future<String?> getUserId() async {
    if (user.value == null || user.value?.id == null) {
      if (!await getUserInfo()) return null;
    }
    return user.value!.id;
  }

  void clear() {
    //user.close();
    user.value = null;

    //securityInfo.close();
    securityInfo.value = null;

    //dataUpdated.close();
  }

  Future<void> deleteUser() async {
    final userService = locator<UserService>();
    final result = await userService.deleteAccount();
    if (result != null && result['statusCode'] == 200) {
      await Get.find<NavigationController>().showPlatformDialog(SingleButtonDialog(
        titleText: tr('Instructions had been sent to your email'),
        acceptText: tr('ok'),
      ));
    }
  }
}
