import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class CodeForm extends StatefulWidget {
  CodeForm({Key key}) : super(key: key);
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  TextEditingController codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();

    final codeField = TextFormField(
      controller: codeController,
      obscureText: false,
      keyboardType: TextInputType.number,
      style: TextStyleHelper.mainStyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: tr('tfaCode'),
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    var onLoginPressed = () async {
      await controller.sendCode(codeController.text);
    };
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onLoginPressed,
        child: Text(tr('send'),
            textAlign: TextAlign.center,
            style: TextStyleHelper.mainStyle.copyWith(
                color: Get.theme.backgroundColor, fontWeight: FontWeight.bold)),
      ),
    );

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            codeField,
            const SizedBox(height: 10.0),
            Obx(() => controller.state.value == ViewState.Busy
                ? const CircularProgressIndicator()
                : loginButon),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
