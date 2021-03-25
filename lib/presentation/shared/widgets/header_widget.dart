import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  HeaderWidget({this.title});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 56,
                child: SVG.createSized(
                    'lib/assets/images/icons/project_icon.svg', 40, 40),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyleHelper.headerStyle,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.search), onPressed: () {}),
                    IconButton(
                        icon: SVG
                            .create('lib/assets/images/icons/preferences.svg'),
                        onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // const SizedBox(width: 16),
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      '3 projects',
                      style:
                          TextStyleHelper.subtitleProjects(Theme.of(context)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Deadline',
                      style: TextStyleHelper.projectsSorting(Theme.of(context)),
                    ),
                    const SizedBox(width: 8),
                    SVG.createSized(
                        'lib/assets/images/icons/sorting_3_descend.svg',
                        20,
                        20),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}
