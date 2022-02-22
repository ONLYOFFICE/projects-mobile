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
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/account_data.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/account_provider/android_account_provider.dart';
import 'package:projects/internal/account_provider/base_account_provider.dart';
import 'package:projects/internal/account_provider/ios_account_provider.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';

class AccountManager extends GetxController {
  final SecureStorage _secureStorage = locator<SecureStorage>();

  RxList<AccountData> accounts = <AccountData>[].obs;
  late BaseAccountProvider accountProvider =
      Platform.isAndroid ? AndroidAccountProvider() : IOSAccountProvider();

  Future setup() async {
    accounts.value = await fetchAccounts();
  }

  Future<void> addAccount({required String tokenString, required String expires}) async =>
      Platform.isAndroid
          ? await addAndroidAccount(tokenString: tokenString, expires: expires)
          : await addIOSAccount(tokenString: tokenString, expires: expires);

  Future<void> addAndroidAccount({required String tokenString, required String expires}) async {
    try {
      final portalInfo = Get.find<PortalInfoController>();
      await portalInfo.setup();
      await Get.find<UserController>().getUserInfo();
      final user = Get.find<UserController>().user;

      final portalUri = Uri.parse(Get.find<PortalInfoController>().portalUri!);
      final avatarUrl = user!.avatar!.contains('http') ? user.avatar : '$portalUri${user.avatar}';

      final accountData = AccountData(
          token: tokenString,
          portal: portalUri.authority,
          login: user.email,
          expires: expires,
          name: user.displayName,
          id: user.id,
          isAdmin: user.isAdmin,
          isVisitor: user.isVisitor,
          scheme: '${portalUri.scheme}://',
          avatarUrl: avatarUrl);
      final accountString = json.encode(accountData.toJson());
      await accountProvider.addAccount(accountData: accountString, accountId: user.id!);

      await _secureStorage.putString('currentAccount', accountString);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> addIOSAccount({required String tokenString, required String expires}) async {
    try {
      final portalInfo = Get.find<PortalInfoController>();
      await portalInfo.setup();
      await Get.find<UserController>().getUserInfo();
      final user = Get.find<UserController>().user;

      final portalUri = Uri.parse(Get.find<PortalInfoController>().portalUri!);
      final avatarUrl = user!.avatar!.contains('http') ? user.avatar : '$portalUri${user.avatar}';

      final accountData = AccountData(
          token: tokenString,
          portal: portalUri.authority,
          login: user.email,
          expires: expires,
          name: user.displayName,
          id: user.id,
          isAdmin: user.isAdmin,
          isVisitor: user.isVisitor,
          scheme: '${portalUri.scheme}://',
          avatarUrl: avatarUrl);
      final accountString = json.encode(accountData.toIOSJson());
      await accountProvider.addAccount(accountData: accountString, accountId: user.id!);

      await _secureStorage.putString('currentAccount', accountString);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<List<AccountData>> fetchAccounts() async =>
      Platform.isAndroid ? await getAccountsAndroid() : await getAccountsiOS();

  Future<List<AccountData>> getAccountsAndroid() async {
    final accountsList = <AccountData>[];
    try {
      final accounts = await accountProvider.getAccounts();

      for (final account in accounts) {
        final dynamic responseJson = json.decode(account);
        final accountData = AccountData.fromJson(responseJson as Map<String, dynamic>);

        accountsList.add(accountData);
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return accountsList;
  }

  Future<List<AccountData>> getAccountsiOS() async {
    final accountsList = <AccountData>[];
    try {
      final accountString = await accountProvider.getAccounts();
      if (accountString.isNotEmpty) {
        for (final account in accountString) {
          final dynamic responseJson = json.decode(account);
          final accountData = AccountData.fromIOSJson(responseJson as Map<String, dynamic>);

          accountsList.add(accountData);
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return accountsList;
  }

  Future<void> deleteAccounts({required AccountData accountData}) async => Platform.isAndroid
      ? await deleteAccountsAndroid(accountData: accountData)
      : await deleteAccountsiOS(accountData: accountData);

  Future<void> deleteAccountsAndroid({required AccountData accountData}) async {
    try {
      final deleted = await accountProvider.deleteAccount(
          accountId: accountData.id!, accountData: jsonEncode(accountData.toJson()));
      if (deleted!) {
        accounts.value = await fetchAccounts();

        if (accounts.isEmpty) await Get.to(() => const PortalInputView());

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('accountDeleted'));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> deleteAccountsiOS({required AccountData accountData}) async {
    try {
      final deleted = await accountProvider.deleteAccount(
          accountId: accountData.id!, accountData: jsonEncode(accountData.toIOSJson()));
      if (deleted!) {
        accounts.value = await fetchAccounts();

        if (accounts.isEmpty) await Get.to(() => const PortalInputView());

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('accountDeleted'));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> clearToken() async {
    final currentAccount = await _secureStorage.getString('currentAccount');
    if ((currentAccount ?? '') != '') {
      final account = AccountData.fromJson(json.decode(currentAccount!) as Map<String, dynamic>);

      await clearTokenForAccount(account);
      await _secureStorage.putString('currentAccount', jsonEncode(account.toJson()));
    }
  }

  Future<void> clearTokenForAccount(AccountData account) async => Platform.isAndroid
      ? await clearTokenForAccountAndroid(account)
      : await clearTokenForAccountIOS(account);

  Future<void> clearTokenForAccountAndroid(AccountData account) async {
    account.token = '';
    final accountString = jsonEncode(account.toJson());

    await accountProvider.updateAccount(accountData: accountString, accountId: account.id!);
  }

  Future<void> clearTokenForAccountIOS(AccountData account) async {
    account.token = '';
    final accountString = jsonEncode(account.toIOSJson());

    await accountProvider.updateAccount(accountData: accountString, accountId: account.id!);
  }
}
