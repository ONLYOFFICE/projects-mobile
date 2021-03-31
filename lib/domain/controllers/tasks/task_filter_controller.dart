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
import 'package:projects/data/services/tasks_service.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends GetxController {
  final _api = locator<TasksService>();

  var projectFilters = '';
  RxInt suitableTasksCount = (-1).obs;
  List filteredTaskList = [];

  RxMap<String, bool> responsible = {
    'Me': false,
    'Other': false,
    'Groups': false,
    'No responsible': false
  }.obs;

  RxMap creator = {'Me': false, 'Other': false}.obs;

  RxMap project = {
    'My': false,
    'Other': false,
    'With tag': false,
    'Without tag': false
  }.obs;

  RxMap milestone = {'My': false, 'No': false, 'Other': false}.obs;

  void changeResponsible(String filter) {
    responsible.updateAll((key, value) => false);
    responsible[filter] = !responsible[filter];
  }

  void changeCreator(String filter) {
    creator.updateAll((key, value) => false);
    creator[filter] = !creator[filter];
  }

  void changeProject(String filter) async {
    switch (filter) {
      case 'My':
        project['Other'] = false;
        project['My'] = !project['My'];
        break;
      case 'Other':
        project['My'] = false;
        project['Other'] = !project['Other'];
        break;
      case 'With tag':
        project['Without tag'] = false;
        project['With tag'] = !project['With tag'];
        break;
      case 'Without tag':
        project['With tag'] = false;
        project['Without tag'] = !project['Without tag'];
        break;
      default:
    }
    projectFilters = '';
    if (project['My']) projectFilters = projectFilters + '&myProjects=true';
    if (project['Other']) projectFilters = projectFilters + '&myProjects=false';
    getSuitableTasksCount();
  }

  void changeMilestone(String filter) {
    milestone.updateAll((key, value) => false);
    milestone[filter] = !milestone[filter];
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;
    filteredTaskList = await _api.getTasks(filter: projectFilters);
    suitableTasksCount.value = filteredTaskList.length;
  }

  void filter() async {
    var _tasksController = Get.find<TasksController>();
    _tasksController.tasks.value = filteredTaskList;
  }
}
