import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/domain/controllers/login_controller.dart';

import 'package:only_office_mobile/presentation/views/authentication/widgets/login_service_button.dart';

class LoginSources extends StatelessWidget {
  final List<String> capabilities;
  LoginSources({this.capabilities});

  final LoginController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: getLoginServices()),
        ],
      ),
    );
  }

  Widget getLoginServices() => ListView.builder(
        itemCount: capabilities.length,
        itemBuilder: (context, index) => LoginItem(
          serviceName: capabilities[index],
          onTap: () {
            controller.loginByProvider('${capabilities[index]}');
          },
        ),
        scrollDirection: Axis.horizontal,
      );
}
