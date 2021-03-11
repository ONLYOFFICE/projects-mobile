import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/data/models/project.dart';
import 'package:only_office_mobile/data/services/project_service.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends GetxController {
  var _api = locator<ProjectService>();

  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    setState(ViewState.Busy);
    getProjects().then((value) => setState(ViewState.Idle));
  }

  List<Project> projects;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await getProjects();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch

    refreshController.loadComplete();
  }

  //

  Future getProjects() async {
    setState(ViewState.Busy);
    projects = await _api.getProjects();
    setState(ViewState.Idle);
  }

  var state = ViewState.Idle.obs;

  void setState(ViewState viewState) {
    state.value = viewState;
  }
}
