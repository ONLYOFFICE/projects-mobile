import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class DescriptionTile extends StatefulWidget {
  final TaskActionsController controller;
  DescriptionTile({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _DescriptionTileState createState() => _DescriptionTileState();
}

class _DescriptionTileState extends State<DescriptionTile>
    with TickerProviderStateMixin {
  bool _isExpanded;

  AnimationController _controller;

  final Animatable<double> _halfTween = Tween<double>(begin: 0, end: 0.245);
  final Animatable<double> _turnsTween = CurveTween(curve: Curves.easeIn);

  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_turnsTween));
    // _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    double _height = _isExpanded ? null : 61;

    void changeExpansion() {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }

    return Obx(
      () {
        // ignore: omit_local_variable_types
        bool _isSelected = widget.controller.descriptionText.value.isNotEmpty;
        return InkWell(
          onTap: () => Get.toNamed('NewTaskDescription',
              arguments: {'controller': widget.controller}),
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                vsync: this,
                child: SizedBox(
                  height: _height,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 56,
                          child: AppIcon(
                              icon: SvgIcons.description,
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6))),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: _isSelected ? 10 : 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isSelected)
                                Text('Descriprion:',
                                    style: TextStyleHelper.caption(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onBackground
                                            .withOpacity(0.75))),
                              Flexible(
                                child: Text(
                                    _isSelected
                                        ? widget
                                            .controller.descriptionText.value
                                        : 'Add description',
                                    style: TextStyleHelper.subtitle1(
                                        color: _isSelected
                                            ? Theme.of(context)
                                                .customColors()
                                                .onBackground
                                            : Theme.of(context)
                                                .customColors()
                                                .onSurface
                                                .withOpacity(0.6))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 3),
                        child: IconButton(
                          icon: RotationTransition(
                            turns: _iconTurns,
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                size: 20,
                                color: Theme.of(context)
                                    .customColors()
                                    .onSurface
                                    .withOpacity(0.6)),
                          ),
                          onPressed: changeExpansion,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const StyledDivider(leftPadding: 56),
            ],
          ),
        );
      },
    );
  }
}
