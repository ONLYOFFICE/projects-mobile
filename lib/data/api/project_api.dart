import 'dart:convert';

import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/project.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/error.dart';

class ProjectApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<Project>>> getProjects() async {
    var url = coreApi.projectsUrl();

    var result = new ApiDTO<List<Project>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Project.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }
}
