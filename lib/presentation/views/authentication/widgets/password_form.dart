/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PasswordForm extends StatefulWidget {
  PasswordForm({Key key}) : super(key: key);
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();

    final emailField = TextFormField(
      controller: emailController,
      validator: controller.emailValidator,
      autofillHints: [AutofillHints.email],
      obscureText: false,
      style: TextStyleHelper.mainStyle,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: tr('emailAddress'),
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final passwordField = TextFormField(
      validator: controller.passValidator,
      controller: passController,
      autofillHints: [AutofillHints.password],
      obscureText: true,
      style: TextStyleHelper.mainStyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: tr('password'), //"Пароль",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    var onLoginPressed = () async {
      await controller.loginByPassword(
          emailController.text, passController.text);
    };
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onLoginPressed,
        child: Text('Login',
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
            const SizedBox(height: 10.0),
            emailField,
            const SizedBox(height: 10.0),
            passwordField,
            const SizedBox(
              height: 10.0,
            ),
            Obx(() => controller.state.value == ViewState.Busy
                ? const CircularProgressIndicator()
                : loginButon),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
