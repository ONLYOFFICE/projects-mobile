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

import 'package:only_office_mobile/data/models/authDTO.dart';
import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<AuthDTO> loginByUsername(
      String email, String pass, String portalName) async {
    var url = coreApi.getAuthUrl(portalName);
    var body =
        jsonEncode(<String, String>{'userName': email, 'password': pass});

    var result = new AuthDTO();
    try {
      var response = await coreApi.post(url, body);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.authToken = AuthToken.fromJson(responseJson);
      } else {
        result.error = PortalError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new PortalError(message: 'Чтото пошло не так');
    }

    return result;
  }

  Future<User> getUserProfile(int userId) async {
    return new User(id: 1123, name: "test", username: "testing");
  }
}
