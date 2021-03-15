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

import 'package:flutter/material.dart';

import 'package:only_office_mobile/data/models/project_detailed.dart';
import 'package:only_office_mobile/presentation/shared/svg_manager.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';

class ProjectItem extends StatelessWidget {
  final ProjectDetailed project;
  const ProjectItem({this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            padding: const EdgeInsets.all(16),
            child: SVG.createSized(
                'lib/assets/images/icons/project_icon.svg', 40, 40),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProjectTitle(project: project),
                      const SizedBox(width: 16),
                      ProjectSubtitle(project: project),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectTitle extends StatelessWidget {
  const ProjectTitle({
    Key key,
    @required this.project,
  }) : super(key: key);

  final ProjectDetailed project;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              project.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.projectTitle,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/project_statuses/pause.svg', 16, 16),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '•',
                  style: TextStyleHelper.projectResponsible,
                ),
              ),
              Text(
                project.responsible.displayName,
                style: TextStyleHelper.projectResponsible,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectSubtitle extends StatelessWidget {
  const ProjectSubtitle({
    Key key,
    @required this.project,
  }) : super(key: key);

  final ProjectDetailed project;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            project.createdDate(),
            style: TextStyleHelper.projectDate,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/check_round.svg', 20, 20),
              Text(
                project.taskCount.toString(),
                style: TextStyleHelper.projectCompleatetTasks,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
