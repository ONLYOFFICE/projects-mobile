import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

const Color _kPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFE1E1E1),
  darkColor: Color(0xFF2E2E2E),
);

class PlatformPopupMenuItem<T> extends PopupMenuEntry<T> {
  const PlatformPopupMenuItem({
    Key? key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.trailingIcon,
    required this.child,
  })  : assert(
          !(value != null && onTap != null),
          'You can only pass [value] or [onTap], not both.',
        ),
        super(key: key);

  final T? value;
  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final MouseCursor? mouseCursor;
  final Widget? child;

  final bool isDefaultAction;
  final bool isDestructiveAction;
  final Widget? trailingIcon;

  @override
  bool represents(T? value) => value == this.value;

  @override
  MyPopupMenuItemState<T, PlatformPopupMenuItem<T>> createState() =>
      MyPopupMenuItemState<T, PlatformPopupMenuItem<T>>();
}

class MyPopupMenuItemState<T, W extends PlatformPopupMenuItem<T>> extends State<W> {
  final double _kMenuHorizontalPadding = 16;
  final double _kButtonHeight = 44;
  final TextStyle _kActionSheetActionStyle = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    color: Theme.of(Get.context!).colors().onSurface,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.41,
  );

  final GlobalKey _globalKey = GlobalKey();
  bool _isPressed = false;

  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @protected
  void handleTap() {
    if (widget.enabled) widget.onTap?.call();

    if (widget.onTap == null && widget.value != null) Navigator.pop<T>(context, widget.value);
  }

  TextStyle get _textStyle {
    if (widget.isDefaultAction) {
      return _kActionSheetActionStyle.copyWith(
        fontWeight: FontWeight.w600,
      );
    }
    if (widget.isDestructiveAction) {
      return _kActionSheetActionStyle.copyWith(
        color: CupertinoColors.destructiveRed,
      );
    }
    return _kActionSheetActionStyle;
  }

  Widget createCupertinoWidget(BuildContext context) {
    final _kBackgroundColorPressed = CupertinoDynamicColor.resolve(_kPressedColor, context);

    return GestureDetector(
      key: _globalKey,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onTap: handleTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        child: Container(
          constraints: BoxConstraints.tightFor(height: _kButtonHeight),
          decoration: BoxDecoration(
            color: widget.enabled
                ? _isPressed
                    ? _kBackgroundColorPressed
                    : Colors.transparent
                : CupertinoColors.inactiveGray,
          ),
          padding: EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
          child: DefaultTextStyle(
            style: _textStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: widget.child!,
                ),
                if (widget.trailingIcon != null) const SizedBox(width: 8),
                if (widget.trailingIcon != null) widget.trailingIcon!,
                if (widget.trailingIcon != null) const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createMaterialWidget(BuildContext context) {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    var style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.subtitle1!;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: widget.child!,
            ),
            if (widget.trailingIcon != null) const SizedBox(width: 8),
            if (widget.trailingIcon != null) widget.trailingIcon!,
            if (widget.trailingIcon != null) const SizedBox(width: 8),
          ],
        ),
      ),
    );

    if (!widget.enabled) {
      final isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
    final effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return createMaterialWidget(context);
    } else if (isCupertino(context)) {
      return createCupertinoWidget(context);
    }

    return throw UnsupportedError('This platform is not supported');
  }
}
