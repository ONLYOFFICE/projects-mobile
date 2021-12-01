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
import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class AuthService {
  final AuthApi _api = locator<AuthApi>();

  Future<ApiDTO<PortalUser>> getSelfInfo() async {
    final authResponse = await _api.getUserInfo();

    final result = authResponse.response != null;

    if (!result) {
      var errorText = '';
      if (authResponse.error?.message == 'Server error') {
        errorText = tr('tfaWrongCode');
      }
      await Get.find<ErrorDialog>()
          .show(errorText == '' ? authResponse.error!.message : errorText);
    }
    return authResponse;
  }

  Future<bool> checkAuthorization() async {
    final authResponse = await _api.getUserInfo();

    if (authResponse.response == null) {
      if (authResponse.error!.message.toLowerCase().contains('unauthorized')) {
        return false;
      } else {
        await Get.find<ErrorDialog>().show(authResponse.error!.message);
      }
    }
    return true;
  }

  Future<ApiDTO<AuthToken>> login({
    required String email,
    required String pass,
  }) async {
    final authResponse = await _api.loginByUsername(email: email, pass: pass);

    final tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await Get.find<ErrorDialog>().show(authResponse.error!.message);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode({
    required String email,
    required String pass,
    required String code,
  }) async {
    final authResponse =
        await _api.confirmTFACode(email: email, pass: pass, code: code);

    final tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      String? errorText;
      if (authResponse.error?.message != 'Server error') {
        errorText = authResponse.error?.message;
      }
      await Get.find<ErrorDialog>().show(errorText ?? '');
    }
    return authResponse;
  }

  Future<ApiDTO<dynamic>?> passwordRecovery({required String email}) async {
    final response = await _api.passwordRecovery(email);

    final success = response.response != null;

    if (!success) {
      await Get.find<ErrorDialog>().show(response.error!.message);
      return null;
    } else {
      return response;
    }
  }

  Future<ApiDTO<dynamic>?> sendRegistrationType() async {
    final response = await _api.sendRegistrationType();

    final success = response.response != null;

    if (!success) {
      return null;
    } else {
      return response;
    }
  }
}
