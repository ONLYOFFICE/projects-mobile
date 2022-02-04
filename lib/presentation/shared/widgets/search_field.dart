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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';

class SearchField extends StatefulWidget {
  final bool autofocus;
  final bool showClearIcon;
  final Color? color;
  final double? width;
  final double height;
  final String? hintText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry margin;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final Function()? onSuffixTap;
  final Function()? onClearPressed;
  final TextInputAction? textInputAction;

  const SearchField(
      {Key? key,
      this.autofocus = false,
      this.color,
      this.controller,
      this.height = 32,
      this.hintText,
      this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 4),
      this.onChanged,
      this.onClearPressed,
      this.onSubmitted,
      this.onSuffixTap,
      this.showClearIcon = false,
      this.suffixIcon,
      this.width,
      this.textInputAction = TextInputAction.search})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  var showClearButton = false;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Get.theme.colors().onSurface.withOpacity(0.4);
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      child: PlatformWidget(
        cupertino: (_, __) {
          return CupertinoSearchTextField(
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            autofocus: widget.autofocus,
          );
        },
        material: (_, __) {
          return TextField(
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            onChanged: (value) {
              if (!showClearButton && value.isNotEmpty) {
                setState(() {
                  showClearButton = true;
                });
              }
              if (showClearButton && value.isEmpty) {
                setState(() {
                  showClearButton = false;
                });
              }
              widget.onChanged?.call(value);
            },
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true,
              fillColor: widget.color ?? Get.theme.colors().bgDescription,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              labelStyle: TextStyleHelper.body2(color: onSurfaceColor),
              hintStyle: TextStyleHelper.body2(color: onSurfaceColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 16, height: 20),
                  Icon(
                    Icons.search,
                    size: 20,
                    color: onSurfaceColor,
                  ),
                  const SizedBox(width: 8, height: 20),
                ],
              ),
              prefixIconConstraints: BoxConstraints.tight(const Size(44, 20)),
              suffixIcon: widget.showClearIcon
                  ? _ClearButton(
                      widget: widget,
                      showClearButton: showClearButton,
                      onTap: () {
                        widget.onClearPressed?.call();
                        setState(() {
                          showClearButton = false;
                        });
                      },
                    )
                  : GestureDetector(
                      onTap: widget.onSuffixTap,
                      child: SizedBox(height: 32, child: widget.suffixIcon),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    Key? key,
    required this.widget,
    required this.showClearButton,
    required this.onTap,
  }) : super(key: key);

  final SearchField widget;
  final bool showClearButton;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Get.theme.colors().onSurface.withOpacity(0.4);
    return showClearButton
        ? GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(
                Icons.clear_rounded,
                color: onSurfaceColor,
              ),
            ))
        : const SizedBox.shrink();
  }
}
