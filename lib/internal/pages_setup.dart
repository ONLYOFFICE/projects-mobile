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

import 'package:get/get.dart';
import 'package:projects/main_view.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/2fa_sms_screen.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/enter_sms_code_screen.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/select_country_screen.dart';
import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/code_views/get_code_views.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';
import 'package:projects/presentation/views/authentication/passcode/passcode_screen.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen1.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen2.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/discussion_editing/discussion_editing_screen.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/discussion_editing/select/manage_discussion_subscribers_screen.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/select/select_dis_subscribers.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';
import 'package:projects/presentation/views/discussions/discussions_search_view.dart';
import 'package:projects/presentation/views/discussions/filter/discussions_filter_screen.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter_screen.dart';
import 'package:projects/presentation/views/new_task/task_description.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/new_task/select/select_milestone_view.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';

import 'package:projects/presentation/views/profile/profile_screen.dart';
import 'package:projects/presentation/views/project_detailed/milestones/description.dart';
import 'package:projects/presentation/views/project_detailed/milestones/filter/milestone_filter_screen.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/description_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_selection.dart';
import 'package:projects/presentation/views/projects_view/project_filter/projects_filter.dart';
import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:projects/presentation/views/settings/analytics_screen.dart';
import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_editing_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/new_comment_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/reply_comment_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_detailed_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';
import 'package:projects/presentation/views/tasks/tasks_filter.dart/tasks_filter.dart';
import 'package:projects/presentation/views/tasks/tasks_search_screen.dart';

List<GetPage> getxPages() => [
      GetPage(name: '/MainView', page: () => const MainView()),
      GetPage(name: '/LoginView', page: () => const LoginView()),
      GetPage(name: '/CodeView', page: () => CodeView()),
      GetPage(name: '/AnalyticsScreen', page: () => const AnalyticsScreen()),
      GetPage(name: '/DiscussionDetailed', page: () => DiscussionDetailed()),
      GetPage(name: '/DiscussionsFilterScreen', page: () => const DiscussionsFilterScreen()),
      GetPage(name: '/DiscussionsSearchScreen', page: () => const DiscussionsSearchScreen()),
      GetPage(name: '/GetCodeViews', page: () => const GetCodeViews()),
      GetPage(name: '/ColorThemeSelectionScreen', page: () => const ColorThemeSelectionScreen()),
      GetPage(name: '/CommentEditingView', page: () => const CommentEditingView()),
      GetPage(name: '/EnterSMSCodeScreen', page: () => const EnterSMSCodeScreen()),
      GetPage(name: '/HomeView', page: () => const ProjectsView()),
      GetPage(name: '/TaskDetailedView', page: () => const TaskDetailedView()),
      GetPage(name: '/TasksFilterScreen', page: () => const TasksFilterScreen()),
      GetPage(name: '/NewTaskView', page: () => const NewTaskView()),
      GetPage(name: '/NewCommentView', page: () => const NewCommentView()),
      GetPage(name: '/NewSubtaskView', page: () => const CreatingAndEditingSubtaskView()),
      GetPage(name: '/TaskDescription', page: () => const TaskDescription()),
      GetPage(
          name: '/SelectDiscussionSubscribers', page: () => const SelectDiscussionSubscribers()),
      GetPage(name: '/SelectDateView', page: () => const SelectDateView()),
      GetPage(name: '/SelectMilestoneView', page: () => const SelectMilestoneView()),
      GetPage(name: '/SelectProjectView', page: () => const SelectProjectView()),
      GetPage(name: '/SubtaskDetailedView', page: () => const SubtaskDetailedView()),
      GetPage(name: '/ProjectSearchView', page: () => ProjectSearchView()),
      GetPage(name: '/ProjectsFilterScreen', page: () => const ProjectsFilterScreen()),
      GetPage(name: '/MilestoneFilterScreen', page: () => const MilestoneFilterScreen()),
      GetPage(name: '/DocumentsFilterScreen', page: () => const DocumentsFilterScreen()),
      GetPage(name: '/NewProject', page: () => const NewProject()),
      GetPage(name: '/NewProjectDescription', page: () => const NewProjectDescription()),
      GetPage(
          name: '/ProjectManagerSelectionView', page: () => const ProjectManagerSelectionView()),
      GetPage(name: '/ReplyCommentView', page: () => const ReplyCommentView()),
      GetPage(name: '/ProjectDetailedView', page: () => ProjectDetailedView()),
      GetPage(name: '/TeamMembersSelectionView', page: () => const TeamMembersSelectionView()),
      GetPage(name: '/GroupMembersSelectionView', page: () => const GroupMembersSelectionView()),
      GetPage(name: '/NewDiscussionScreen', page: () => const NewDiscussionScreen()),
      GetPage(name: '/DiscussionEditingScreen', page: () => const DiscussionEditingScreen()),
      GetPage(
        name: '/ManageDiscussionSubscribersScreen',
        page: () => const ManageDiscussionSubscribersScreen(),
      ),
      GetPage(name: '/NewMilestoneView', page: () => const NewMilestoneView()),
      GetPage(name: '/NewMilestoneDescription', page: () => const NewMilestoneDescription()),
      GetPage(name: '/PasscodeSettingsScreen', page: () => const PasscodeSettingsScreen()),
      GetPage(name: '/PasscodeScreen', page: () => PasscodeScreen()),
      GetPage(name: '/PasswordRecoveryScreen', page: () => const PasswordRecoveryScreen1()),
      GetPage(name: '/PasswordRecoveryScreen2', page: () => const PasswordRecoveryScreen2()),
      GetPage(name: '/SelectCountryScreen', page: () => const SelectCountryScreen()),
      GetPage(name: '/SettingsScreen', page: () => const SettingsScreen()),
      GetPage(name: '/TasksSearchScreen', page: () => const TasksSearchScreen()),
      GetPage(name: '/TFASmsScreen', page: () => const TFASmsScreen()),
      GetPage(name: '/UsersFromGroups', page: () => const UsersFromGroups()),
      GetPage(name: '/ProfileScreen', page: () => const ProfileScreen()),
    ];
