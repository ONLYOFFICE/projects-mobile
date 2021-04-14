import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class UserApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalUser>>> getAllProfiles() async {
    var url = await coreApi.allProfiles();

    var result = ApiDTO<List<PortalUser>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ProjectsApiDTO<List<PortalUser>>> getProfilesByParams(
      {int startIndex, String query}) async {
    var url = await coreApi.allProfiles();

    if (startIndex != null) {
      url += '/filter?Count=25&StartIndex=$startIndex';
    }

    if (startIndex != null && query != null) {
      url += '&Count=25&StartIndex=$startIndex&FilterValue=$query';
    }

    var result = ProjectsApiDTO<List<PortalUser>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.total = responseJson['total'];
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }
}
