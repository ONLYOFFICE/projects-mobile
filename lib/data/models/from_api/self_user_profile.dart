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
      contacts = List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(Contacts.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = List<Groups>();
      json['groups'].forEach((v) {
        groups.add(Groups.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
      data['contacts'] = contacts.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
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

class Contacts {
  String type;
  String value;

  Contacts({this.type, this.value});

  Contacts.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['value'] = value;
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
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['manager'] = manager;
    return data;
  }
}
