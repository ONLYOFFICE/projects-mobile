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

class HeaderFilterView extends StatelessWidget {
  const HeaderFilterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Filter',
                  style: TextStyleHelper.h6(
                      color: Theme.of(context).customColors().onSurface))),
          const SizedBox(height: 14.5),
          const Divider(height: 9),
          const _FilterLabel(
              label: 'Responsible',
              padding: EdgeInsets.only(left: 16, bottom: 20.05)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              const _FilterElement(selected: true, title: 'Me'),
              const _FilterElement(title: 'Other user'),
              const _FilterElement(title: 'Groups'),
              _FilterElement(
                  title: 'No responsible',
                  titleColor: Theme.of(context).customColors().onSurface),
            ]),
          ),
          const _FilterLabel(label: 'Creator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Me',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other user'),
            ]),
          ),
          const _FilterLabel(label: 'Project'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'My projects',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other projects'),
              const _FilterElement(title: 'With tag'),
              const _FilterElement(title: 'Without tag'),
            ]),
          ),
          const _FilterLabel(label: 'Milestone'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'Milestones with my tasks',
                  titleColor: Theme.of(context).customColors().onSurface),
              _FilterElement(
                  title: 'No milestone',
                  titleColor: Theme.of(context).customColors().onSurface),
              const _FilterElement(title: 'Other milestones'),
            ]),
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  const _FilterLabel({
    Key key,
    this.label,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ??
            const EdgeInsets.only(left: 16, top: 36.5, bottom: 20.05),
        child: Text(label,
            style: TextStyleHelper.h6(
                color: Theme.of(context).customColors().onSurface)));
  }
}

class _FilterElement extends StatelessWidget {
  final bool selected;
  final String title;
  final Color titleColor;
  const _FilterElement(
      {Key key, this.selected = false, this.title, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD8D8D8), width: 0.5),
        borderRadius: BorderRadius.circular(16),
        color: selected
            ? Theme.of(context).customColors().primary
            : Theme.of(context).customColors().bgDescription,
      ),
      child: Text(
        title,
        style: TextStyleHelper.body2(
            color: selected
                ? Theme.of(context).customColors().onPrimarySurface
                : titleColor ?? Theme.of(context).customColors().primary),
      ),
    );
  }
}
