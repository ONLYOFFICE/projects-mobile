/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDynamicColor, CupertinoTextField, OverlayVisibilityMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show InputDecoration, TextField, InputCounterWidgetBuilder;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show Brightness, TextInputFormatter, TextInputType, TextInputAction, TextCapitalization;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'platform.dart';
import 'widget_base.dart';

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
  width: 0.0,
);

const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

const BoxDecoration kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

class MaterialTextFieldData {
  MaterialTextFieldData({
    this.widgetKey,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.style,
    this.textAlign,
    this.textDirection,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.onTap,
    this.buildCounter,
    this.dragStartBehavior,
    this.expands,
    this.minLines,
    this.scrollPhysics,
    this.strutStyle,
    this.scrollController,
    this.readOnly,
    this.showCursor,
    this.textAlignVertical,
    this.toolbarOptions,
    this.enableSuggestions,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.obscuringCharacter,
    this.autofillHints,
    this.mouseCursor,
    this.onAppPrivateCommand,
    this.cursorHeight,
    this.restorationId,
    this.maxLengthEnforcement,
    this.selectionControls,
    this.enableIMEPersonalizedLearning,
  });

  final Key? widgetKey;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? autofocus;
  final bool? obscureText;
  final bool? autocorrect;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool? enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final DragStartBehavior? dragStartBehavior;
  final bool? expands;
  final int? minLines;
  final ScrollPhysics? scrollPhysics;
  final StrutStyle? strutStyle;
  final ScrollController? scrollController;
  final bool? readOnly;
  final bool? showCursor;
  final TextAlignVertical? textAlignVertical;
  final ToolbarOptions? toolbarOptions;
  final bool? enableSuggestions;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final String? obscuringCharacter;
  final Iterable<String>? autofillHints;
  final MouseCursor? mouseCursor;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final double? cursorHeight;
  final String? restorationId;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextSelectionControls? selectionControls;
  final bool? enableIMEPersonalizedLearning;
}

class CupertinoTextFieldData {
  CupertinoTextFieldData({
    this.widgetKey,
    this.controller,
    this.focusNode,
    this.decoration,
    this.padding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode,
    this.suffix,
    this.suffixMode,
    this.clearButtonMode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.style,
    this.textAlign,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.dragStartBehavior,
    this.expands,
    this.minLines,
    this.scrollPhysics,
    this.strutStyle,
    this.enableInteractiveSelection,
    this.scrollController,
    this.readOnly,
    this.showCursor,
    this.textAlignVertical,
    this.toolbarOptions,
    this.onTap,
    this.enableSuggestions,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.obscuringCharacter,
    this.autofillHints,
    this.cursorHeight,
    this.restorationId,
    this.maxLengthEnforcement,
    this.selectionControls,
    this.enableIMEPersonalizedLearning,
    this.textDirection,
  });

  final Key? widgetKey;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? prefix;
  final OverlayVisibilityMode? prefixMode;
  final Widget? suffix;
  final OverlayVisibilityMode? suffixMode;
  final OverlayVisibilityMode? clearButtonMode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? autofocus;
  final bool? obscureText;
  final bool? autocorrect;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final DragStartBehavior? dragStartBehavior;
  final bool? expands;
  final int? minLines;
  final ScrollPhysics? scrollPhysics;
  final StrutStyle? strutStyle;
  final bool? enableInteractiveSelection;
  final ScrollController? scrollController;
  final bool? readOnly;
  final bool? showCursor;
  final TextAlignVertical? textAlignVertical;
  final ToolbarOptions? toolbarOptions;
  final GestureTapCallback? onTap;
  final bool? enableSuggestions;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final String? obscuringCharacter;
  final Iterable<String>? autofillHints;
  final double? cursorHeight;
  final String? restorationId;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextSelectionControls? selectionControls;
  final bool? enableIMEPersonalizedLearning;
  final TextDirection? textDirection;
}

class PlatformTextField extends PlatformWidgetBase<CupertinoTextField, TextField> {
  final Key? widgetKey;

  final PlatformBuilder<MaterialTextFieldData>? material;
  final PlatformBuilder<CupertinoTextFieldData>? cupertino;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;

  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? autofocus;
  final bool? obscureText;
  final bool? autocorrect;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final DragStartBehavior? dragStartBehavior;
  final bool? expands;
  final int? minLines;
  final ScrollPhysics? scrollPhysics;
  final StrutStyle? strutStyle;
  final bool? enableInteractiveSelection;
  final ScrollController? scrollController;
  final GestureTapCallback? onTap;
  final bool? readOnly;
  final bool? showCursor;
  final TextAlignVertical? textAlignVertical;
  final ToolbarOptions? toolbarOptions;

  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;

  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;

  final String? obscuringCharacter;
  final Iterable<String>? autofillHints;

  final double? cursorHeight;
  final String? restorationId;
  final MaxLengthEnforcement? maxLengthEnforcement;

