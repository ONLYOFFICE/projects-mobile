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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PortalForm extends StatefulWidget {
  PortalForm();

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
