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

import 'dart:convert';
import 'dart:io';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<AuthToken>> loginByUsername(String email, String pass) async {
    var url = await coreApi.authUrl();
    var body = {'userName': email, 'password': pass};

    var result = ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);

      if (response.statusCode == 500) {
        var message = json.decode(response.body)['error']['message'];
        result.error = CustomError(message: message);
        return result;
      }
      if (response.statusCode == 201) {
        result.response =
            // ignore: avoid_dynamic_calls
            AuthToken.fromJson(json.decode(response.body)['response']);
      } else {
        result.error = CustomError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
    String email,
    String pass,
    String code,
  ) async {
    var url = await coreApi.tfaUrl(code);
    var body = {
      'userName': email,
      'password': pass,
      'accessToken': '',
      'provider': ''
    };

    var result = ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalUser>> getUserInfo() async {
    var url = await coreApi.selfInfoUrl();

    var result = ApiDTO<PortalUser>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = PortalUser.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> setPhone(Map body) async {
    var url = await coreApi.setPhoneUrl();

    var result = ApiDTO();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> sendSms(Map body) async {
    var url = await coreApi.sendSmsUrl();

    var result = ApiDTO();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> passwordRecovery(String email) async {
    var url = await coreApi.passwordRecoveryUrl();

    var result = ApiDTO();

    var body = {'email': email};

    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> sendRegistrationType() async {
    var url = await coreApi.sendRegistrationTypeUrl();

    var result = ApiDTO();

    var type = Platform.isAndroid ? 1 : 0;

    var body = {'type': type};

    try {
      var response = await coreApi.postRequest(url, body);

      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
