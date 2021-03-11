import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:only_office_mobile/domain/controllers/login_controller.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/views/authentication/widgets/login_sources_panel.dart';
import 'package:only_office_mobile/presentation/views/authentication/widgets/password_form.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PasswordForm(),
                (controller.capabilities != null)
                    ? LoginSources(
                        capabilities: controller.capabilities.providers)
                    : SizedBox(
                        height: 15.0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
