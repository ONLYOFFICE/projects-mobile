import 'package:get/get.dart';

import 'package:only_office_mobile/presentation/views/authentication/login_view.dart';
import 'package:only_office_mobile/presentation/views/authentication/portal_view.dart';
import 'package:only_office_mobile/presentation/views/home_view/home_view.dart';

List<GetPage> getxPages() => [
      GetPage(name: '/', page: () => HomeView()),
      GetPage(name: 'PortalView', page: () => PortalView()),
      GetPage(name: 'LoginView', page: () => LoginView()),
    ];
