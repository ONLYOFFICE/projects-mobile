import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';

class StatusesController extends GetxController {
  final _api = locator<ProjectService>();

  List<Status> statuses;
  List<Status> projectStatuses;
  Future<Null> isWorking;

  Future<List<Status>> getStatuses() async {
    if (statuses != null) {
      return statuses;
    }

    if (isWorking != null) {
      await isWorking;
      return statuses;
    }

    var completer = Completer<Null>();
    isWorking = completer.future;

    statuses = await _api.getStatuses();

    completer.complete();
    isWorking = null;

    return statuses;
  }

  Future<List<Status>> getProjectStatuses() async {
    if (statuses != null) {
      return statuses;
    }

    if (isWorking != null) {
      await isWorking;
      return statuses;
    }

    var completer = Completer<Null>();
    isWorking = completer.future;

    statuses = await _api.getStatuses();

    completer.complete();
    isWorking = null;

    return statuses;
  }
}
