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

import 'dart:convert';

import 'package:accountmanager/accountmanager.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projects/data/models/account_data.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/views/authentication/account_manager/account_manager_view.dart';

class AccountManagerController extends GetxController {
  static const accountType = 'com.onlyoffice.account';
  static const tokenType = 'com.onlyoffice.auth';
  static const key = 'account_data';

  List<AccountData> accounts;

  @override
  void onClose() {
    super.onClose();
  }

  Future setup() async {
    accounts = await fetchAccounts();

    if (accounts.isNotEmpty) {
      await showBarModalBottomSheet(
        context: Get.context,
        builder: (context) => const AccountManagerView(),
      );
    }
  }

  Future<void> addAccount({String tokenString, String expires}) async {
    if (await Permission.contacts.request().isGranted) {
      try {
        var portalInfo = Get.find<PortalInfoController>();
        await portalInfo.setup();

        var account =
            Account(name: portalInfo.portalName, accountType: accountType);

        if (await AccountManager.addAccount(account)) {
          var accessToken =
              AccessToken(tokenType: tokenType, token: tokenString);

          await AccountManager.setAccessToken(account, accessToken);

          await Get.find<UserController>().getUserInfo();

          var user = Get.find<UserController>().user;
          var data = AccountData(
              portal: Get.find<PortalInfoController>().portalName,
              email: user.email,
              expires: expires,
              displayName: user.displayName,
              avatar: user.avatar);
          await AccountManager.setUserData(
              account, key, json.encode(data.toJson()));
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    }
  }

  Future<List<AccountData>> fetchAccounts() async {
    var accountsList = <AccountData>[];
    if (await Permission.contacts.request().isGranted) {
      try {
        var accounts = await AccountManager.getAccounts();

        for (var account in accounts) {
          if (account.accountType == accountType) {
            var value = await AccountManager.getUserData(account, key);
            var accountData = AccountData.fromJson(json.decode(value));
            var accesstoken =
                await AccountManager.getAccessToken(account, tokenType);
            accountData.accessToken = accesstoken.token;

            accountsList.add(accountData);
          }
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    }
    return accountsList;
  }
}
