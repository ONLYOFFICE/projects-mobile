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
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';

abstract class DiscussionActionsController {
  RxString text;
  RxString title;
  var selectedProjectTitle;
  RxList subscribers;

  FocusNode get titleFocus => FocusNode();
  TextEditingController _titleController;
  TextEditingController _userSearchController;
  TextEditingController get titleController => _titleController;
  TextEditingController get userSearchController => _userSearchController;
  Rx<TextEditingController> textController;

  var setTitleError;
  var setTextError;
  var selectProjectError;

  void setupSubscribersSelection();
  void addSubscriber(PortalUserItemController user,
      {fromUsersDataSource = false});

  void changeTitle(String newText);
  void changeProjectSelection();

  void clearUserSearch();
  void confirmText();
  void leaveTextView();
  void confirmSubscribersSelection();
  void leaveSubscribersSelectionView();

  void confirmGroupSelection();
  void selectGroupMembers(PortalGroupItemController group);

  DiscussionActionsController();
}
