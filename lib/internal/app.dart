import 'package:flutter/material.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:provider/provider.dart';
import 'package:only_office_mobile/presentation/views/home_view/home_view.dart';

import 'package:only_office_mobile/internal/router.dart' as UI;

// class App extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomeView(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      initialData: User.initial(),
      create: (BuildContext context) =>
          locator<AuthenticationService>().userController.stream,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        initialRoute: 'login',
        onGenerateRoute: UI.Router.generateRoute,
      ),
    );
  }
}
