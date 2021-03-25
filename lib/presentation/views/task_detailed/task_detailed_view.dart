import 'package:flutter/material.dart';
import 'package:projects/presentation/views/task_detailed/detailed_task_app_bar.dart';

class TaskDetailedView extends StatelessWidget {
  const TaskDetailedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: DetailedTaskAppBar(
          bottom: SizedBox(
            height: 25,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)
                ),
                tabs: [
                  for (var i = 0; i < 6; i++)
                    Tab(text: '312')
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}