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
import 'package:projects/domain/controllers/auth/account_controller.dart';
import 'package:projects/domain/controllers/auth/account_tile_controller.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/authentication/account_manager/account_tile.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';

class AccountManagerView extends StatelessWidget {
  AccountManagerView({Key? key}) : super(key: key);

  final loginController = Get.find<LoginController>();

  final accountController =
      Get.isRegistered<AccountManager>() ? Get.find<AccountManager>() : Get.put(AccountManager());

  @override
  Widget build(BuildContext context) {
    accountController.setup();

    return Scaffold(
      //TODO fix background colors for tablet
      // backgroundColor: Theme.of(context).colors().backgroundSecond,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 480, maxHeight: MediaQuery.of(context).size.height),
          child: OrientationBuilder(builder: (context, orientation) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (orientation == Orientation.portrait)
                  const Spacer(flex: 1)
                else
                  const SizedBox(height: 20),
                const AppIcon(icon: SvgIcons.app_logo),
                SizedBox(height: Get.height * 0.01),
                AppIcon(
                  icon: SvgIcons.app_title,
                  color: Theme.of(context).colors().onSurface,
                ),
                if (orientation == Orientation.portrait)
                  SizedBox(height: Get.height * 0.06)
                else
                  const SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: Obx(
                    () => ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) {
                        if (i == accountController.accounts.length) {
                          return const _NewAccountButton();
                        } else
                          return AccountTile(
                            userController:
                                AccountTileController(accountData: accountController.accounts[i]),
                          );
                      },
                      separatorBuilder: (c, i) => const StyledDivider(leftPadding: 72),
                      itemCount: accountController.accounts.length + 1,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _NewAccountButton extends StatelessWidget {
  const _NewAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => PortalInputView(), fullscreenDialog: true),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colors().primary,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tr('addNewAccount'),
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyleHelper.subtitle1(color: Theme.of(context).colors().primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