  final TextSelectionControls? selectionControls;

  final bool makeCupertinoDecorationNull;

  final String? hintText;

  final bool? enableIMEPersonalizedLearning;

  final InputDecoration? decoration;

  PlatformTextField({
    Key? key,
    this.widgetKey,
    this.controller,
    this.focusNode,
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.dragStartBehavior,
    this.minLines,
    this.expands,
    this.scrollPhysics,
    this.strutStyle,
    this.enableInteractiveSelection,
    this.scrollController,
    this.onTap,
    this.readOnly,
    this.showCursor,
    this.textAlignVertical,
    this.toolbarOptions,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.obscuringCharacter,
    this.autofillHints,
    this.cursorHeight,
    this.restorationId,
    this.maxLengthEnforcement,
    this.selectionControls,
    this.hintText,
    this.enableIMEPersonalizedLearning,
    this.makeCupertinoDecorationNull = true,
    this.decoration,
    this.material,
    this.cupertino,
  })  : keyboardType =
            keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        super(key: key);

  @override
  TextField createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    final hintText = this.hintText;
    final decoration = this.decoration ??
        (hintText == null
            ? (data?.decoration ?? const InputDecoration())
            : _inputDecorationWithHint(
                hintText,
                data?.decoration ?? const InputDecoration(),
              ));

