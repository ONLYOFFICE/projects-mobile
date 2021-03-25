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
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/task_detailed/readmore.dart';

part 'task.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Task(),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.project,
                color: const Color(0xff707070)
              ),
              caption: 'Project:',
              subtitle: 'DEP Product Engineering',
              subtitleStyle: TextStyleHelper.subtitle1.copyWith(
                  color: Theme.of(context).customColors().links
              ),
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.milestone,
                color: const Color(0xff707070)
              ),
              caption: 'Milestone:', 
              subtitle: 'ONLYOFFICE Control Panel',
              subtitleStyle: TextStyleHelper.subtitle1.copyWith(
                  color: Theme.of(context).customColors().links
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 32, top: 42, bottom: 42),
              child: ReadMoreText(
                text,
                trimLines: 3,
                colorClickableText: Colors.pink,
                style: TextStyleHelper.body1,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyleHelper.body2.copyWith(
                  color: Theme.of(context).customColors().links
                ),
              ),
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.start_date,
                color: const Color(0xff707070)
              ),
              caption: 'Start date:', subtitle: 'March, 25th'),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.due_date,
                color: const Color(0xff707070)
              ),
              caption: 'Due date:', subtitle: 'March, 30th'),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.priority,
                color: const Color(0xffff7793)
              ),
              caption: 'Priority:', subtitle: 'High'
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.person,
                color: const Color(0xff707070)
              ),
              caption: 'Assigned to:', subtitle: '2 responsibles'
            ),
            const SizedBox(height: 20),
            const InfoTile(caption: 'Created by:', subtitle: 'S. Leushkin'),
            const SizedBox(height: 20),
            const InfoTile(caption: 'Creation date:', subtitle: '21 Mar 2021'),
            const SizedBox(height: 110)
          ],
        ),
      ),
    );
  }
}

String text = 'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m... Show more';


class InfoTile extends StatelessWidget {
  
  final Widget icon;
  final String caption;
  final String subtitle;
  final TextStyle captionStyle; 
  final TextStyle subtitleStyle; 

  const InfoTile({
    Key key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle = TextStyleHelper.subtitle1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: icon
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caption, style: captionStyle ?? TextStyleHelper.caption),
              Text(subtitle, style: subtitleStyle)
            ],
          )
        ],
      ),
    );
  }
}