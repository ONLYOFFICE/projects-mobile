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
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/project_detailed/project_edit_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/description_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';

class ProjectDescriptionTile extends StatefulWidget {
  final controller;
  ProjectDescriptionTile({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  _ProjectDescriptionTileState createState() => _ProjectDescriptionTileState();
}

class _ProjectDescriptionTileState extends State<ProjectDescriptionTile>
    with TickerProviderStateMixin {
  late bool _isExpanded;

  late AnimationController _animationController;

  final Animatable<double> _halfTween = Tween<double>(begin: 0, end: 0.245);
  final Animatable<double> _turnsTween = CurveTween(curve: Curves.easeIn);

  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _iconTurns = _animationController.drive(_halfTween.chain(_turnsTween));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    final double? _height = _isExpanded ? null : 61;

    void changeExpansion() {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }

    return Obx(
      () {
        // ignore: omit_local_variable_types
        final bool _isNotEmpty = widget.controller.descriptionText.value.isNotEmpty as bool;
        final _color = _isNotEmpty
            ? Theme.of(context).colors().onBackground.withOpacity(0.75)
            : Theme.of(context).colors().onBackground.withOpacity(0.4);
        final text = widget.controller.descriptionText.value as String;
        final textSize = TextUtils.getTextSize(text, TextStyleHelper.subtitle1());

        return InkWell(
          onTap: () => Get.find<NavigationController>().toScreen(
            const NewProjectDescription(),
            arguments: {
              'controller': widget.controller,
              'previousPage': widget.controller is NewProjectController
                  ? NewProject.pageName
                  : EditProjectView.pageName,
            },
            transition: Transition.rightToLeft,
            page: '/NewProjectDescription',
          ),
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                // vsync: this,
                child: SizedBox(
                  height: _height,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 72, child: AppIcon(icon: SvgIcons.description, color: _color)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: _isNotEmpty ? 10 : 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isNotEmpty)
                                Text('${tr('description')}:',
                                    style: TextStyleHelper.caption(
                                        color: Theme.of(context)
                                            .colors()
                                            .onBackground
                                            .withOpacity(0.75))),
                              Flexible(
                                child: Text(_isNotEmpty ? text : tr('addDescription'),
                                    style: _isNotEmpty
                                        ? TextStyleHelper.subtitle1(
                                            color: Theme.of(context).colors().onBackground)
                                        : TextStyleHelper.subtitle1(color: _color)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_needToExpand(textSize.width, text))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 6),
                              child: PlatformIconButton(
                                padding: EdgeInsets.zero,
                                icon: RotationTransition(
                                  turns: _iconTurns,
                                  child: Icon(
                                    PlatformIcons(context).rightChevron,
                                    size: 24,
                                    color: Theme.of(context).colors().onBackground.withOpacity(0.6),
                                  ),
                                ),
                                onPressed: changeExpansion,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const StyledDivider(leftPadding: 72),
            ],
          ),
        );
      },
    );
  }
}

bool _needToExpand(double size, String text) {
  final freeSize = Get.width - 72 - 59;
  if ('\n'.allMatches(text).length + 1 > 1) return true;
  if (freeSize > size) return false;
  return true;
}
