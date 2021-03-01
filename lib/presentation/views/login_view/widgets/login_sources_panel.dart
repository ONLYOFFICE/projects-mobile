import 'package:flutter/material.dart';

import 'package:only_office_mobile/presentation/views/login_view/widgets/login_service_button.dart';

class LoginSources extends StatelessWidget {
  final List<String> capabilities;
  LoginSources({this.capabilities});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50,
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
          onTap: () {},
        ),
        scrollDirection: Axis.horizontal,
      );
}
