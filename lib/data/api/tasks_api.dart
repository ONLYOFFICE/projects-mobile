import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class TasksApi {

  var coreApi = locator<CoreApi>();

  Future <ApiDTO> getTaskByID({int id})  async {

    var url = await coreApi.taskByIdUrl(id);
    var result;

    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'])
            .map((i) => PortalTask.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;

  }


  Future<ApiDTO<List<PortalTask>>> getTasks() async {

    var url = await coreApi.tasksByFilterUrl('');

    var result = ApiDTO<List<PortalTask>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalTask.fromJson(i))
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

// class TasksApi {
//   var coreApi = locator<CoreApi>();

//   Future<ApiDTO<List<Project>>> getTasks() async {

//     var url = await coreApi.projectsUrl();

//     var result = ApiDTO<List<Project>>();
//     try {
//       var response = await coreApi.getRequest(url);
//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {
//         result.response = (responseJson['response'] as List)
//             .map((i) => Project.fromJson(i))
//             .toList();
//       } else {
//         result.error = CustomError.fromJson(responseJson['error']);
//       }
//     } catch (e) {
//       result.error = CustomError(message: 'Ошибка');
//     }

//     return result;
//   }

//   Future<ApiDTO<List<ProjectDetailed>>> getProjectsByParams() async {
// // ?tag=1234
// // &participant=9924256A-739C-462b-AF15-E652A3B1B6EB
// // &manager=9924256A-739C-462b-AF15-E652A3B1B6EB
// // &departament=9924256A-739C-462b-AF15-E652A3B1B6EB
// // &follow=True

//     var url = await coreApi.projectsByParamsUrl('');
//     var result = ApiDTO<List<ProjectDetailed>>();
//     try {
//       var response = await coreApi.getRequest(url);
//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {
//         result.response = (responseJson['response'] as List)
//             .map((i) => ProjectDetailed.fromJson(i))
//             .toList();
//       } else {
//         result.error = CustomError.fromJson(responseJson['error']);
//       }
//     } catch (e) {
//       result.error = CustomError(message: 'Ошибка');
//     }

//     return result;
//   }

//   Future<ApiDTO<List<PortalTask>>> getTaskById(int id) async {

//     var url = await coreApi.taskByIdUrl(id);
//     var result = ApiDTO<List<PortalTask>>();
    
//     try {
//       var response = await coreApi.getRequest(url);
//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {
//         result.response = (responseJson['response'] as List)
//             .map((i) => PortalTask.fromJson(i))
//             .toList();
//       } else {
//         result.error = CustomError.fromJson(responseJson['error']);
//       }
//     } catch (e) {
//       result.error = CustomError(message: 'Ошибка');
//     }

//     return result;
//   }

//   Future<ApiDTO<List<Status>>> getStatuses() async {
//     var url = await coreApi.statusesUrl();
//     var result = ApiDTO<List<Status>>();
//     try {
//       var response = await coreApi.getRequest(url);
//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {
//         result.response = (responseJson['response'] as List)
//             .map((i) => Status.fromJson(i))
//             .toList();
//       } else {
//         result.error = CustomError.fromJson(responseJson['error']);
//       }
//     } catch (e) {
//       result.error = CustomError(message: 'Ошибка');
//     }

//     return result;
//   }

// //   GET api/2.0/project/task/filter
// // ?projectid=1234
// // &tag=1234
// // &departament=9924256A-739C-462b-AF15-E652A3B1B6EB
// // &creator=9924256A-739C-462b-AF15-E652A3B1B6EB
// // &deadlineStart=2008-04-10T06-30-00.000Z
// // &deadlineStop=2008-04-10T06-30-00.000Z
// // &lastId=1234
// // &myProjects=True
// // &myMilestones=True
// // &nomilestone=True
// // &follow=True
// // Host: yourportal.onlyoffice.com
// // Content-Type: application/json
// // Accept: application/json
//   Future<ApiDTO<List<PortalTask>>> getTasksByFilter(
//       {String participant}) async {
//     var url = await coreApi.tasksByFilterUrl('&participant=$participant');
//     var result = ApiDTO<List<PortalTask>>();
//     try {
//       var response = await coreApi.getRequest(url);
//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {
//         result.response = (responseJson['response'] as List)
//             .map((i) => PortalTask.fromJson(i))
//             .toList();
//       } else {
//         result.error = CustomError.fromJson(responseJson['error']);
//       }
//     } catch (e) {
//       result.error = CustomError(message: 'Ошибка');
//     }

//     return result;
//   }
// }
