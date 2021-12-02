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

class SelfUserProfile {
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
  bool? terminated;
  String? department;
  String? workFrom;
  String? location;
  String? notes;
  String? displayName;
  String? title;
  List<Contact>? contacts;
  List<PortalGroup>? groups;
  String? avatarMedium;
  String? avatar;
  bool? isAdmin;
  bool? isLDAP;
  List<String>? listAdminModules;
  bool? isOwner;
  String? cultureName;
  bool? isSSO;
  String? avatarSmall;
  String? profileUrl;

  SelfUserProfile(
      {this.id,
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
      this.location,
      this.notes,
      this.displayName,
      this.title,
      this.contacts,
      this.groups,
      this.avatarMedium,
      this.avatar,
      this.isAdmin,
      this.isLDAP,
      this.listAdminModules,
      this.isOwner,
      this.cultureName,
      this.isSSO,
      this.avatarSmall,
      this.profileUrl});

  SelfUserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    userName = json['userName'] as String?;
    isVisitor = json['isVisitor'] as bool?;
    firstName = json['firstName'] as String?;
    lastName = json['lastName'] as String?;
    email = json['email'] as String?;
    birthday = json['birthday'] as String?;
    sex = json['sex'] as String?;
    status = json['status'] as int?;
    activationStatus = json['activationStatus'] as int?;
    terminated = json['terminated'] as bool?;
    department = json['department'] as String?;
    workFrom = json['workFrom'] as String?;
    location = json['location'] as String?;
    notes = json['notes'] as String?;
    displayName = json['displayName'] as String?;
    title = json['title'] as String?;
    if (json['contacts'] != null) {
      contacts = <Contact>[];
      for (final v in (json['contacts'] as List).cast<Map<String, dynamic>>()) {
        contacts!.add(Contact.fromJson(v));
      }
    }
    if (json['groups'] != null) {
      groups = <PortalGroup>[];
      for (final v in (json['groups'] as List).cast<Map<String, dynamic>>()) {
        groups!.add(PortalGroup.fromJson(v));
      }
    }
    avatarMedium = json['avatarMedium'] as String?;
    avatar = json['avatar'] as String?;
    isAdmin = json['isAdmin'] as bool?;
    isLDAP = json['isLDAP'] as bool?;

    isOwner = json['isOwner'] as bool?;
    cultureName = json['cultureName'] as String?;
    isSSO = json['isSSO'] as bool?;
    avatarSmall = json['avatarSmall'] as String?;
    profileUrl = json['profileUrl'] as String?;
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
    data['location'] = location;
    data['notes'] = notes;
    data['displayName'] = displayName;
    data['title'] = title;
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['avatarMedium'] = avatarMedium;
    data['avatar'] = avatar;
    data['isAdmin'] = isAdmin;
    data['isLDAP'] = isLDAP;
    data['listAdminModules'] = listAdminModules;
    data['isOwner'] = isOwner;
    data['cultureName'] = cultureName;
    data['isSSO'] = isSSO;
    data['avatarSmall'] = avatarSmall;
    data['profileUrl'] = profileUrl;
    return data;
  }
}
