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

import 'package:http/http.dart' as http;
import 'package:only_office_mobile/data/services/secure_storage.dart';
import 'package:only_office_mobile/internal/locator.dart';

class CoreApi {
  var client = new http.Client();
  var _secureStorage = locator<Storage>();
  String _portalName;

  CoreApi() {
    _secureStorage
        .getString('portalName')
        .then((value) => {_portalName = value});
  }

  Future<Map<String, String>> getHeaders() async {
    var token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  String capabilitiesUrl(String portalName) =>
      'https://$portalName/api/2.0/capabilities';

  String authUrl() => '${getPortalURI()}/api/2.0/authentication.json';

  String tfaUrl(String code) =>
      '${getPortalURI()}/api/2.0/authentication/${code}';

  String projectsUrl() => '${getPortalURI()}/api/2.0/project';

  Future<http.Response> getRequest(String url) async {
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final http.Response response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final http.Response response = await request;
    return response;
  }

  String getPortalURI() {
    if (_portalName == null || _portalName.isEmpty) {
      _secureStorage
          .getString('portalName')
          .then((value) => {_portalName = value});
    }

    return 'https://${_portalName}';
  }

  Future<String> getToken() async {
    String token = await _secureStorage.getString('token');

    return token;
  }
}
