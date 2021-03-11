import 'package:get/get.dart';

import 'package:only_office_mobile/presentation/views/authentication/code_view.dart';
import 'package:only_office_mobile/presentation/views/authentication/login_view.dart';
import 'package:only_office_mobile/presentation/views/authentication/portal_view.dart';
import 'package:only_office_mobile/presentation/views/navigation_view.dart';
import 'package:only_office_mobile/presentation/views/projects_view/projects_view.dart';

List<GetPage> getxPages() => [
      GetPage(name: '/', page: () => NavigationView()),
      GetPage(name: 'PortalView', page: () => PortalView()),
      GetPage(name: 'LoginView', page: () => LoginView()),
      GetPage(name: 'CodeView', page: () => CodeView()),
      GetPage(name: 'HomeView', page: () => ProjectsView()),
      GetPage(name: 'NavigationView', page: () => NavigationView()),
    ];