    return TextField(
      key: data?.widgetKey ?? widgetKey,
      autocorrect: data?.autocorrect ?? autocorrect ?? true,
      autofocus: data?.autofocus ?? autofocus ?? false,
      controller: data?.controller ?? controller,
      cursorColor: data?.cursorColor ?? cursorColor,
      cursorRadius: data?.cursorRadius ?? cursorRadius,
      cursorWidth: data?.cursorWidth ?? cursorWidth ?? 2.0,
      enabled: data?.enabled ?? enabled,
      focusNode: data?.focusNode ?? focusNode,
      inputFormatters: data?.inputFormatters ?? inputFormatters,
      keyboardAppearance: data?.keyboardAppearance ?? keyboardAppearance,
      keyboardType: data?.keyboardType ?? keyboardType,
      maxLength: data?.maxLength ?? maxLength,
      maxLines: data?.maxLines ?? maxLines,
      obscureText: data?.obscureText ?? obscureText ?? false,
      onChanged: data?.onChanged ?? onChanged,
      onEditingComplete: data?.onEditingComplete ?? onEditingComplete,
      onSubmitted: data?.onSubmitted ?? onSubmitted,
      scrollPadding: data?.scrollPadding ?? scrollPadding ?? const EdgeInsets.all(20),
      style: data?.style ?? style,
      textAlign: data?.textAlign ?? textAlign ?? TextAlign.start,
      textCapitalization: data?.textCapitalization ?? textCapitalization ?? TextCapitalization.none,
      textInputAction: data?.textInputAction ?? textInputAction,
      decoration: decoration,
      textDirection: data?.textDirection,
      buildCounter: data?.buildCounter,
      dragStartBehavior: data?.dragStartBehavior ?? dragStartBehavior ?? DragStartBehavior.start,
      expands: data?.expands ?? expands ?? false,
      minLines: data?.minLines ?? minLines,
      scrollPhysics: data?.scrollPhysics ?? scrollPhysics,
      strutStyle: data?.strutStyle ?? strutStyle,
      enableInteractiveSelection:
          data?.enableInteractiveSelection ?? enableInteractiveSelection ?? true,
      scrollController: data?.scrollController ?? scrollController,
      onTap: data?.onTap ?? onTap,
      readOnly: data?.readOnly ?? readOnly ?? false,
      showCursor: data?.showCursor ?? showCursor,
      textAlignVertical: data?.textAlignVertical ?? textAlignVertical,
      toolbarOptions: data?.toolbarOptions ?? toolbarOptions,
      enableSuggestions: data?.enableSuggestions ?? true,
      smartQuotesType: data?.smartQuotesType ?? smartQuotesType,
      smartDashesType: data?.smartDashesType ?? smartDashesType,
      selectionHeightStyle:
          data?.selectionHeightStyle ?? selectionHeightStyle ?? ui.BoxHeightStyle.tight,
      selectionWidthStyle:
          data?.selectionWidthStyle ?? selectionWidthStyle ?? ui.BoxWidthStyle.tight,
      obscuringCharacter: data?.obscuringCharacter ?? obscuringCharacter ?? '•',
      autofillHints: data?.autofillHints ?? autofillHints,
      mouseCursor: data?.mouseCursor ?? MouseCursor.defer,
      onAppPrivateCommand: data?.onAppPrivateCommand,
      cursorHeight: data?.cursorHeight ?? cursorHeight,
      restorationId: data?.restorationId ?? restorationId,
      maxLengthEnforcement: data?.maxLengthEnforcement ?? maxLengthEnforcement,
      selectionControls: data?.selectionControls ?? selectionControls,
      enableIMEPersonalizedLearning:
          data?.enableIMEPersonalizedLearning ?? enableIMEPersonalizedLearning ?? true,
      //maxLengthEnforced: deprecated
    );
  }

  @override
  CupertinoTextField createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    return CupertinoTextField(
      key: data?.widgetKey ?? widgetKey,
      autocorrect: data?.autocorrect ?? autocorrect ?? true,
      autofocus: data?.autofocus ?? autofocus ?? false,
      controller: data?.controller ?? controller,
      cursorColor: data?.cursorColor ?? cursorColor ?? CupertinoColors.activeBlue,
      cursorRadius: data?.cursorRadius ?? cursorRadius ?? const Radius.circular(2.0),
      cursorWidth: data?.cursorWidth ?? cursorWidth ?? 2.0,
      enabled: data?.enabled ?? enabled,
      focusNode: data?.focusNode ?? focusNode,
      inputFormatters: data?.inputFormatters ?? inputFormatters,
      keyboardAppearance: data?.keyboardAppearance ?? keyboardAppearance,
      keyboardType: data?.keyboardType ?? keyboardType,
      maxLength: data?.maxLength ?? maxLength,
      maxLines: data?.maxLines ?? maxLines,
      obscureText: data?.obscureText ?? obscureText ?? false,
      onChanged: data?.onChanged ?? onChanged,
      onEditingComplete: data?.onEditingComplete ?? onEditingComplete,
      onSubmitted: data?.onSubmitted ?? onSubmitted,
      scrollPadding: data?.scrollPadding ?? scrollPadding ?? const EdgeInsets.all(20.0),
      style: data?.style ?? style,
      textAlign: data?.textAlign ?? textAlign ?? TextAlign.start,
      textCapitalization: data?.textCapitalization ?? textCapitalization ?? TextCapitalization.none,
      textInputAction: data?.textInputAction ?? textInputAction,
      decoration: data?.decoration ??
          (makeCupertinoDecorationNull ? null : kDefaultRoundedBorderDecoration),
      clearButtonMode: data?.clearButtonMode ?? OverlayVisibilityMode.never,
      padding: data?.padding ?? const EdgeInsets.all(6.0),
      placeholder: data?.placeholder ?? hintText,
      placeholderStyle: data?.placeholderStyle ??
          const TextStyle(
            fontWeight: FontWeight.w400,
            color: CupertinoColors.placeholderText,
          ),
      prefix: data?.prefix,
      prefixMode: data?.prefixMode ?? OverlayVisibilityMode.always,
      suffix: data?.suffix,
      suffixMode: data?.suffixMode ?? OverlayVisibilityMode.always,
      dragStartBehavior: data?.dragStartBehavior ?? dragStartBehavior ?? DragStartBehavior.start,
      expands: data?.expands ?? expands ?? false,
      minLines: data?.minLines ?? minLines,
      scrollPhysics: data?.scrollPhysics ?? scrollPhysics,
      strutStyle: data?.strutStyle ?? strutStyle,
      enableInteractiveSelection:
          data?.enableInteractiveSelection ?? enableInteractiveSelection ?? true,
      scrollController: data?.scrollController ?? scrollController,
      onTap: data?.onTap ?? onTap,
      readOnly: data?.readOnly ?? readOnly ?? false,
      showCursor: data?.showCursor ?? showCursor,
      textAlignVertical: data?.textAlignVertical ?? textAlignVertical,
      toolbarOptions: data?.toolbarOptions ?? toolbarOptions,
      enableSuggestions: data?.enableSuggestions ?? true,
      smartQuotesType: data?.smartQuotesType ?? smartQuotesType,
      smartDashesType: data?.smartDashesType ?? smartDashesType,
      selectionHeightStyle:
          data?.selectionHeightStyle ?? selectionHeightStyle ?? ui.BoxHeightStyle.tight,
      selectionWidthStyle:
          data?.selectionWidthStyle ?? selectionWidthStyle ?? ui.BoxWidthStyle.tight,
      obscuringCharacter: data?.obscuringCharacter ?? obscuringCharacter ?? '•',
      autofillHints: data?.autofillHints ?? autofillHints,
      cursorHeight: data?.cursorHeight ?? cursorHeight,
      restorationId: data?.restorationId ?? restorationId,
      maxLengthEnforcement: data?.maxLengthEnforcement ?? maxLengthEnforcement,
      selectionControls: data?.selectionControls ?? selectionControls,
      enableIMEPersonalizedLearning:
          data?.enableIMEPersonalizedLearning ?? enableIMEPersonalizedLearning ?? true,
      textDirection: data?.textDirection,
      //maxLengthEnforced: deprecated
    );
  }

  InputDecoration _inputDecorationWithHint(
    String hintText,
    InputDecoration inputDecoration,
  ) {
    return inputDecoration.copyWith(
      hintText: inputDecoration.hintText ?? hintText,
    );
  }
}
