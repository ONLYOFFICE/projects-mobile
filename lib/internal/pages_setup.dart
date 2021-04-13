import 'package:get/get.dart';

import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/descriprion_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/new_task/select_project_view.dart';
import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';

List<GetPage> getxPages() => [
      GetPage(name: '/', page: () => NavigationView()),
      GetPage(name: 'PortalView', page: () => PortalView()),
      GetPage(name: 'LoginView', page: () => LoginView()),
      GetPage(name: 'CodeView', page: () => CodeView()),
      GetPage(name: 'HomeView', page: () => ProjectsView()),
      GetPage(name: 'NavigationView', page: () => NavigationView()),
      GetPage(name: 'TaskDetailedView', page: () => TaskDetailedView()),
      GetPage(name: 'NewTaskView', page: () => NewTaskView()),
      GetPage(name: 'SelectProjectView', page: () => SelectProjectView()),
      GetPage(name: 'ProjectSearchView', page: () => ProjectSearchView()),
      GetPage(name: 'NewProject', page: () => NewProject()),
      GetPage(
          name: 'NewProjectDescription', page: () => NewProjectDescription()),
      GetPage(
          name: 'ProjectManagerSelectionView',
          page: () => ProjectManagerSelectionView()),
      GetPage(
          name: 'TeamMembersSelectionView',
          page: () => TeamMembersSelectionView()),
      GetPage(name: 'ProjectDetailedView', page: () => ProjectDetailedView()),
    ];
