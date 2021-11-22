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
import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class MilestoneService {
  final MilestoneApi? _api = locator<MilestoneApi>();
  final SecureStorage? _secureStorage = locator<SecureStorage>();

  Future<List<Milestone>?> milestonesByFilter({
    int? startIndex,
    String? sortBy,
    String? sortOrder,
    String? projectId,
    String? milestoneResponsibleFilter,
    String? taskResponsibleFilter,
    String? statusFilter,
    String? deadlineFilter,
    String? query,
  }) async {
    var milestones = await _api!.milestonesByFilter(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      query: query,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones.response;
    } else {
      await Get.find<ErrorDialog>().show(milestones.error!.message!);
      return null;
    }
  }

  Future<PageDTO<List<Milestone>>?> milestonesByFilterPaginated({
    int? startIndex,
    String? sortBy,
    String? sortOrder,
    String? projectId,
    String? milestoneResponsibleFilter,
    String? taskResponsibleFilter,
    String? statusFilter,
    String? deadlineFilter,
    String? query,
  }) async {
    var milestones = await _api!.milestonesByFilterPaginated(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      query: query,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones;
    } else {
      await Get.find<ErrorDialog>().show(milestones.error!.message!);
      return null;
    }
  }

  Future<bool> createMilestone(
      {int? projectId, required NewMilestoneDTO milestone}) async {
    var result = await _api!.createMilestone(
      projectId: projectId,
      milestone: milestone,
    );

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.milestone
      });
      return success;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return false;
    }
  }
}
