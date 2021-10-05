import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class GroupApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalGroup>>> getAllGroups() async {
    var url = await coreApi.allGroups();

    var result = ApiDTO<List<PortalGroup>>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalGroup.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<PageDTO<List<PortalGroup>>> getProfilesByExtendedFilter({
    int startIndex,
    String query,
  }) async {
    var url = await coreApi.allGroups();

    if (startIndex != null) {
      url += '?Count=25&StartIndex=$startIndex';
    }

    if (startIndex != null && query != null) {
      url += '&FilterValue=$query';
    }

    var result = PageDTO<List<PortalGroup>>();
    try {
      var response = await coreApi.getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => PortalGroup.fromJson(i))
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
