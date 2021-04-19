import 'package:projects/data/models/from_api/contact.dart';
import 'package:projects/data/models/from_api/portal_group.dart';

class PortalUser {
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
  String terminated;
  String department;
  String workFrom;
  String displayName;
  String mobilePhone;
  String title;
  List<Contact> contacts;
  List<PortalGroup> groups;
  String avatarMedium;
  String avatar;
  bool isAdmin;
  bool isLDAP;
  bool isOwner;
  bool isSSO;
  String avatarSmall;
  String profileUrl;

  PortalUser(
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
      this.profileUrl});

  PortalUser.fromJson(Map<String, dynamic> json) {
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
    displayName = json['displayName'];
    mobilePhone = json['mobilePhone'];
    title = json['title'];
    if (json['contacts'] != null) {
      contacts = <Contact>[];
      json['contacts'].forEach((v) {
        contacts.add(Contact.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <PortalGroup>[];
      json['groups'].forEach((v) {
        groups.add(PortalGroup.fromJson(v));
      });
    }
    avatarMedium = json['avatarMedium'];
    avatar = json['avatar'];
    isAdmin = json['isAdmin'];
    isLDAP = json['isLDAP'];
    isOwner = json['isOwner'];
    isSSO = json['isSSO'];
    avatarSmall = json['avatarSmall'];
    profileUrl = json['profileUrl'];
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
      data['contacts'] = contacts.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups.map((v) => v.toJson()).toList();
    }
    data['avatarMedium'] = avatarMedium;
    data['avatar'] = avatar;
    data['isAdmin'] = isAdmin;
    data['isLDAP'] = isLDAP;
    data['isOwner'] = isOwner;
    data['isSSO'] = isSSO;
    data['avatarSmall'] = avatarSmall;
    data['profileUrl'] = profileUrl;
    return data;
  }
}
