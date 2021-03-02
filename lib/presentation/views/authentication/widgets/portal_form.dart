import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:only_office_mobile/domain/controllers/login_controller.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';

class PortalForm extends StatefulWidget {
  PortalForm();

  @override
  _PortalFormState createState() => _PortalFormState();
}

class _PortalFormState extends State<PortalForm> {
  TextEditingController portalController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    LoginController controller = Get.put(LoginController());

    final portalField = TextFormField(
      controller: portalController,
      autofillHints: [AutofillHints.url],
      obscureText: false,
      style: mainStyle,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: localization.portalName, //"Адрес портала",
      ),
    );

    var onContinuePressed = () async {
      await controller.getPortalCapabilities(portalController.text);
    };
    final continueButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onContinuePressed,
        child: Text(localization.continueButton,
            textAlign: TextAlign.center,
            style: mainStyle.copyWith(
                color: backgroundColor, fontWeight: FontWeight.bold)),
      ),
    );

    return new Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            portalField,
            SizedBox(
              height: 10.0,
            ),
            continueButton,
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
