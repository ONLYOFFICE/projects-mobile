import 'package:flutter/material.dart';

import 'package:only_office_mobile/domain/viewmodels/login_viewmodel.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/views/base_view.dart';
import 'package:only_office_mobile/presentation/views/login_view/widgets/authorization.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(builder: (context, viewmodel, child) {
      return Scaffold(
        body: Center(
          child: Container(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Authorization(viewmodel: viewmodel),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
