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

class SelfUserProfile {
  String id;
  String userName;
  bool isVisitor;
  String firstName;
  String lastName;
  String email;
  String birthday;
  String sex;
  int status;
  int activationStatus;
  bool terminated;
  String department;
  String workFrom;
  String location;
  String notes;
  String displayName;
  String title;
  List<Contacts> contacts;
  List<Groups> groups;
  String avatarMedium;
  String avatar;
  bool isAdmin;
  bool isLDAP;
  List<String> listAdminModules;
  bool isOwner;
  String cultureName;
  bool isSSO;
  String avatarSmall;
  String profileUrl;

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
    id = json['id'];
    userName = json['userName'];
    isVisitor = json['isVisitor'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
    sex = json['sex'];
    status = json['status'];
    activationStatus = json['activationStatus'];
    terminated = json['terminated'];
    department = json['department'];
    workFrom = json['workFrom'];
    location = json['location'];
    notes = json['notes'];
    displayName = json['displayName'];
    title = json['title'];
    if (json['contacts'] != null) {
      contacts = new List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(new Contacts.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    avatarMedium = json['avatarMedium'];
    avatar = json['avatar'];
    isAdmin = json['isAdmin'];
    isLDAP = json['isLDAP'];

    isOwner = json['isOwner'];
    cultureName = json['cultureName'];
    isSSO = json['isSSO'];
    avatarSmall = json['avatarSmall'];
    profileUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['isVisitor'] = this.isVisitor;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['sex'] = this.sex;
    data['status'] = this.status;
    data['activationStatus'] = this.activationStatus;
    data['terminated'] = this.terminated;
    data['department'] = this.department;
    data['workFrom'] = this.workFrom;
    data['location'] = this.location;
    data['notes'] = this.notes;
    data['displayName'] = this.displayName;
    data['title'] = this.title;
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['avatarMedium'] = this.avatarMedium;
    data['avatar'] = this.avatar;
    data['isAdmin'] = this.isAdmin;
    data['isLDAP'] = this.isLDAP;
    data['listAdminModules'] = this.listAdminModules;
    data['isOwner'] = this.isOwner;
    data['cultureName'] = this.cultureName;
    data['isSSO'] = this.isSSO;
    data['avatarSmall'] = this.avatarSmall;
    data['profileUrl'] = this.profileUrl;
    return data;
  }
}

class Contacts {
  String type;
  String value;

  Contacts({this.type, this.value});

  Contacts.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Groups {
  String id;
  String name;
  String manager;

  Groups({this.id, this.name, this.manager});

  Groups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    manager = json['manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['manager'] = this.manager;
    return data;
  }
}
