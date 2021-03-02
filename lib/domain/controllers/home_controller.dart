import 'package:get/get.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';

class HomeController extends GetxController {
  // Api _api = locator<Api>();

  // List<Projects> projects;

  Future getProjects(int userId) async {
    // setState(ViewState.Busy);
    // projects = await _api.getProjectsForUser(userId);
    // setState(ViewState.Idle);
  }
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
  }
}
