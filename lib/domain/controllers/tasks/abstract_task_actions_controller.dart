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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';

abstract class TaskActionsController extends GetxController {
  final title = ''.obs;
  final descriptionText = ''.obs;
  final selectedMilestoneTitle = ''.obs;
  final selectedProjectTitle = ''.obs;
  final responsibles = [].obs;
  final startDateText = ''.obs;
  final dueDateText = ''.obs;
  late ProjectTeamController teamController;
  int? newMilestoneId;

  Rx<TextEditingController> descriptionController = TextEditingController().obs;

  DateTime? get dueDate;

  DateTime? get startDate;

  int? get selectedProjectId;

  final highPriority = false.obs;
  final titleIsEmpty = false.obs;

  TextEditingController? _titleController;

  TextEditingController? get titleController => _titleController;

  FocusNode? get titleFocus => FocusNode();

  final setTitleError = false.obs;
  final needToSelectProject = false.obs;

  void changeMilestoneSelection({int? id, String? title});

  void leaveDescriptionView(String typedText);

  void confirmResponsiblesSelection();

  void leaveResponsiblesSelectionView();

  void confirmDescription(String typedText);

  void changeTitle(String newText);

  void changeStartDate(DateTime? newDate);

  void changeDueDate(DateTime? newDate);

  void changePriority(bool value);

  void checkDate(DateTime startDate, DateTime dueDate);

  void changeProjectSelection(ProjectDetailed? _details);

  void setupResponsibleSelection();

  void addResponsible(PortalUserItemController user);
}
