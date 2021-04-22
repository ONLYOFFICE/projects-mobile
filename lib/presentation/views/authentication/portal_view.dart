import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/login_controller.dart';

import 'package:projects/presentation/views/authentication/widgets/portal_form.dart';

class PortalView extends StatelessWidget {
  PortalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());

    final assetName = 'lib/assets/images/logo_new.svg';
    final Widget svg = SvgPicture.asset(assetName,
        semanticsLabel: 'lib/assets/images/logo_new.svg');

    return Scaffold(
      body: Obx(
        () => controller.state.value == ViewState.Busy
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        svg,
                        const SizedBox(height: 10.0),
                        PortalForm()
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
