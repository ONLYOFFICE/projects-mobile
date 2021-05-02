import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/milestone.dart';
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
  }) async {
    var url = await coreApi.milestonesByFilter();

// &deadlineStart=2008-04-10T06-30-00.000Z
// &deadlineStop=2008-04-10T06-30-00.000Z

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
}
