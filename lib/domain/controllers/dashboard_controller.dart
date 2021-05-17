import 'package:get/get.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/project_service.dart';

class DashboardController extends GetxController {
  final _api = locator<ProjectService>();

  DashboardController() {}
}
