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

class AccountData {
  String id = '';
  String login = '';
  String portal = '';
  String serverVersion = '';
  String scheme = '';
  String name = '';
  String provider = '';
  String avatarUrl = '';
  String isSslCiphers = '';
  String isSslState = '';
  String isOnline = '';
  String isWebDav = '';
  String isOneDrive = '';
  String isDropbox = '';
  String isAdmin = '';
  String isVisitor = '';
  String token = '';
  String password = '';
  String expires = '';

  AccountData({
    this.id = '',
    this.login = '',
    this.portal = '',
    this.serverVersion = '',
    this.scheme = '',
    this.name = '',
    this.provider = '',
    this.avatarUrl = '',
    this.isSslCiphers = '',
    this.isSslState = '',
    this.isOnline = '',
    this.isWebDav = '',
    this.isOneDrive = '',
    this.isDropbox = '',
    this.isAdmin = '',
    this.isVisitor = '',
    this.token = '',
    this.password = '',
    this.expires = '',
  });

  AccountData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    login = json['login'] as String;
    portal = json['portal'] as String;
    serverVersion = json['serverVersion'] as String;
    scheme = json['scheme'] as String;
    name = json['name'] as String;
    provider = json['provider'] as String;
    avatarUrl = json['avatarUrl'] as String;
    isSslCiphers = json['isSslCiphers'] as String;
    isSslState = json['isSslState'] as String;
    isOnline = json['isOnline'] as String;
    isWebDav = json['isWebDav'] as String;
    isOneDrive = json['isOneDrive'] as String;
    isDropbox = json['isDropbox'] as String;
    isAdmin = json['isAdmin'] as String;
    isVisitor = json['isVisitor'] as String;
    token = json['token'] as String;
    password = json['password'] as String;

    // expires = json['expires'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['portal'] = portal;
    data['serverVersion'] = serverVersion;
    data['scheme'] = scheme;
    data['name'] = name;
    data['provider'] = provider;
    data['avatarUrl'] = avatarUrl;
    data['isSslCiphers'] = isSslCiphers;
    data['isSslState'] = isSslState;
    data['isOnline'] = isOnline;
    data['isWebDav'] = isWebDav;
    data['isOneDrive'] = isOneDrive;
    data['isDropbox'] = isDropbox;
    data['isAdmin'] = isAdmin;
    data['isVisitor'] = isVisitor;
    data['token'] = token;
    data['password'] = password;

    data['expires'] = expires;
    return data;
  }
}
