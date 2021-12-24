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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:synchronized/synchronized.dart';

class ProjectsWithPresets {
  ProjectsController? _myProjectsController;
  ProjectsController? _folowedProjectsController;
  ProjectsController? _activeProjectsController;
  ProjectsController? _myMembershipProjectController;
  ProjectsController? _myManagedProjectController;

  Lock lock = Lock();

  ProjectsController get myProjectsController {
    _myProjectsController ?? _setupMyProjects();
    return _myProjectsController!;
  }

  ProjectsController get folowedProjectsController {
    _folowedProjectsController ?? _setupMyFolowedProjects();
    return _folowedProjectsController!;
  }

  ProjectsController get activeProjectsController {
    _activeProjectsController ?? _setupActiveProjects();
    return _activeProjectsController!;
  }

  ProjectsController get myMembershipProjectController {
    _myMembershipProjectController ?? _setupMyMembershipProjects();
    return _myMembershipProjectController!;
  }

  ProjectsController get myManagedProjectController {
    _myManagedProjectController ?? _setupMyManagedProjects();
    return _myManagedProjectController!;
  }

  Future<void> _setupMyProjects() async {
    _myProjectsController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put<PaginationController<ProjectDetailed>>(PaginationController<ProjectDetailed>(),
              tag: '_myProjectPaginationController'),
        ),
        tag: '_myProjectsController')!
      ..setup(PresetProjectFilters.myProjects, withFAB: false);
    await _myProjectsController!.loadProjects();
  }

  Future<void> _setupMyFolowedProjects() async {
    _folowedProjectsController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put<PaginationController<ProjectDetailed>>(PaginationController<ProjectDetailed>(),
              tag: '_folowedProjectPaginationController'),
          // Get.find<PaginationController<ProjectDetailed>>(
          //     tag: '_folowedProjectPaginationController'),
          // Get.put<PaginationController<ProjectDetailed>>(
          //     PaginationController<ProjectDetailed>(),
          //     tag: '_folowedProjectPaginationController'),
        ),
        tag: '_folowedProjectsController')!
      ..setup(PresetProjectFilters.myFollowedProjects, withFAB: false);
    await _folowedProjectsController!.loadProjects();
  }

  Future<void> _setupActiveProjects() async {
    _activeProjectsController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put<PaginationController<ProjectDetailed>>(PaginationController<ProjectDetailed>(),
              tag: '_activeProjectPaginationController'),
          // Get.put<PaginationController<ProjectDetailed>>(
          //     PaginationController<ProjectDetailed>()),
          // Get.put<PaginationController<ProjectDetailed>>(
          //     PaginationController<ProjectDetailed>(),
          //     tag: '_activeProjectPaginationController'),
        ),
        tag: '_activeProjectsController')!
      ..setup(PresetProjectFilters.active, withFAB: false);
    await _activeProjectsController!.loadProjects();
  }

  Future<void> _setupMyMembershipProjects() async {
    _myMembershipProjectController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put<PaginationController<ProjectDetailed>>(PaginationController<ProjectDetailed>(),
              tag: '_myMembershipProjectPaginationController'),
        ),
        tag: '_myMembershipProjectController')!
      ..setup(PresetProjectFilters.myMembership, withFAB: false);
    await _myMembershipProjectController!.loadProjects();
  }

  Future<void> _setupMyManagedProjects() async {
    _myManagedProjectController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put<PaginationController<ProjectDetailed>>(PaginationController<ProjectDetailed>(),
              tag: '_myManagedProjectPaginationController'),
        ),
        tag: '_myManagedProjectController')!
      ..setup(PresetProjectFilters.myManaged, withFAB: false);
    await _myManagedProjectController!.loadProjects();
  }
}
