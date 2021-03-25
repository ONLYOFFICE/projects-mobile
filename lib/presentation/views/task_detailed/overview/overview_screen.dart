import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/task_detailed/readmore.dart';

part 'task.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Task(),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.project,
                color: const Color(0xff707070)
              ),
              caption: 'Project:',
              subtitle: 'DEP Product Engineering',
              subtitleStyle: TextStyleHelper.subtitle1.copyWith(
                  color: Theme.of(context).customColors().links
              ),
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.milestone,
                color: const Color(0xff707070)
              ),
              caption: 'Milestone:', 
              subtitle: 'ONLYOFFICE Control Panel',
              subtitleStyle: TextStyleHelper.subtitle1.copyWith(
                  color: Theme.of(context).customColors().links
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 32, top: 42, bottom: 42),
              child: ReadMoreText(
                text,
                trimLines: 3,
                colorClickableText: Colors.pink,
                style: TextStyleHelper.body1,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyleHelper.body2.copyWith(
                  color: Theme.of(context).customColors().links
                ),
              ),
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.start_date,
                color: const Color(0xff707070)
              ),
              caption: 'Start date:', subtitle: 'March, 25th'),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.due_date,
                color: const Color(0xff707070)
              ),
              caption: 'Due date:', subtitle: 'March, 30th'),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.priority,
                color: const Color(0xffff7793)
              ),
              caption: 'Priority:', subtitle: 'High'
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: AppIcon(
                icon: SvgIcons.person,
                color: const Color(0xff707070)
              ),
              caption: 'Assigned to:', subtitle: '2 responsibles'
            ),
            const SizedBox(height: 20),
            const InfoTile(caption: 'Created by:', subtitle: 'S. Leushkin'),
            const SizedBox(height: 20),
            const InfoTile(caption: 'Creation date:', subtitle: '21 Mar 2021'),
            const SizedBox(height: 110)
          ],
        ),
      ),
    );
  }
}

String text = 'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m... Show more';


class InfoTile extends StatelessWidget {
  
  final Widget icon;
  final String caption;
  final String subtitle;
  final TextStyle captionStyle; 
  final TextStyle subtitleStyle; 

  const InfoTile({
    Key key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle = TextStyleHelper.subtitle1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: icon
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caption, style: captionStyle ?? TextStyleHelper.caption),
              Text(subtitle, style: subtitleStyle)
            ],
          )
        ],
      ),
    );
  }
}