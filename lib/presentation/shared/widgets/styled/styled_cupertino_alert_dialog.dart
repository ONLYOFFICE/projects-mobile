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

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/*
Copy from flutter/lib/src/cupertino/dialog.dart

Changes:
 custom divider color [_dividerColor]
 custom dialog color [_kDialogColor]

 */

Color _dividerColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.systemGrey5.withOpacity(0.6),
  darkColor: CupertinoColors.inactiveGray.withOpacity(0.8),
);

// Generic constants shared between Dialog and ActionSheet.
const double _kDividerThickness = 1;

// A translucent color that is painted on top of the blurred backdrop as the
// dialog's background color
// Extracted from https://developer.apple.com/design/resources/.
const Color _kDialogColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(237, 237, 237, 0.9),
  darkColor: Color.fromRGBO(37, 37, 37, 0.5),
);

const TextStyle _kCupertinoDialogTitleStyle = TextStyle(
  fontFamily: '.SF UI Display',
  inherit: false,
  fontSize: 17,
  fontWeight: FontWeight.w600,
  height: 1.3,
  letterSpacing: -0.5,
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle _kCupertinoDialogContentStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 13,
  fontWeight: FontWeight.w400,
  height: 1.35,
  letterSpacing: -0.2,
  textBaseline: TextBaseline.alphabetic,
);

// CupertinoActionSheet-specific text styles.

// Dialog specific constants.
// iOS dialogs have a normal display width and another display width that is
// used when the device is in accessibility mode. Each of these widths are
// listed below.
const double _kCupertinoDialogWidth = 270;
const double _kAccessibilityCupertinoDialogWidth = 310;
const double _kDialogEdgePadding = 20;

// ActionSheet specific constants.
const double _kActionSheetEdgeVerticalPadding = 10;

// Translucent light gray that is painted on top of the blurred backdrop as the
// background color of a pressed button.
// Eyeballed from iOS 13 beta simulator.
const Color _kPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFE1E1E1),
  darkColor: Color(0xFF2E2E2E),
);

// Translucent, very light gray that is painted on top of the blurred backdrop
// as the action sheet's background color.
// TODO(LongCatIsLooong): https://github.com/flutter/flutter/issues/39272. Use
// System Materials once we have them.
// Extracted from https://developer.apple.com/design/resources/.
const Color _kActionSheetBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xC7F9F9F9),
  darkColor: Color(0xC7252525),
);

// The gray color used for text that appears in the title area.
// Extracted from https://developer.apple.com/design/resources/.
const Color _kActionSheetContentTextColor = Color(0xFF8F8F8F);

// Translucent gray that is painted on top of the blurred backdrop in the gap
// areas between the content section and actions section, as well as between
// buttons.
// Eye-balled from iOS 13 beta simulator.
const Color _kActionSheetButtonDividerColor = _kActionSheetContentTextColor;

// The alert dialog layout policy changes depending on whether the user is using
// a "regular" font size vs a "large" font size. This is a spectrum. There are
// many "regular" font sizes and many "large" font sizes. But depending on which
// policy is currently being used, a dialog is laid out differently.
//
// Empirically, the jump from one policy to the other occurs at the following text
// scale factors:
// Largest regular scale factor:  1.3529411764705883
// Smallest large scale factor:   1.6470588235294117
//
// The following constant represents a division in text scale factor beyond which
// we want to change how the dialog is laid out.
const double _kMaxRegularTextScaleFactor = 1.4;

// Accessibility mode on iOS is determined by the text scale factor that the
// user has selected.
bool _isInAccessibilityMode(BuildContext context) {
  final data = MediaQuery.maybeOf(context);
  return data != null && data.textScaleFactor > _kMaxRegularTextScaleFactor;
}

class StyledCupertinoAlertDialog extends StatelessWidget {
  /// Creates an iOS-style alert dialog.
  ///
  /// The [actions] must not be null.
  const StyledCupertinoAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions = const <Widget>[],
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically a [Text] widget.
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  ///
  /// Typically this is a list of [CupertinoDialogAction] widgets.
  final List<Widget> actions;

  /// A scroll controller that can be used to control the scrolling of the
  /// [content] in the dialog.
  ///
  /// Defaults to null, and is typically not needed, since most alert messages
  /// are short.
  ///
  /// See also:
  ///
  ///  * [actionScrollController], which can be used for controlling the actions
  ///    section when there are many actions.
  final ScrollController? scrollController;

  ScrollController get _effectiveScrollController => scrollController ?? ScrollController();

  /// A scroll controller that can be used to control the scrolling of the
  /// actions in the dialog.
  ///
  /// Defaults to null, and is typically not needed.
  ///
  /// See also:
  ///
  ///  * [scrollController], which can be used for controlling the [content]
  ///    section when it is long.
  final ScrollController? actionScrollController;

  ScrollController get _effectiveActionScrollController =>
      actionScrollController ?? ScrollController();

  /// {@macro flutter.material.dialog.insetAnimationDuration}
  final Duration insetAnimationDuration;

  /// {@macro flutter.material.dialog.insetAnimationCurve}
  final Curve insetAnimationCurve;

