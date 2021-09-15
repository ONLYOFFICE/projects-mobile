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
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PortalInputView extends StatefulWidget {
  PortalInputView({Key key}) : super(key: key);

  @override
  _PortalInputViewState createState() => _PortalInputViewState();
}

class _PortalInputViewState extends State<PortalInputView> {
  LoginController controller;

  @override
  void initState() {
    try {
      Get.find<LoginController>().onClose();
    } catch (_) {}
    controller = Get.put(LoginController(), permanent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => controller.state.value == ViewState.Busy
              ? SizedBox(
                  height: Get.height,
                  child: const Center(child: CircularProgressIndicator()))
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: Get.height * 0.165),
                        AppIcon(icon: SvgIcons.logo_big),
                        SizedBox(height: Get.height * 0.044),
                        Text(tr('appName'),
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.headline6()),
                        SizedBox(height: Get.height * 0.111),
                        Obx(
                          () => AuthTextField(
                            controller: controller.portalAdressController,
                            autofillHint: AutofillHints.url,
                            hintText: tr('portalAdress'),
                            validator: controller.emailValidator,
                            hasError: controller.portalFieldError.value == true,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.033),
                        DecoratedBox(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 3,
                                offset: const Offset(0, 0.85),
                                color: Get.theme
                                    .colors()
                                    .onBackground
                                    .withOpacity(0.19)),
                            BoxShadow(
                                blurRadius: 3,
                                offset: const Offset(0, 0.25),
                                color: Get.theme
                                    .colors()
                                    .onBackground
                                    .withOpacity(0.04)),
                          ]),
                          child: WideButton(
                            text: tr('next'),
                            onPressed: () async =>
                                await controller.getPortalCapabilities(),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.222),
                        Text(
                          tr('appDescription'),
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.body2(
                              color: Get.theme
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
