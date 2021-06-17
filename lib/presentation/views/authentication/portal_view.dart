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
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PortalView extends StatelessWidget {
  PortalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => controller.state.value == ViewState.Busy
              ? SizedBox(
                  height: Get.height,
                  child: const Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: Get.height * 0.165),
                      AppIcon(icon: SvgIcons.logo_big),
                      SizedBox(height: Get.height * 0.044),
                      Text('ONLYOFFICE\nProjects',
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.headline6()),
                      SizedBox(height: Get.height * 0.111),
                      AuthTextField(
                        controller: controller.portalAdressController,
                        hintText: 'Portal address',
                        validator: controller.emailValidator,
                        autofillHint: AutofillHints.url,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.portalFieldIsEmpty.value = false;
                          } else {
                            controller.portalFieldIsEmpty.value = true;
                          }
                        },
                      ),
                      SizedBox(height: Get.height * 0.033),
                      DecoratedBox(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 0.85),
                              color: Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.19)),
                          BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 0.25),
                              color: Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.04)),
                        ]),
                        child: Obx(
                          // ignore: deprecated_member_use
                          () => WideButton(
                            text: 'LOG IN',
                            onPressed: controller.portalFieldIsEmpty.isTrue
                                ? null
                                : () async =>
                                    await controller.getPortalCapabilities(),
                            color: controller.portalFieldIsEmpty.isFalse
                                ? Theme.of(context).customColors().primary
                                : Theme.of(context).customColors().surface,
                            textColor: controller.portalFieldIsEmpty.isFalse
                                ? Theme.of(context).customColors().onNavBar
                                : Theme.of(context)
                                    .customColors()
                                    .onSurface
                                    .withOpacity(0.4),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.222),
                      Text(
                        _decsription,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.body2(
                            color: Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

String _decsription =
    'ONLYOFFICE portal provide saving filesin cloud storage, share it with co-workersand co-editing in realtime';
