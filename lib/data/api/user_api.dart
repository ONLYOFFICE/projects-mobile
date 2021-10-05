import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:http/http.dart' as http;

class UserApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalUser>>> getAllProfiles() async {
    var url = await coreApi.allProfiles();

    var result = ApiDTO<List<PortalUser>>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        final Map responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<PageDTO<List<PortalUser>>> getProfilesByExtendedFilter({
    int startIndex,
    String query,
    String groupId,
  }) async {
    var url = await coreApi.allProfiles();
    url += '/filter?';

    if (startIndex != null) {
      url += 'Count=25&StartIndex=$startIndex';
    }

    if (startIndex != null && query != null) {
      url += '&FilterValue=$query';
    }

    if (groupId != null && groupId.isNotEmpty) url += '&groupId=$groupId';

    var result = PageDTO<List<PortalUser>>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        final Map responseJson = json.decode(response.body);
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => PortalUser.fromJson(i))
              .toList();
        }
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
