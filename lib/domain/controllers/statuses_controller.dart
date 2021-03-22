import 'package:get/get.dart';
import 'package:only_office_mobile/data/models/from_api/status.dart';
import 'package:only_office_mobile/data/services/project_service.dart';
import 'package:only_office_mobile/internal/locator.dart';

class StatusesController extends GetxController {
  var _api = locator<ProjectService>();

  List<Status> statuses;

  Future<List<Status>> getStatuses() async {
    return statuses == null
        ? await _api.getStatuses().then((value) => statuses = value)
        : statuses;
  }
}
