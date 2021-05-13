import 'package:get/get.dart';

import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';
import 'package:projects/presentation/views/new_task/task_description.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/new_task/select/select_milestone_view.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';
import 'package:projects/presentation/views/new_task/select/select_responsibles_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/description.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/descriprion_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_selection.dart';
import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/new_comment_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_detailed_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';
import 'package:projects/presentation/views/task_editing_view/task_editing_view.dart';

List<GetPage> getxPages() => [
      GetPage(name: '/', page: () => NavigationView()),
      GetPage(name: 'PortalView', page: () => PortalView()),
      GetPage(name: 'LoginView', page: () => LoginView()),
      GetPage(name: 'CodeView', page: () => CodeView()),
      GetPage(name: 'HomeView', page: () => const ProjectsView()),
      GetPage(name: 'NavigationView', page: () => NavigationView()),
      GetPage(name: 'TaskDetailedView', page: () => TaskDetailedView()),
      GetPage(name: 'TaskEditingView', page: () => const TaskEditingView()),
      GetPage(name: 'NewTaskView', page: () => const NewTaskView()),
      GetPage(name: 'NewCommentView', page: () => const NewCommentView()),
      GetPage(
          name: 'NewSubtaskView',
          page: () => const CreatingAndEditingSubtaskView()),
      GetPage(name: 'TaskDescription', page: () => const TaskDescription()),
      GetPage(name: 'SelectDateView', page: () => const SelectDateView()),
      GetPage(
          name: 'SelectMilestoneView', page: () => const SelectMilestoneView()),
      GetPage(name: 'SelectProjectView', page: () => const SelectProjectView()),
      GetPage(
          name: 'SelectResponsiblesView',
          page: () => const SelectResponsiblesView()),
      GetPage(
          name: 'SubtaskDetailedView', page: () => const SubtaskDetailedView()),
      GetPage(name: 'ProjectSearchView', page: () => ProjectSearchView()),
      GetPage(name: 'NewProject', page: () => const NewProject()),
      GetPage(
          name: 'NewProjectDescription',
          page: () => const NewProjectDescription()),
      GetPage(
          name: 'ProjectManagerSelectionView',
          page: () => const ProjectManagerSelectionView()),
      GetPage(
          name: 'TeamMembersSelectionView',
          page: () => const TeamMembersSelectionView()),
      GetPage(name: 'ProjectDetailedView', page: () => ProjectDetailedView()),
      GetPage(
          name: 'GroupMembersSelectionView',
          page: () => const GroupMembersSelectionView()),
      GetPage(name: 'NewMilestoneView', page: () => const NewMilestoneView()),
      GetPage(
          name: 'NewMilestoneDescription',
          page: () => const NewMilestoneDescription()),
      GetPage(
          name: 'SelectProjectForMilestone',
          page: () => const SelectProjectForMilestone()),
    ];
