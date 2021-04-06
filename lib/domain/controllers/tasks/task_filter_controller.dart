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
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends GetxController {
  final _api = locator<TaskService>();

  var projectFilters = '';
  var milestoneFilters = '';

  RxInt suitableTasksCount = (-1).obs;
  List filteredTaskList = [];

  RxMap<String, dynamic> responsible = {
    'Me': true,
    'Other': '',
    'Groups': '',
    'No': false,
  }.obs;

  RxMap<String, dynamic> creator = {
    'Me': false,
    'Other': '',
  }.obs;

  RxMap<String, dynamic> project = {
    'My': false,
    'Other': '',
    'With tag': false,
    'Without tag': false,
  }.obs;

  RxMap<String, dynamic> milestone = {
    'My': false,
    'No': false,
    'Other': '',
  }.obs;

  void changeResponsible(String filter, [newValue = '']) {
    switch (filter) {
      case 'Me':
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = false;
        responsible['Me'] = !responsible['Me'];
        break;
      case 'Other':
        responsible['Me'] = false;
        responsible['Groups'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Other'] = '';
        } else {
          responsible['Other'] = newValue['displayName'];
        }
        break;
      case 'Groups':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['No'] = false;
        print('dsadsa'.isEmpty.toString() + 'dsadsa isEmpty');
        print(''.isEmpty.toString() + ' isEmpty');
        print(' '.isEmpty.toString() + '  isEmpty');
        if (newValue == null) {
          responsible['Groups'] = '';
        } else {
          responsible['Groups'] = newValue['name'];
        }
        break;
      case 'No':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = !responsible['No'];
        break;
      default:
    }
    // getSuitableTasksCount();
  }

  void changeCreator(String filter, [newValue = '']) {
    if (filter == 'Me') {
      creator['Other'] = '';
      creator['Me'] = !creator['Me'];
    }
    if (filter == 'Other') {
      creator['Me'] = false;
      if (newValue == null) {
        creator['Other'] = '';
      } else {
        creator['Other'] = newValue['displayName'];
      }
    }
    // getSuitableTasksCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    switch (filter) {
      case 'My':
        project['Other'] = '';
        project['My'] = !project['My'];
        break;
      case 'Other':
        project['My'] = false;
        if (newValue == null) {
          project['Other'] = '';
        } else {
          project['Other'] = newValue['title'];
        }
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
    // projectFilters = '';
    // if (project['My']) projectFilters = projectFilters + '&myProjects=true';
    // if (project['Other']) projectFilters = projectFilters + '&myProjects=false';
    // getSuitableTasksCount();
  }

  void changeMilestone(String filter, [newValue]) {
    milestoneFilters = '';
    switch (filter) {
      case 'My':
        milestone['No'] = false;
        milestone['Other'] = '';
        milestone['My'] = !milestone['My'];
        break;
      case 'No':
        milestone['My'] = false;
        milestone['Other'] = '';
        milestone['No'] = !milestone['No'];
        break;
      case 'Other':
        milestone['My'] = false;
        milestone['No'] = false;
        if (newValue == null) {
          milestone['Other'] = '';
        } else {
          milestone['Other'] = 'smth else';
        }
        break;
      default:
    }
    // if (milestone['My']) {
    //   milestoneFilters = milestoneFilters + '&myMilestones=true';
    // }
    // if (project['Other']) {
    //   projectFilters = projectFilters + '&myMilestones=false';
    // }
    // if (milestone['No']) {
    //   milestoneFilters = milestoneFilters + '&nomilestone=true';
    // }
    // getSuitableTasksCount();
  }

  // void getSuitableTasksCount() async {
  //   suitableTasksCount.value = -1;
  //   var fltr = projectFilters + milestoneFilters;
  //   filteredTaskList = await _api.getTasks(params: fltr);

  //   var _myId = await Get.find<UserController>().getUserId();

  //   filteredTaskList = filteredTaskList.where((element) {
  //     var f = true;
  //     // the creator and responsible are filtered locally
  //     // because I didn't find any matching queries
  //     if (creator['Me']) f = f && element.createdBy.id == _myId;
  //     if (creator['Other']) f = f && element.createdBy.id != _myId;
  //     if (responsible['Me']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles[0].id == _myId;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['Other']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles[0].id != _myId;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['Groups']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles.length > 1;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['No']) {
  //       f = f && (element.responsible == null || element.responsibles.isEmpty);
  //     }
  //     return f;
  //   }).toList();

  //   suitableTasksCount.value = filteredTaskList.length;
  // }

  void filter() async {
    var _tasksController = Get.find<TasksController>();
    _tasksController.tasks.value = filteredTaskList;
  }
}
