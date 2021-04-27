import 'package:flutter/material.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class DocumentCell extends StatelessWidget {
  final PortalFile file;
  const DocumentCell({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
              width: 72, child: Center(child: Text(file.fileType.toString()))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.title),
                Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    formatedDate(
                            now: DateTime.now(),
                            stringDate: '${file.updated}') +
                        ''' • ${file.contentLength} • ${file.updatedBy.displayName}''',
                    style: TextStyleHelper.caption(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.5)),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(child: Text('Open')),
                    const PopupMenuItem(child: Text('Copy link')),
                    const PopupMenuItem(child: Text('Download')),
                    const PopupMenuItem(child: Text('Move')),
                    const PopupMenuItem(child: Text('Copy')),
                    const PopupMenuItem(child: Text('Delete')),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
