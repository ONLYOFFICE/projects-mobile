import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class MilestoneApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<Milestone>>> milestonesByFilter({
    int startIndex,
    String sortBy,
    String sortOrder,
    String projectId,
    String milestoneResponsibleFilter,
    String taskResponsibleFilter,
    String statusFilter,
    String deadlineFilter,
  }) async {
    var url = await coreApi.milestonesByFilter();

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (sortBy != null &&
        sortBy.isNotEmpty &&
        sortOrder != null &&
        sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    if (milestoneResponsibleFilter != null) {
      url += milestoneResponsibleFilter;
    }
    if (taskResponsibleFilter != null) {
      url += taskResponsibleFilter;
    }
    if (statusFilter != null) {
      url += statusFilter;
    }

    if (deadlineFilter != null) {
      url += deadlineFilter;
    }

    if (projectId != null && projectId.isNotEmpty)
      url += '&projectid=$projectId';

    var result = ApiDTO<List<Milestone>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Milestone.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<Map<String, dynamic>>> createMilestone(
      {int projectId, NewMilestoneDTO milestone}) async {
    var url = await coreApi.createMilestoneUrl(projectId.toString());

    var result = ApiDTO<Map<String, dynamic>>();
    var body = jsonEncode(milestone.toJson());

    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }
}
