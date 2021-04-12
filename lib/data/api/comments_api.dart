import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class CommentsApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalComment>>> getTaskComments({int taskId}) async {
    var url = await coreApi.taskComments(taskId: taskId);

    var result = ApiDTO<List<PortalComment>>();

    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalComment.fromJson(i))
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
