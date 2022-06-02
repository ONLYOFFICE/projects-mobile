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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/discussions/actions/discussion_editing_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_project_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_subscribers_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_text_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_title_text_field.dart';

class DiscussionEditingScreen extends StatelessWidget {
  const DiscussionEditingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discussion = Get.arguments['discussion'] as Discussion;

    final controller = Get.put(
      DiscussionEditingController(
        id: discussion.id!,
        title: discussion.title!,
        text: discussion.text!,
        projectId: discussion.project!.id!,
        selectedProjectTitle: discussion.project!.title!,
        initialSubscribers: discussion.subscribers ?? <PortalUser>[],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        controller.discardDiscussion();
        return false;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: tr('editDiscussion'),
          leadingWidth: GetPlatform.isIOS
              ? TextUtils.getTextWidth(
                    tr('cancel').toLowerCase().capitalizeFirst!,
                    TextStyleHelper.button(),
                  ) +
                  16
              : null,
          centerTitle: !GetPlatform.isAndroid,
          actions: [
            PlatformWidget(
              material: (_, __) => IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: () => controller.confirm(context),
              ),
              cupertino: (_, __) => CupertinoButton(
                onPressed: () => controller.confirm(context),
                padding: const EdgeInsets.only(right: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('done'),
                  style: TextStyleHelper.headline7(),
                ),
              ),
            )
          ],
          leading: PlatformWidget(
            cupertino: (_, __) => CupertinoButton(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              onPressed: controller.discardDiscussion,
              child: Text(
                tr('cancel').toLowerCase().capitalizeFirst!,
                style: TextStyleHelper.button(),
              ),
            ),
            material: (_, __) => IconButton(
              onPressed: controller.discardDiscussion,
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DiscussionTitleTextField(controller: controller),
              const StyledDivider(leftPadding: 72.5),
              Listener(
                onPointerDown: (_) {
                  if (controller.title.isNotEmpty && controller.titleFocus.hasFocus)
                    controller.titleFocus.unfocus();
                },
                child: Column(
                  children: [
                    DiscussionTextTile(controller: controller),
                    DiscussionProjectTile(ignoring: true, controller: controller),
                    DiscussionSubscribersTile(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
