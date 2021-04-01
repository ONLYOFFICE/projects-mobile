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
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksSortController extends GetxController {
  var currentSort = 'Deadline+'.obs;

  final _taskController = Get.find<TasksController>();

  Future<void> sortTasks() async {
    print(currentSort.value);
    _taskController.loaded.value = false;
    switch (currentSort.value) {
      case 'Deadline+':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => a.title.compareTo(b.title));
        break;
      case 'Deadline-':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => b.title.compareTo(a.title));
        break;
      case 'Priority+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Priority-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Creation date+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.created.compareTo(b.created));
        break;
      case 'Creation date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.created.compareTo(a.created));
        break;
      case 'Start date+':
        _taskController.tasks.sort((PortalTask a, PortalTask b) {
          return a.startDate.compareTo(b.startDate);
        });
        break;
      case 'Start date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.startDate.compareTo(a.startDate));
        break;
      case 'Title+':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => a.title.compareTo(b.title));
        break;
      case 'Title-':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => b.title.compareTo(a.title));
        break;
      case 'Order+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Order-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      default:
    }
    _taskController.loaded.value = true;
  }

  void changeCurrentSort(String newSort) {
    if (currentSort.value.startsWith(newSort)) {
      currentSort.value.endsWith('+') ? newSort += '-' : newSort += '+';
    } else {
      newSort += '+';
    }
    currentSort.value = newSort;
    sortTasks();
  }
}
