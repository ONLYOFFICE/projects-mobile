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
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/locator.dart';

class CoreApi {
  var client = http.Client();
  final _secureStorage = locator<SecureStorage>();
  String _portalName;

  Future<Map<String, String>> getHeaders() async {
    var token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  var version = '2.0';

  String capabilitiesUrl(String portalName) =>
      'https://$portalName/api/$version/capabilities';

  Future<String> allGroups() async =>
      '${await getPortalURI()}/api/$version/group';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/$version/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication.json';

  Future<String> tfaUrl(String code) async =>
      '${await getPortalURI()}/api/$version/authentication/$code';

  Future<String> projectsByParamsBaseUrl() async =>
      '${await getPortalURI()}/api/$version/project/filter?';

  Future<String> tasksByFilterUrl(String params) async =>
      '${await getPortalURI()}/api/$version/project/task/filter?$params';

  Future<String> taskByIdUrl(int id) async =>
      '${await getPortalURI()}/api/$version/project/task/$id';

  Future<String> projectsUrl() async =>
      '${await getPortalURI()}/api/$version/project';

  Future<String> projectTags() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/$version/people/@self';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/$version/project/status';

  Future<String> updateTaskStatusUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/status';

  Future<String> createProjectUrl() async =>
      '${await getPortalURI()}/api/$version/project/withSecurity';

  Future<http.Response> getRequest(String url) async {
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final response = await request;
    return response;
  }

  Future<http.Response> putRequest(String url, Map body) async {
    var headers = await getHeaders();
    var request = client.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final response = await request;
    return response;
  }

  Future<String> getPortalURI() async {
    if (_portalName == null || _portalName.isEmpty) {
      _portalName = await _secureStorage.getString('portalName');
    }

    return 'https://$_portalName';
  }

  Future<String> getToken() async {
    var token = await _secureStorage.getString('token');

    return token;
  }
}