  Widget _buildContent(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final children = <Widget>[
      if (title != null || content != null)
        Flexible(
          flex: 3,
          child: _CupertinoAlertContentSection(
            title: title,
            message: content,
            scrollController: _effectiveScrollController,
            titlePadding: EdgeInsets.only(
              left: _kDialogEdgePadding,
              right: _kDialogEdgePadding,
              bottom: content == null ? _kDialogEdgePadding : 1.0,
              top: _kDialogEdgePadding * textScaleFactor,
            ),
            messagePadding: EdgeInsets.only(
              left: _kDialogEdgePadding,
              right: _kDialogEdgePadding,
              bottom: _kDialogEdgePadding * textScaleFactor,
              top: title == null ? _kDialogEdgePadding : 1.0,
            ),
            titleTextStyle: _kCupertinoDialogTitleStyle.copyWith(
              color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
            ),
            messageTextStyle: _kCupertinoDialogContentStyle.copyWith(
              color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
            ),
          ),
        ),
    ];

    return Container(
      color: CupertinoDynamicColor.resolve(_kDialogColor, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildActions() {
    Widget actionSection = Container(
      height: 0,
    );
    if (actions.isNotEmpty) {
      actionSection = _CupertinoAlertActionSection(
        scrollController: _effectiveActionScrollController,
        children: actions,
      );
    }

    return actionSection;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = CupertinoLocalizations.of(context);
    final isInAccessibilityMode = _isInAccessibilityMode(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.elevated,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          // iOS does not shrink dialog content below a 1.0 scale factor
          textScaleFactor: math.max(textScaleFactor, 1),
        ),
        child: ScrollConfiguration(
          // A CupertinoScrollbar is built-in below.
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets +
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                duration: insetAnimationDuration,
                curve: insetAnimationCurve,
                child: MediaQuery.removeViewInsets(
                  removeLeft: true,
                  removeTop: true,
                  removeRight: true,
                  removeBottom: true,
                  context: context,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: _kDialogEdgePadding),
                      width: isInAccessibilityMode
                          ? _kAccessibilityCupertinoDialogWidth
                          : _kCupertinoDialogWidth,
                      child: CupertinoPopupSurface(
                        isSurfacePainted: false,
                        child: Semantics(
                          namesRoute: true,
                          scopesRoute: true,
                          explicitChildNodes: true,
                          label: localizations.alertDialogLabel,
                          child: _CupertinoDialogRenderWidget(
                            contentSection: _buildContent(context),
                            actionsSection: _buildActions(),
                            dividerColor: _dividerColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// // iOS style layout policy widget for sizing an alert dialog's content section and
// // action button section.
// //
// See [_RenderCupertinoDialog] for specific layout policy details.
class _CupertinoDialogRenderWidget extends RenderObjectWidget {
  const _CupertinoDialogRenderWidget({
    Key? key,
    required this.contentSection,
    required this.actionsSection,
    required this.dividerColor,
    this.isActionSheet = false,
  }) : super(key: key);

  final Widget contentSection;
  final Widget actionsSection;
  final Color dividerColor;
  final bool isActionSheet;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCupertinoDialog(
      dividerThickness: _kDividerThickness / MediaQuery.of(context).devicePixelRatio,
      isInAccessibilityMode: _isInAccessibilityMode(context) && !isActionSheet,
      dividerColor: CupertinoDynamicColor.resolve(dividerColor, context),
      isActionSheet: isActionSheet,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCupertinoDialog renderObject) {
    renderObject
      ..isInAccessibilityMode = _isInAccessibilityMode(context) && !isActionSheet
      ..dividerColor = CupertinoDynamicColor.resolve(dividerColor, context);
  }

  @override
  RenderObjectElement createElement() {
    return _CupertinoDialogRenderElement(this, allowMoveRenderObjectChild: isActionSheet);
  }
}

class _CupertinoDialogRenderElement extends RenderObjectElement {
  _CupertinoDialogRenderElement(_CupertinoDialogRenderWidget widget,
      {this.allowMoveRenderObjectChild = false})
      : super(widget);

  // Whether to allow overridden method moveRenderObjectChild call or default to super.
  // CupertinoActionSheet should default to [super] but CupertinoAlertDialog not.
  final bool allowMoveRenderObjectChild;

  Element? _contentElement;
  Element? _actionsElement;

  @override
  _CupertinoDialogRenderWidget get widget => super.widget as _CupertinoDialogRenderWidget;

  @override
  _RenderCupertinoDialog get renderObject => super.renderObject as _RenderCupertinoDialog;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_contentElement != null) {
      visitor(_contentElement!);
    }
    if (_actionsElement != null) {
      visitor(_actionsElement!);
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _contentElement =
        updateChild(_contentElement, widget.contentSection, _AlertDialogSections.contentSection);
    _actionsElement =
        updateChild(_actionsElement, widget.actionsSection, _AlertDialogSections.actionsSection);
  }

  @override
  void insertRenderObjectChild(RenderObject child, _AlertDialogSections slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, _AlertDialogSections oldSlot, _AlertDialogSections newSlot) {
    if (!allowMoveRenderObjectChild) {
      super.moveRenderObjectChild(child, oldSlot, newSlot);
      return;
    }

    _placeChildInSlot(child, newSlot);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    _contentElement =
        updateChild(_contentElement, widget.contentSection, _AlertDialogSections.contentSection);
    _actionsElement =
        updateChild(_actionsElement, widget.actionsSection, _AlertDialogSections.actionsSection);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _contentElement || child == _actionsElement);
    if (_contentElement == child) {
      _contentElement = null;
    } else {
      assert(_actionsElement == child);
      _actionsElement = null;
    }
    super.forgetChild(child);
  }

  @override
  void removeRenderObjectChild(RenderObject child, _AlertDialogSections slot) {
    assert(child == renderObject.contentSection || child == renderObject.actionsSection);
    if (renderObject.contentSection == child) {
      renderObject.contentSection = null;
    } else {
      assert(renderObject.actionsSection == child);
      renderObject.actionsSection = null;
    }
  }

  void _placeChildInSlot(RenderObject child, _AlertDialogSections slot) {
    switch (slot) {
      case _AlertDialogSections.contentSection:
        renderObject.contentSection = child as RenderBox;
        break;
      case _AlertDialogSections.actionsSection:
        renderObject.actionsSection = child as RenderBox;
        break;
    }
  }
}

//
// // iOS style layout policy for sizing an alert dialog's content section and action
// // button section.
// //
// // The policy is as follows:
// //
// // If all content and buttons fit on screen:
// // The content section and action button section are sized intrinsically and centered
// // vertically on screen.
// //
// // If all content and buttons do not fit on screen, and iOS is NOT in accessibility mode:
// // A minimum height for the action button section is calculated. The action
// // button section will not be rendered shorter than this minimum.  See
// // [_RenderCupertinoDialogActions] for the minimum height calculation.
// //
// // With the minimum action button section calculated, the content section can
// // take up as much space as is available, up to the point that it hits the
// // minimum button height at the bottom.
// //
// // After the content section is laid out, the action button section is allowed
// // to take up any remaining space that was not consumed by the content section.
// //
// // If all content and buttons do not fit on screen, and iOS IS in accessibility mode:
// // The button section is given up to 50% of the available height. Then the content
// // section is given whatever height remains.
class _RenderCupertinoDialog extends RenderBox {
  _RenderCupertinoDialog({
    RenderBox? contentSection,
    RenderBox? actionsSection,
    double dividerThickness = 0.0,
    bool isInAccessibilityMode = false,
    bool isActionSheet = false,
    required Color dividerColor,
  })  : _contentSection = contentSection,
        _actionsSection = actionsSection,
        _dividerThickness = dividerThickness,
        _isInAccessibilityMode = isInAccessibilityMode,
        _isActionSheet = isActionSheet,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  RenderBox? get contentSection => _contentSection;
  RenderBox? _contentSection;

  set contentSection(RenderBox? newContentSection) {
    if (newContentSection != _contentSection) {
      if (_contentSection != null) {
        dropChild(_contentSection!);
      }
      _contentSection = newContentSection;
      if (_contentSection != null) {
        adoptChild(_contentSection!);
      }
    }
  }

  RenderBox? get actionsSection => _actionsSection;
  RenderBox? _actionsSection;

  set actionsSection(RenderBox? newActionsSection) {
    if (newActionsSection != _actionsSection) {
      if (null != _actionsSection) {
        dropChild(_actionsSection!);
      }
      _actionsSection = newActionsSection;
      if (null != _actionsSection) {
        adoptChild(_actionsSection!);
      }
    }
  }

  bool get isInAccessibilityMode => _isInAccessibilityMode;
  bool _isInAccessibilityMode;

  set isInAccessibilityMode(bool newValue) {
    if (newValue != _isInAccessibilityMode) {
      _isInAccessibilityMode = newValue;
      markNeedsLayout();
    }
  }

  bool _isActionSheet;

  bool get isActionSheet => _isActionSheet;

  set isActionSheet(bool newValue) {
    if (newValue != _isActionSheet) {
      _isActionSheet = newValue;
      markNeedsLayout();
    }
  }

  double get _dialogWidth =>
      isInAccessibilityMode ? _kAccessibilityCupertinoDialogWidth : _kCupertinoDialogWidth;

  final double _dividerThickness;
  final Paint _dividerPaint;

  Color get dividerColor => _dividerPaint.color;

  set dividerColor(Color newValue) {
    if (dividerColor == newValue) {
      return;
    }

    _dividerPaint.color = newValue;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (null != contentSection) {
      contentSection!.attach(owner);
    }
    if (null != actionsSection) {
      actionsSection!.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    if (null != contentSection) {
      contentSection!.detach();
    }
    if (null != actionsSection) {
      actionsSection!.detach();
    }
  }

  @override
  void redepthChildren() {
    if (null != contentSection) {
      redepthChild(contentSection!);
    }
    if (null != actionsSection) {
      redepthChild(actionsSection!);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (!isActionSheet && child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    } else if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (contentSection != null) {
      visitor(contentSection!);
    }
    if (actionsSection != null) {
      visitor(actionsSection!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() => <DiagnosticsNode>[
        if (contentSection != null) contentSection!.toDiagnosticsNode(name: 'content'),
        if (actionsSection != null) actionsSection!.toDiagnosticsNode(name: 'actions'),
      ];

  @override
  double computeMinIntrinsicWidth(double height) {
    return isActionSheet ? constraints.minWidth : _dialogWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return isActionSheet ? constraints.maxWidth : _dialogWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final contentHeight = contentSection!.getMinIntrinsicHeight(width);
    final actionsHeight = actionsSection!.getMinIntrinsicHeight(width);
    final hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    var height = contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (isActionSheet && (actionsHeight > 0 || contentHeight > 0)) {
      height -= 2 * _kActionSheetEdgeVerticalPadding;
    }
    if (height.isFinite) {
      return height;
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final contentHeight = contentSection!.getMaxIntrinsicHeight(width);
    final actionsHeight = actionsSection!.getMaxIntrinsicHeight(width);
    final hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    var height = contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (isActionSheet && (actionsHeight > 0 || contentHeight > 0)) {
      height -= 2 * _kActionSheetEdgeVerticalPadding;
    }
    if (height.isFinite) {
      return height;
    }
    return 0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    ).size;
  }

  @override
  void performLayout() {
    final dialogSizes = _performLayout(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    size = dialogSizes.size;

    // Set the position of the actions box to sit at the bottom of the dialog.
    // The content box defaults to the top left, which is where we want it.
    assert(
      (!isActionSheet && actionsSection!.parentData is BoxParentData) ||
          (isActionSheet && actionsSection!.parentData is MultiChildLayoutParentData),
    );
    if (isActionSheet) {
      final actionParentData = actionsSection!.parentData! as MultiChildLayoutParentData;
      actionParentData.offset = Offset(0, dialogSizes.contentHeight + dialogSizes.dividerThickness);
    } else {
      final actionParentData = actionsSection!.parentData! as BoxParentData;
      actionParentData.offset = Offset(0, dialogSizes.contentHeight + dialogSizes.dividerThickness);
    }
  }

  _AlertDialogSizes _performLayout(
      {required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    return isInAccessibilityMode
        ? performAccessibilityLayout(
            constraints: constraints,
            layoutChild: layoutChild,
          )
        : performRegularLayout(
            constraints: constraints,
            layoutChild: layoutChild,
          );
  }

  // When not in accessibility mode, an alert dialog might reduce the space
  // for buttons to just over 1 button's height to make room for the content
  // section.
  _AlertDialogSizes performRegularLayout(
      {required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    final hasDivider = contentSection!.getMaxIntrinsicHeight(computeMaxIntrinsicWidth(0)) > 0.0 &&
        actionsSection!.getMaxIntrinsicHeight(computeMaxIntrinsicWidth(0)) > 0.0;
    final dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final minActionsHeight = actionsSection!.getMinIntrinsicHeight(computeMaxIntrinsicWidth(0));

    final contentSize = layoutChild(
      contentSection!,
      constraints.deflate(EdgeInsets.only(bottom: minActionsHeight + dividerThickness)),
    );

    final actionsSize = layoutChild(
      actionsSection!,
      constraints.deflate(EdgeInsets.only(top: contentSize.height + dividerThickness)),
    );

    final dialogHeight = contentSize.height + dividerThickness + actionsSize.height;

    return _AlertDialogSizes(
      size: isActionSheet
          ? Size(constraints.maxWidth, dialogHeight)
          : constraints.constrain(Size(_dialogWidth, dialogHeight)),
      contentHeight: contentSize.height,
      dividerThickness: dividerThickness,
    );
  }

  // When in accessibility mode, an alert dialog will allow buttons to take
  // up to 50% of the dialog height, even if the content exceeds available space.
  _AlertDialogSizes performAccessibilityLayout(
      {required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    final hasDivider = contentSection!.getMaxIntrinsicHeight(_dialogWidth) > 0.0 &&
        actionsSection!.getMaxIntrinsicHeight(_dialogWidth) > 0.0;
    final dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final maxContentHeight = contentSection!.getMaxIntrinsicHeight(_dialogWidth);
    final maxActionsHeight = actionsSection!.getMaxIntrinsicHeight(_dialogWidth);

    final Size contentSize;
    final Size actionsSize;
    if (maxContentHeight + dividerThickness + maxActionsHeight > constraints.maxHeight) {
      // AlertDialog: There isn't enough room for everything. Following iOS's
      // accessibility dialog layout policy, first we allow the actions to take
      // up to 50% of the dialog height. Second we fill the rest of the
      // available space with the content section.

      actionsSize = layoutChild(
        actionsSection!,
        constraints.deflate(EdgeInsets.only(top: constraints.maxHeight / 2.0)),
      );

      contentSize = layoutChild(
        contentSection!,
        constraints.deflate(EdgeInsets.only(bottom: actionsSize.height + dividerThickness)),
      );
    } else {
      // Everything fits. Give content and actions all the space they want.

      contentSize = layoutChild(
        contentSection!,
        constraints,
      );

      actionsSize = layoutChild(
        actionsSection!,
        constraints.deflate(EdgeInsets.only(top: contentSize.height)),
      );
    }

    // Calculate overall dialog height.
    final dialogHeight = contentSize.height + dividerThickness + actionsSize.height;

    return _AlertDialogSizes(
      size: constraints.constrain(Size(_dialogWidth, dialogHeight)),
      contentHeight: contentSize.height,
      dividerThickness: dividerThickness,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isActionSheet) {
      final contentParentData = contentSection!.parentData! as MultiChildLayoutParentData;
      contentSection!.paint(context, offset + contentParentData.offset);
    } else {
      final contentParentData = contentSection!.parentData! as BoxParentData;
      contentSection!.paint(context, offset + contentParentData.offset);
    }

    final hasDivider = contentSection!.size.height > 0.0 && actionsSection!.size.height > 0.0;
    if (hasDivider) {
      _paintDividerBetweenContentAndActions(context.canvas, offset);
    }

    if (isActionSheet) {
      final actionsParentData = actionsSection!.parentData! as MultiChildLayoutParentData;
      actionsSection!.paint(context, offset + actionsParentData.offset);
    } else {
      final actionsParentData = actionsSection!.parentData! as BoxParentData;
      actionsSection!.paint(context, offset + actionsParentData.offset);
    }
  }

  void _paintDividerBetweenContentAndActions(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + contentSection!.size.height,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (isActionSheet) {
      final contentSectionParentData = contentSection!.parentData! as MultiChildLayoutParentData;
      final actionsSectionParentData = actionsSection!.parentData! as MultiChildLayoutParentData;
      return result.addWithPaintOffset(
            offset: contentSectionParentData.offset,
            position: position,
            hitTest: (BoxHitTestResult result, Offset transformed) {
              assert(transformed == position - contentSectionParentData.offset);
              return contentSection!.hitTest(result, position: transformed);
            },
          ) ||
          result.addWithPaintOffset(
            offset: actionsSectionParentData.offset,
            position: position,
            hitTest: (BoxHitTestResult result, Offset transformed) {
              assert(transformed == position - actionsSectionParentData.offset);
              return actionsSection!.hitTest(result, position: transformed);
            },
          );
    }

    final contentSectionParentData = contentSection!.parentData! as BoxParentData;
    final actionsSectionParentData = actionsSection!.parentData! as BoxParentData;
    return result.addWithPaintOffset(
          offset: contentSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - contentSectionParentData.offset);
            return contentSection!.hitTest(result, position: transformed);
          },
        ) ||
        result.addWithPaintOffset(
          offset: actionsSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - actionsSectionParentData.offset);
            return actionsSection!.hitTest(result, position: transformed);
          },
        );
  }
}

//
class _AlertDialogSizes {
  const _AlertDialogSizes({
    required this.size,
    required this.contentHeight,
    required this.dividerThickness,
  });

  final Size size;
  final double contentHeight;
  final double dividerThickness;
}

//
// // Visual components of an alert dialog that need to be explicitly sized and
// // laid out at runtime.
enum _AlertDialogSections {
  contentSection,
  actionsSection,
}

//
// // The "content section" of a CupertinoAlertDialog.
// //
// // If title is missing, then only content is added.  If content is
// // missing, then only title is added. If both are missing, then it returns
// // a SingleChildScrollView with a zero-sized Container.
class _CupertinoAlertContentSection extends StatelessWidget {
  const _CupertinoAlertContentSection({
    Key? key,
    this.title,
    this.message,
    this.scrollController,
    this.titlePadding,
    this.messagePadding,
    this.titleTextStyle,
    this.messageTextStyle,
    this.additionalPaddingBetweenTitleAndMessage,
  })  : assert(title == null || titlePadding != null && titleTextStyle != null),
        assert(message == null || messagePadding != null && messageTextStyle != null),
        super(key: key);

  // The (optional) title of the dialog is displayed in a large font at the top
  // of the dialog.
  //
  // Typically a Text widget.
  final Widget? title;

  // The (optional) message of the dialog is displayed in the center of the
  // dialog in a lighter font.
  //
  // Typically a Text widget.
  final Widget? message;

  // A scroll controller that can be used to control the scrolling of the
  // content in the dialog.
  //
  // Defaults to null, and is typically not needed, since most alert contents
  // are short.
  final ScrollController? scrollController;

  // Paddings used around title and message.
  // CupertinoAlertDialog and CupertinoActionSheet have different paddings.
  final EdgeInsets? titlePadding;
  final EdgeInsets? messagePadding;

  // Additional padding to be inserted between title and message.
  // Only used for CupertinoActionSheet.
  final EdgeInsets? additionalPaddingBetweenTitleAndMessage;

  // Text styles used for title and message.
  // CupertinoAlertDialog and CupertinoActionSheet have different text styles.
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null && message == null) {
      return SingleChildScrollView(
        controller: scrollController,
        child: const SizedBox(width: 0, height: 0),
      );
    }

    final titleContentGroup = <Widget>[
      if (title != null)
        Padding(
          padding: titlePadding!,
          child: DefaultTextStyle(
            style: titleTextStyle!,
            textAlign: TextAlign.center,
            child: title!,
          ),
        ),
      if (message != null)
        Padding(
          padding: messagePadding!,
          child: DefaultTextStyle(
            style: messageTextStyle!,
            textAlign: TextAlign.center,
            child: message!,
          ),
        ),
    ];

    // Add padding between the widgets if necessary.
    if (additionalPaddingBetweenTitleAndMessage != null && titleContentGroup.length > 1) {
      titleContentGroup.insert(1, Padding(padding: additionalPaddingBetweenTitleAndMessage!));
    }

    return CupertinoScrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: titleContentGroup,
        ),
      ),
    );
  }
}

//
// // The "actions section" of a [CupertinoAlertDialog].
// //
// // See [_RenderCupertinoDialogActions] for details about action button sizing
// // and layout.
class _CupertinoAlertActionSection extends StatefulWidget {
  const _CupertinoAlertActionSection({
    Key? key,
    required this.children,
    this.scrollController,
    this.hasCancelButton = false,
    this.isActionSheet = false,
  }) : super(key: key);

  final List<Widget> children;

  // A scroll controller that can be used to control the scrolling of the
  // actions in the dialog.
  //
  // Defaults to null, and is typically not needed, since most alert dialogs
  // don't have many actions.
  final ScrollController? scrollController;

  // Used in ActionSheet to denote if ActionSheet has a separate so-called
  // cancel button.
  //
  // Defaults to false, and is not needed in dialogs.
  final bool hasCancelButton;

  final bool isActionSheet;

  @override
  _CupertinoAlertActionSectionState createState() => _CupertinoAlertActionSectionState();
}

class _CupertinoAlertActionSectionState extends State<_CupertinoAlertActionSection> {
  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final interactiveButtons = <Widget>[];
    for (var i = 0; i < widget.children.length; i += 1) {
      interactiveButtons.add(
        _PressableActionButton(
          child: widget.children[i],
        ),
      );
    }

    return CupertinoScrollbar(
      controller: widget.scrollController,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: _CupertinoDialogActionsRenderWidget(
          actionButtons: interactiveButtons,
          dividerThickness: _kDividerThickness / devicePixelRatio,
          hasCancelButton: widget.hasCancelButton,
          isActionSheet: widget.isActionSheet,
        ),
      ),
    );
  }
}

//
// // Button that updates its render state when pressed.
// //
// // The pressed state is forwarded to an _ActionButtonParentDataWidget. The
// // corresponding _ActionButtonParentData is then interpreted and rendered
// // appropriately by _RenderCupertinoDialogActions.
class _PressableActionButton extends StatefulWidget {
  const _PressableActionButton({
    required this.child,
  });

  final Widget child;

  @override
  _PressableActionButtonState createState() => _PressableActionButtonState();
}

class _PressableActionButtonState extends State<_PressableActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return _ActionButtonParentDataWidget(
      isPressed: _isPressed,
      child: MergeSemantics(
        // TODO(mattcarroll): Button press dynamics need overhaul for iOS:
        // https://github.com/flutter/flutter/issues/19786
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: HitTestBehavior.opaque,
          onTapDown: (TapDownDetails details) => setState(() {
            _isPressed = true;
          }),
          onTapUp: (TapUpDetails details) => setState(() {
            _isPressed = false;
          }),
          // TODO(mattcarroll): Cancel is currently triggered when user moves
          //  past slop instead of off button: https://github.com/flutter/flutter/issues/19783
          onTapCancel: () => setState(() => _isPressed = false),
          child: widget.child,
        ),
      ),
    );
  }
}

//
// // ParentDataWidget that updates _ActionButtonParentData for an action button.
// //
// // Each action button requires knowledge of whether or not it is pressed so that
// // the dialog can correctly render the button. The pressed state is held within
// // _ActionButtonParentData. _ActionButtonParentDataWidget is responsible for
// // updating the pressed state of an _ActionButtonParentData based on the
// // incoming [isPressed] property.
class _ActionButtonParentDataWidget extends ParentDataWidget<_ActionButtonParentData> {
  const _ActionButtonParentDataWidget({
    Key? key,
    required this.isPressed,
    required Widget child,
  }) : super(key: key, child: child);

  final bool isPressed;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _ActionButtonParentData);
    final parentData = renderObject.parentData! as _ActionButtonParentData;
    if (parentData.isPressed != isPressed) {
      parentData.isPressed = isPressed;

      // Force a repaint.
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsPaint();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _CupertinoDialogActionsRenderWidget;
}

//
// // ParentData applied to individual action buttons that report whether or not
// // that button is currently pressed by the user.
class _ActionButtonParentData extends MultiChildLayoutParentData {
  _ActionButtonParentData({
    this.isPressed = false,
  });

  bool isPressed;
}

// // iOS style dialog action button layout.
// //
// // [_CupertinoDialogActionsRenderWidget] does not provide any scrolling
// // behavior for its buttons. It only handles the sizing and layout of buttons.
// // Scrolling behavior can be composed on top of this widget, if desired.
// //
// // See [_RenderCupertinoDialogActions] for specific layout policy details.
class _CupertinoDialogActionsRenderWidget extends MultiChildRenderObjectWidget {
  _CupertinoDialogActionsRenderWidget({
    Key? key,
    required List<Widget> actionButtons,
    double dividerThickness = 0.0,
    bool hasCancelButton = false,
    bool isActionSheet = false,
  })  : _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        _isActionSheet = isActionSheet,
        super(key: key, children: actionButtons);

  final double _dividerThickness;
  final bool _hasCancelButton;
  final bool _isActionSheet;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCupertinoDialogActions(
      dialogWidth: _isActionSheet
          ? null
          : _isInAccessibilityMode(context)
              ? _kAccessibilityCupertinoDialogWidth
              : _kCupertinoDialogWidth,
      dividerThickness: _dividerThickness,
      dialogColor: CupertinoDynamicColor.resolve(
          _isActionSheet ? _kActionSheetBackgroundColor : _kDialogColor, context),
      dialogPressedColor: CupertinoDynamicColor.resolve(_kPressedColor, context),
      dividerColor: CupertinoDynamicColor.resolve(
          _isActionSheet ? _kActionSheetButtonDividerColor : _dividerColor, context),
      hasCancelButton: _hasCancelButton,
      isActionSheet: _isActionSheet,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCupertinoDialogActions renderObject) {
    renderObject
      ..dialogWidth = _isActionSheet
          ? null
          : _isInAccessibilityMode(context)
              ? _kAccessibilityCupertinoDialogWidth
              : _kCupertinoDialogWidth
      ..dividerThickness = _dividerThickness
      ..dialogColor = CupertinoDynamicColor.resolve(
          _isActionSheet ? _kActionSheetBackgroundColor : _kDialogColor, context)
      ..dialogPressedColor = CupertinoDynamicColor.resolve(_kPressedColor, context)
      ..dividerColor = CupertinoDynamicColor.resolve(
          _isActionSheet ? _kActionSheetButtonDividerColor : _dividerColor, context)
      ..hasCancelButton = _hasCancelButton
      ..isActionSheet = _isActionSheet;
  }
}

//
// // iOS style layout policy for sizing and positioning an alert dialog's action
// // buttons.
// //
// // The policy is as follows:
// //
// // If a single action button is provided, or if 2 action buttons are provided
// // that can fit side-by-side, then action buttons are sized and laid out in a
// // single horizontal row. The row is exactly as wide as the dialog, and the row
// // is as tall as the tallest action button. A horizontal divider is drawn above
// // the button row. If 2 action buttons are provided, a vertical divider is
// // drawn between them. The thickness of the divider is set by [dividerThickness].
// //
// // If 2 action buttons are provided but they cannot fit side-by-side, then the
// // 2 buttons are stacked vertically. A horizontal divider is drawn above each
// // button. The thickness of the divider is set by [dividerThickness]. The minimum
// // height of this [RenderBox] in the case of 2 stacked buttons is as tall as
// // the 2 buttons stacked. This is different than the 3+ button case where the
// // minimum height is only 1.5 buttons tall. See the 3+ button explanation for
// // more info.
// //
// // If 3+ action buttons are provided then they are all stacked vertically. A
// // horizontal divider is drawn above each button. The thickness of the divider
// // is set by [dividerThickness]. The minimum height of this [RenderBox] in the case
// // of 3+ stacked buttons is as tall as the 1st button + 50% the height of the
// // 2nd button. In other words, the minimum height is 1.5 buttons tall. This
// // minimum height of 1.5 buttons is expected to work in tandem with a surrounding
// // [ScrollView] to match the iOS dialog behavior.
// //
// // Each button is expected to have an _ActionButtonParentData which reports
// // whether or not that button is currently pressed. If a button is pressed,
// // then the dividers above and below that pressed button are not drawn - instead
// // they are filled with the standard white dialog background color. The one
// // exception is the very 1st divider which is always rendered. This policy comes
// // from observation of native iOS dialogs.
class _RenderCupertinoDialogActions extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderCupertinoDialogActions({
    List<RenderBox>? children,
    double? dialogWidth,
    double dividerThickness = 0.0,
    required Color dialogColor,
    required Color dialogPressedColor,
    required Color dividerColor,
    bool hasCancelButton = false,
    bool isActionSheet = false,
  })  : assert(isActionSheet || dialogWidth != null),
        _dialogWidth = dialogWidth,
        _buttonBackgroundPaint = Paint()
          ..color = dialogColor
          ..style = PaintingStyle.fill,
        _pressedButtonBackgroundPaint = Paint()
          ..color = dialogPressedColor
          ..style = PaintingStyle.fill,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill,
        _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        _isActionSheet = isActionSheet {
    addAll(children);
  }

  double? get dialogWidth => _dialogWidth;
  double? _dialogWidth;

  set dialogWidth(double? newWidth) {
    if (newWidth != _dialogWidth) {
      _dialogWidth = newWidth;
      markNeedsLayout();
    }
  }

  // The thickness of the divider between buttons.
  double get dividerThickness => _dividerThickness;
  double _dividerThickness;

  set dividerThickness(double newValue) {
    if (newValue != _dividerThickness) {
      _dividerThickness = newValue;
      markNeedsLayout();
    }
  }

  bool _hasCancelButton;

  bool get hasCancelButton => _hasCancelButton;

  set hasCancelButton(bool newValue) {
    if (newValue == _hasCancelButton) return;

    _hasCancelButton = newValue;
    markNeedsLayout();
  }

  Color get dialogColor => _buttonBackgroundPaint.color;
  final Paint _buttonBackgroundPaint;

  set dialogColor(Color value) {
    if (value == _buttonBackgroundPaint.color) return;

    _buttonBackgroundPaint.color = value;
    markNeedsPaint();
  }

  Color get dialogPressedColor => _pressedButtonBackgroundPaint.color;
  final Paint _pressedButtonBackgroundPaint;

  set dialogPressedColor(Color value) {
    if (value == _pressedButtonBackgroundPaint.color) return;

    _pressedButtonBackgroundPaint.color = value;
    markNeedsPaint();
  }

  Color get dividerColor => _dividerPaint.color;
  final Paint _dividerPaint;

  set dividerColor(Color value) {
    if (value == _dividerPaint.color) return;

    _dividerPaint.color = value;
    markNeedsPaint();
  }

  bool get isActionSheet => _isActionSheet;
  bool _isActionSheet;

  set isActionSheet(bool value) {
    if (value == _isActionSheet) return;

    _isActionSheet = value;
    markNeedsPaint();
  }

  Iterable<RenderBox> get _pressedButtons {
    final boxes = <RenderBox>[];
    var currentChild = firstChild;
    while (currentChild != null) {
      assert(currentChild.parentData is _ActionButtonParentData);
      final parentData = currentChild.parentData! as _ActionButtonParentData;
      if (parentData.isPressed) {
        boxes.add(currentChild);
      }
      currentChild = childAfter(currentChild);
    }
    return boxes;
  }

  bool get _isButtonPressed {
    var currentChild = firstChild;
    while (currentChild != null) {
      assert(currentChild.parentData is _ActionButtonParentData);
      final parentData = currentChild.parentData! as _ActionButtonParentData;
      if (parentData.isPressed) {
        return true;
      }
      currentChild = childAfter(currentChild);
    }
    return false;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ActionButtonParentData) child.parentData = _ActionButtonParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return isActionSheet ? constraints.minWidth : dialogWidth!;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return isActionSheet ? constraints.maxWidth : dialogWidth!;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childCount == 0) {
      return 0;
    } else if (isActionSheet) {
      if (childCount == 1) return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
      if (hasCancelButton && childCount < 4) return _computeMinIntrinsicHeightWithCancel(width);
      return _computeMinIntrinsicHeightStacked(width);
    } else if (childCount == 1) {
      // If only 1 button, display the button across the entire dialog.
      return _computeMinIntrinsicHeightSideBySide(width);
    } else if (childCount == 2 && _isSingleButtonRow(width)) {
      // The first 2 buttons fit side-by-side. Display them horizontally.
      return _computeMinIntrinsicHeightSideBySide(width);
    }
    // 3+ buttons are always stacked. The minimum height when stacked is
    // 1.5 buttons tall.
    return _computeMinIntrinsicHeightStacked(width);
  }

  // The minimum height for more than 2-3 buttons when a cancel button is
  // included is the full height of button stack.
  double _computeMinIntrinsicHeightWithCancel(double width) {
    assert(childCount == 2 || childCount == 3);
    if (childCount == 2) {
      return firstChild!.getMinIntrinsicHeight(width) +
          childAfter(firstChild!)!.getMinIntrinsicHeight(width) +
          dividerThickness;
    }
    return firstChild!.getMinIntrinsicHeight(width) +
        childAfter(firstChild!)!.getMinIntrinsicHeight(width) +
        childAfter(childAfter(firstChild!)!)!.getMinIntrinsicHeight(width) +
        (dividerThickness * 2);
  }

  // The minimum height for a single row of buttons is the larger of the buttons'
  // min intrinsic heights.
  double _computeMinIntrinsicHeightSideBySide(double width) {
    assert(childCount >= 1 && childCount <= 2);

    final double minHeight;
    if (childCount == 1) {
      minHeight = firstChild!.getMinIntrinsicHeight(width);
    } else {
      final perButtonWidth = (width - dividerThickness) / 2.0;
      minHeight = math.max(
        firstChild!.getMinIntrinsicHeight(perButtonWidth),
        lastChild!.getMinIntrinsicHeight(perButtonWidth),
      );
    }
    return minHeight;
  }

  // Dialog: The minimum height for 2+ stacked buttons is the height of the 1st
  // button + 50% the height of the 2nd button + the divider between the two.
  //
  // ActionSheet: The minimum height for more than 2 buttons when no cancel
  // button or 4+ buttons when a cancel button is included is the height of the
  // 1st button + 50% the height of the 2nd button + 2 dividers.
  double _computeMinIntrinsicHeightStacked(double width) {
    assert(childCount >= 2);

    return firstChild!.getMinIntrinsicHeight(width) +
        dividerThickness +
        (0.5 * childAfter(firstChild!)!.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) {
      // No buttons. Zero height.
      return 0;
    } else if (isActionSheet) {
      if (childCount == 1) return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
      return _computeMaxIntrinsicHeightStacked(width);
    } else if (childCount == 1) {
      // One button. Our max intrinsic height is equal to the button's.
      return firstChild!.getMaxIntrinsicHeight(width);
    } else if (childCount == 2) {
      // Two buttons...
      if (_isSingleButtonRow(width)) {
        // The 2 buttons fit side by side so our max intrinsic height is equal
        // to the taller of the 2 buttons.
        final perButtonWidth = (width - dividerThickness) / 2.0;
        return math.max(
          firstChild!.getMaxIntrinsicHeight(perButtonWidth),
          lastChild!.getMaxIntrinsicHeight(perButtonWidth),
        );
      } else {
        // The 2 buttons do not fit side by side. Measure total height as a
        // vertical stack.
        return _computeMaxIntrinsicHeightStacked(width);
      }
    }
    // Three+ buttons. Stack the buttons vertically with dividers and measure
    // the overall height.
    return _computeMaxIntrinsicHeightStacked(width);
  }

  // Max height of a stack of buttons is the sum of all button heights + a
  // divider for each button.
  double _computeMaxIntrinsicHeightStacked(double width) {
    assert(childCount >= 2);

    final allDividersHeight = (childCount - 1) * dividerThickness;
    var heightAccumulation = allDividersHeight;
    var button = firstChild;
    while (button != null) {
      heightAccumulation += button.getMaxIntrinsicHeight(width);
      button = childAfter(button);
    }
    return heightAccumulation;
  }

  bool _isSingleButtonRow(double width) {
    final bool isSingleButtonRow;
    if (childCount == 1) {
      isSingleButtonRow = true;
    } else if (childCount == 2) {
      // There are 2 buttons. If they can fit side-by-side then that's what
      // we want to do. Otherwise, stack them vertically.
      final sideBySideWidth = firstChild!.getMaxIntrinsicWidth(double.infinity) +
          dividerThickness +
          lastChild!.getMaxIntrinsicWidth(double.infinity);
      isSingleButtonRow = sideBySideWidth <= width;
    } else {
      isSingleButtonRow = false;
    }
    return isSingleButtonRow;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(constraints: constraints, dry: true);
  }

  @override
  void performLayout() {
    size = _performLayout(constraints: constraints);
  }

  Size _performLayout({required BoxConstraints constraints, bool dry = false}) {
    final layoutChild = dry ? ChildLayoutHelper.dryLayoutChild : ChildLayoutHelper.layoutChild;

    if (!isActionSheet && _isSingleButtonRow(dialogWidth!)) {
      if (childCount == 1) {
        // We have 1 button. Our size is the width of the dialog and the height
        // of the single button.
        final childSize = layoutChild(
          firstChild!,
          constraints,
        );

        return constraints.constrain(
          Size(dialogWidth!, childSize.height),
        );
      } else {
        // Each button gets half the available width, minus a single divider.
        final perButtonConstraints = BoxConstraints(
          minWidth: (constraints.minWidth - dividerThickness) / 2.0,
          maxWidth: (constraints.maxWidth - dividerThickness) / 2.0,
        );

        // Layout the 2 buttons.
        final firstChildSize = layoutChild(
          firstChild!,
          perButtonConstraints,
        );
        final lastChildSize = layoutChild(
          lastChild!,
          perButtonConstraints,
        );

        if (!dry) {
          // The 2nd button needs to be offset to the right.
          assert(lastChild!.parentData is MultiChildLayoutParentData);
          final secondButtonParentData = lastChild!.parentData! as MultiChildLayoutParentData;
          secondButtonParentData.offset = Offset(firstChildSize.width + dividerThickness, 0);
        }

        // Calculate our size based on the button sizes.
        return constraints.constrain(
          Size(
            dialogWidth!,
            math.max(
              firstChildSize.height,
              lastChildSize.height,
            ),
          ),
        );
      }
    } else {
      // We need to stack buttons vertically, plus dividers above each button (except the 1st).
      final perButtonConstraints = constraints.copyWith(
        minHeight: 0,
        maxHeight: double.infinity,
      );

      var child = firstChild;
      var index = 0;
      var verticalOffset = 0.0;
      while (child != null) {
        final childSize = layoutChild(
          child,
          perButtonConstraints,
        );

        if (!dry) {
          assert(child.parentData is MultiChildLayoutParentData);
          final parentData = child.parentData! as MultiChildLayoutParentData;
          parentData.offset = Offset(0, verticalOffset);
        }
        verticalOffset += childSize.height;
        if (index < childCount - 1) {
          // Add a gap for the next divider.
          verticalOffset += dividerThickness;
        }

        index += 1;
        child = childAfter(child);
      }

      // Our height is the accumulated height of all buttons and dividers.
      return constraints.constrain(
        Size(computeMaxIntrinsicWidth(0), verticalOffset),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    if (!isActionSheet && _isSingleButtonRow(size.width)) {
      _drawButtonBackgroundsAndDividersSingleRow(canvas, offset);
    } else {
      _drawButtonBackgroundsAndDividersStacked(canvas, offset);
    }

    _drawButtons(context, offset);
  }

  void _drawButtonBackgroundsAndDividersSingleRow(Canvas canvas, Offset offset) {
    // The vertical divider sits between the left button and right button (if
    // the dialog has 2 buttons).  The vertical divider is hidden if either the
    // left or right button is pressed.
    final verticalDivider = childCount == 2 && !_isButtonPressed
        ? Rect.fromLTWH(
            offset.dx + firstChild!.size.width,
            offset.dy,
            dividerThickness,
            math.max(
              firstChild!.size.height,
              lastChild!.size.height,
            ),
          )
        : Rect.zero;

    final pressedButtonRects = _pressedButtons.map<Rect>((RenderBox pressedButton) {
      final buttonParentData = pressedButton.parentData! as MultiChildLayoutParentData;

      return Rect.fromLTWH(
        offset.dx + buttonParentData.offset.dx,
        offset.dy + buttonParentData.offset.dy,
        pressedButton.size.width,
        pressedButton.size.height,
      );
    }).toList();

    // Create the button backgrounds path and paint it.
    final backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(verticalDivider);

    for (var i = 0; i < pressedButtonRects.length; i += 1) {
      backgroundFillPath.addRect(pressedButtonRects[i]);
    }

    canvas.drawPath(
      backgroundFillPath,
      _buttonBackgroundPaint,
    );

    // Create the pressed buttons background path and paint it.
    final pressedBackgroundFillPath = Path();
    for (var i = 0; i < pressedButtonRects.length; i += 1) {
      pressedBackgroundFillPath.addRect(pressedButtonRects[i]);
    }

    canvas.drawPath(
      pressedBackgroundFillPath,
      _pressedButtonBackgroundPaint,
    );

    // Create the dividers path and paint it.
    final dividersPath = Path()..addRect(verticalDivider);

    canvas.drawPath(
      dividersPath,
      _dividerPaint,
    );
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final dividerOffset = Offset(0, dividerThickness);

    final backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final pressedBackgroundFillPath = Path();

    final dividersPath = Path();

    var accumulatingOffset = offset;

    var child = firstChild;
    RenderBox? prevChild;
    while (child != null) {
      assert(child.parentData is _ActionButtonParentData);
      final currentButtonParentData = child.parentData! as _ActionButtonParentData;
      final isButtonPressed = currentButtonParentData.isPressed;

      var isPrevButtonPressed = false;
      if (prevChild != null) {
        assert(prevChild.parentData is _ActionButtonParentData);
        final previousButtonParentData = prevChild.parentData! as _ActionButtonParentData;
        isPrevButtonPressed = previousButtonParentData.isPressed;
      }

      final isDividerPresent = child != firstChild;
      final isDividerPainted = isDividerPresent && !(isButtonPressed || isPrevButtonPressed);
      final dividerRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy,
        size.width,
        dividerThickness,
      );

      final buttonBackgroundRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy + (isDividerPresent ? dividerThickness : 0.0),
        size.width,
        child.size.height,
      );

      // If this button is pressed, then we don't want a white background to be
      // painted, so we erase this button from the background path.
      if (isButtonPressed) {
        backgroundFillPath.addRect(buttonBackgroundRect);
        pressedBackgroundFillPath.addRect(buttonBackgroundRect);
      }

      // If this divider is needed, then we erase the divider area from the
      // background path, and on top of that we paint a translucent gray to
      // darken the divider area.
      if (isDividerPainted) {
        backgroundFillPath.addRect(dividerRect);
        dividersPath.addRect(dividerRect);
      }

      accumulatingOffset +=
          (isDividerPresent ? dividerOffset : Offset.zero) + Offset(0, child.size.height);

      prevChild = child;
      child = childAfter(child);
    }

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  void _drawButtons(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
