/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

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
