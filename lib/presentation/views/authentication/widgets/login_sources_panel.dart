import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/login_controller.dart';

import 'package:projects/presentation/views/authentication/widgets/login_service_button.dart';

class LoginSources extends StatelessWidget {
  final List<String> capabilities;
  LoginSources({Key key, this.capabilities}) : super(key: key);

  final LoginController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
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
