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

import 'package:projects/data/models/from_api/contact.dart';
import 'package:projects/data/models/from_api/portal_group.dart';

class PortalUser {
  String? id;
  String? userName;
  bool? isVisitor;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? sex;
  int? status;
  int? activationStatus;
  String? terminated;
  String? department;
  String? workFrom;
  String? displayName;
  String? mobilePhone;
  String? title;
  List<Contact>? contacts;
  List<PortalGroup>? groups;
  String? avatarMedium;
  String? avatar;
  bool? isAdmin;
  bool? isLDAP;
  bool? isOwner;
  bool? isSSO;
  String? avatarSmall;
  String? profileUrl;
  List<String>? listAdminModules;

  PortalUser({
    this.id,
    this.userName,
    this.isVisitor,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.sex,
    this.status,
    this.activationStatus,
    this.terminated,
    this.department,
    this.workFrom,
    this.displayName,
    this.mobilePhone,
    this.title,
    this.contacts,
    this.groups,
    this.avatarMedium,
    this.avatar,
    this.isAdmin,
    this.isLDAP,
    this.isOwner,
    this.isSSO,
    this.avatarSmall,
    this.profileUrl,
    this.listAdminModules,
  });

  PortalUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userName = json['userName'] as String?;
    isVisitor = json['isVisitor'] as bool?;
    firstName = json['firstName'] as String?;
    lastName = json['lastName'] as String?;
    email = json['email'] as String?;
    birthday = json['birthday'] as String?;
    sex = json['sex'] as String?;
    status = json['status'] as int?;
    activationStatus = json['activationStatus'] as int?;
    terminated = json['terminated'] as String?;
    department = json['department'] as String?;
    workFrom = json['workFrom'] as String?;
    displayName = json['displayName'] as String?;
    mobilePhone = json['mobilePhone'] as String?;
    title = json['title'] as String?;
    if (json['contacts'] != null) {
      contacts = <Contact>[];
      for (final e in (json['contacts'] as List).cast<Map<String, dynamic>>()) {
        contacts!.add(Contact.fromJson(e));
      }
    }
    if (json['groups'] != null) {
      groups = <PortalGroup>[];
      for (final e in json['groups'] as List) {
        groups!.add(PortalGroup.fromJson((e as Map).cast<String, dynamic>()));
      }
    }
    avatarMedium = json['avatarMedium'] as String?;
    avatar = json['avatar'] as String?;
    isAdmin = json['isAdmin'] as bool?;
    isLDAP = json['isLDAP'] as bool?;
    isOwner = json['isOwner'] as bool?;
    isSSO = json['isSSO'] as bool?;
    avatarSmall = json['avatarSmall'] as String?;
    profileUrl = json['profileUrl'] as String?;
    if (json['listAdminModules'] != null) {
      listAdminModules = <String>[];
      (json['listAdminModules'] as List).cast<String>().forEach((e) {
        listAdminModules!.add(e);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['isVisitor'] = isVisitor;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthday'] = birthday;
    data['sex'] = sex;
    data['status'] = status;
    data['activationStatus'] = activationStatus;
    data['terminated'] = terminated;
    data['department'] = department;
    data['workFrom'] = workFrom;
    data['displayName'] = displayName;
    data['mobilePhone'] = mobilePhone;
    data['title'] = title;
    if (contacts != null) {
      data['contacts'] = contacts!.map((e) => e.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((e) => e.toJson()).toList();
    }
    data['avatarMedium'] = avatarMedium;
    data['avatar'] = avatar;
    data['isAdmin'] = isAdmin;
    data['isLDAP'] = isLDAP;
    data['isOwner'] = isOwner;
    data['isSSO'] = isSSO;
    data['avatarSmall'] = avatarSmall;
    data['profileUrl'] = profileUrl;
    // TODO: check comment code
    if (listAdminModules != null) {
      // data['contacts'] = listAdminModules.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
