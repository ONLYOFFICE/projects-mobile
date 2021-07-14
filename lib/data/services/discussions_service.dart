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

import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsService {
  final DiscussionsApi _api = locator<DiscussionsApi>();

  Future<PageDTO<List<Discussion>>> getDiscussionsByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String authorFilter,
    String statusFilter,
    String projectFilter,
    String projectId,
    String creationDateFilter,
    String otherFilter,
  }) async {
    var projects = await _api.getDiscussionsByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      authorFilter: authorFilter,
      statusFilter: statusFilter,
      creationDateFilter: creationDateFilter,
      projectFilter: projectFilter,
      otherFilter: otherFilter,
      projectId: projectId,
    );

    var success = projects.response != null;

    if (success) {
      return projects;
    } else {
      await ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<Discussion> addMessage({
    int projectId,
    NewDiscussionDTO newDiscussion,
  }) async {
    var result =
        await _api.addMessage(projectId: projectId, newDiss: newDiscussion);

    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
