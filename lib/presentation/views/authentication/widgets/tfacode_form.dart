import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class CodeForm extends StatefulWidget {
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
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Код',
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
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onLoginPressed,
        child: Text('Send',
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
            SizedBox(height: 10.0),
            codeField,
            SizedBox(
              height: 10.0,
            ),
            Obx(() => controller.state.value == ViewState.Busy
                ? CircularProgressIndicator()
                : loginButon),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
