import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PortalForm extends StatefulWidget {
  PortalForm({Key key}) : super(key: key);

  @override
  _PortalFormState createState() => _PortalFormState();
}

class _PortalFormState extends State<PortalForm> {
  TextEditingController portalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    var controller = Get.put(LoginController());

    final portalField = TextFormField(
      controller: portalController,
      autofillHints: [AutofillHints.url],
      obscureText: false,
      style: TextStyleHelper.mainStyle,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: localization.portalName, //"Адрес портала",
      ),
    );

    var onContinuePressed = () async {
      await controller.getPortalCapabilities(portalController.text);
    };
    final continueButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onContinuePressed,
        child: Text(localization.continueButton,
            textAlign: TextAlign.center,
            style: TextStyleHelper.mainStyle.copyWith(
                color: Theme.of(context).backgroundColor,
                fontWeight: FontWeight.bold)),
      ),
    );

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            portalField,
            const SizedBox(height: 10.0),
            continueButton,
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
