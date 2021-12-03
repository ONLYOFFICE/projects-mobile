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
import 'package:http/http.dart' as http;
import 'package:projects/data/enums/platforms.dart';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class AuthApi {
  Future<ApiDTO<AuthToken>> loginByUsername({required String email, required String pass}) async {
    final url = await locator.get<CoreApi>().authUrl();
    final body = {'userName': email, 'password': pass};

    var result = ApiDTO<AuthToken>();
    try {
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        result.response =
            AuthToken.fromJson(json.decode(response.body)['response'] as Map<String, dynamic>);
        await locator.get<CoreApi>().savePortalName();
      } else {
        if (response is CustomError && response.message == 'Redirect') {
          locator.get<CoreApi>().redirectPortal();
          result = await loginByUsernameRedirected(email, pass);
        } else
          result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> loginByUsernameRedirected(String email, String pass) async {
    final url = await locator.get<CoreApi>().authUrl();
    final body = {'userName': email, 'password': pass};

    final result = ApiDTO<AuthToken>();
    try {
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        result.response =
            AuthToken.fromJson(json.decode(response.body)['response'] as Map<String, dynamic>);
        await locator.get<CoreApi>().savePortalName();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode({
    required String email,
    required String pass,
    required String code,
  }) async {
    final url = await locator.get<CoreApi>().tfaUrl(code: code);
    final body = {'userName': email, 'password': pass, 'accessToken': '', 'provider': ''};

    final result = ApiDTO<AuthToken>();
    try {
      final dynamic response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = AuthToken.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalUser>> getUserInfo() async {
    final url = await locator.get<CoreApi>().selfInfoUrl();

    final result = ApiDTO<PortalUser>();
    try {
      final dynamic response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = PortalUser.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> setPhone(Map body) async {
    final url = await locator.get<CoreApi>().setPhoneUrl();

    final result = ApiDTO<dynamic>();
    try {
      final dynamic response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = AuthToken.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> sendSms(Map body) async {
    final url = await locator.get<CoreApi>().sendSmsUrl();

    final result = ApiDTO<dynamic>();
    try {
      final dynamic response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = AuthToken.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> passwordRecovery(String email) async {
    final url = await locator.get<CoreApi>().passwordRecoveryUrl();

    final result = ApiDTO<dynamic>();

    final body = {'email': email};

    try {
      final dynamic response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = responseJson['response'] as Map<String, dynamic>;
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> sendRegistrationType() async {
    final url = await locator.get<CoreApi>().sendRegistrationTypeUrl();

    final result = ApiDTO<dynamic>();

    final type = Platform.isAndroid ? Platforms.AndroidProjects : Platforms.IosProjects;

    final body = {'type': type};

    try {
      final dynamic response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final dynamic responseJson = json.decode(response.body);
        result.response = responseJson['response'] as Map<String, dynamic>;
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
