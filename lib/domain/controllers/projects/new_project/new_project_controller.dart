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

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class NewProjectController extends BaseProjectEditorController {
  final ProjectService _api = locator<ProjectService>();

  NewProjectController() {
    selectionMode = UserSelectionMode.Single;
    titleFocus.requestFocus();
    responsible = '';
  }

  void discardChanges() {
    if (!titleIsEmpty.value ||
        isPMSelected.value ||
        selectedTeamMembers.isNotEmpty ||
        descriptionText.isNotEmpty)
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        acceptColor: Get.theme.colors().colorError,
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    else
      Get.back();
  }

  Future<void> confirm() async {
    titleController.text = titleController.text.trim();
    needToFillTitle.value = titleController.text.isEmpty;

    needToFillManager.value = selectedProjectManager.value?.id == null;

    if (needToFillTitle.value == true || needToFillManager.value == true) {
      unawaited(900.milliseconds.delay().then((value) {
        needToFillTitle.value = false;
        needToFillManager.value = false;
      }));
      return;
    }

    final participants = <Participant>[];

    for (final element in selectedTeamMembers) {
      participants.add(
        Participant(
            iD: element.portalUser.id,
            canReadMessages: true,
            canReadFiles: true,
            canReadTasks: true,
            canReadContacts: true,
            canReadMilestones: true),
      );
    }

    final newProject = NewProjectDTO(
        title: titleController.text,
        description: descriptionController.text,
        responsibleId: selectedProjectManager.value!.id,
        participants: participants,
        private: isPrivate.value,
        notify: notificationEnabled.value,
        notifyResponsibles: responsiblesNotificationEnabled,
        tags: tagsText.value);

    final result = await _api.createProject(project: newProject);
    if (result != null) {
      Get.back();

      locator<EventHub>().fire('needToRefreshProjects', {'all': true});

      MessagesHandler.showSnackBar(
        context: Get.context!,
        text: tr('projectCreated'),
        buttonOnTap: () => Get.find<NavigationController>()
            .to(ProjectDetailedView(), arguments: {'projectDetailed': result}),
        buttonText: tr('open').toUpperCase(),
      );
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  Future<void> showTags() async {
    // ignore: unawaited_futures
    Get.find<NavigationController>().toScreen(
      const TagsSelectionView(),
      arguments: {'controller': this},
      transition: Transition.rightToLeft,
      isRootModalScreenView: false,
    );
  }

  @override
  // TODO: implement projectData
  ProjectDetailed? get projectData => throw UnimplementedError();

  @override
  Future<bool> updateStatus({int? newStatusId}) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }
}
