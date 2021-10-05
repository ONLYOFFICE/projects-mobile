import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';

class ProjectsWithPresets {
  static var _myProjectsController;
  static var _folowedProjectsController;
  static var _activeProjectsController;
  static var _myMembershipProjectController;
  static var _myManagedProjectController;

  static ProjectsController get myProjectsController {
    _myProjectsController ?? _setupMyProjects();
    return _myProjectsController;
  }

  static ProjectsController get folowedProjectsController {
    _folowedProjectsController ?? _setupMyFolowedProjects();
    return _folowedProjectsController;
  }

  static ProjectsController get activeProjectsController {
    _activeProjectsController ?? _setupActiveProjects();
    return _activeProjectsController;
  }

  static ProjectsController get myMembershipProjectController {
    _myMembershipProjectController ?? _setupMyMembershipProjects();
    return _myMembershipProjectController;
  }

  static ProjectsController get myManagedProjectController {
    _myManagedProjectController ?? _setupMyManagedProjects();
    return _myManagedProjectController;
  }

  static void _setupMyProjects() async {
    final _filterController = Get.put(
      ProjectsFilterController(),
      tag: 'myProjects',
    );

    _myProjectsController = Get.put(
      ProjectsController(
        _filterController,
        Get.put(PaginationController(), tag: 'myProjects'),
      ),
      tag: 'myProjects',
    );

    await _filterController
        .setupPreset(PresetProjectFilters.myProjects)
        .then((value) => _myProjectsController.loadProjects());
  }

  static void _setupMyFolowedProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myFollowedProjects');

    _folowedProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myFollowedProjects'),
        ),
        tag: 'myFollowedProjects');
    _filterController
        .setupPreset(PresetProjectFilters.myFollowedProjects)
        .then((value) => _folowedProjectsController.loadProjects());
  }

  static void _setupActiveProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'active');

    _activeProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'active'),
        ),
        tag: 'active');
    _filterController
        .setupPreset(PresetProjectFilters.active)
        .then((value) => _activeProjectsController.loadProjects());
  }

  static void _setupMyMembershipProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myMembership');

    _myMembershipProjectController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myMembership'),
        ),
        tag: 'myMembership');
    _filterController
        .setupPreset(PresetProjectFilters.myMembership)
        .then((value) => _myMembershipProjectController.loadProjects());
  }

  static void _setupMyManagedProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myManaged');

    _myManagedProjectController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myManaged'),
        ),
        tag: 'myManaged');
    _filterController
        .setupPreset(PresetProjectFilters.myManaged)
        .then((value) => _myManagedProjectController.loadProjects());
  }
}
