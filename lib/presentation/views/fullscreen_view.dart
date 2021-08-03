import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullscreenView extends StatelessWidget {
  final Widget contentView;

  const FullscreenView({
    Key key,
    @required this.contentView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff717171).withOpacity(0.6),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 480,
                height: 608,
                child: contentView,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
