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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class SearchField extends StatefulWidget {
  final bool autofocus;
  final bool alwaysShowSuffixIcon;
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

  const SearchField({
    Key? key,
    this.autofocus = false,
    this.color,
    this.controller,
    this.height = 32,
    this.hintText,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
    this.onChanged,
    this.onClearPressed,
    this.onSubmitted,
    this.onSuffixTap,
    this.alwaysShowSuffixIcon = false,
    this.suffixIcon,
    this.width,
    this.textInputAction = TextInputAction.search,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  var showClearButton = false;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colors().onSurface.withOpacity(0.4);
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      child: PlatformWidget(
        cupertino: (_, __) {
          return CupertinoSearchTextField(
            style: TextStyle(color: Theme.of(context).colors().onBackground),
            placeholder: widget.hintText,
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            autofocus: widget.autofocus,
            prefixInsets: const EdgeInsetsDirectional.fromSTEB(6, 1, 0, 4),
            padding: const EdgeInsetsDirectional.fromSTEB(3.8, 6, 5, 8),
            suffixMode: widget.alwaysShowSuffixIcon
                ? OverlayVisibilityMode.always
                : OverlayVisibilityMode.editing,
            onSuffixTap: widget.onClearPressed ?? widget.onSuffixTap,
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
              fillColor: widget.color ?? Theme.of(context).colors().bgDescription,
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
              suffixIcon: showClearButton || widget.alwaysShowSuffixIcon
                  ? _ClearButton(
                      suffixIcon: widget.suffixIcon,
                      onTap: () {
                        widget.onClearPressed?.call();
                        setState(() {
                          showClearButton = false;
                        });
                      },
                    )
                  : const SizedBox(),
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
    required this.suffixIcon,
    required this.onTap,
  }) : super(key: key);

  final Widget? suffixIcon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colors().onSurface.withOpacity(0.4);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 32,
        width: 32,
        child: suffixIcon ??
            Icon(
              Icons.clear_rounded,
              color: onSurfaceColor,
            ),
      ),
    );
  }
}
