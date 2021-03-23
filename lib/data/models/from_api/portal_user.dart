class PortalUser {
  String id;
  String displayName;
  String title;
  String avatarSmall;
  String profileUrl;

  PortalUser(
      {this.id,
      this.displayName,
      this.title,
      this.avatarSmall,
      this.profileUrl});

  PortalUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    title = json['title'];
    avatarSmall = json['avatarSmall'];
    profileUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['title'] = title;
    data['avatarSmall'] = avatarSmall;
    data['profileUrl'] = profileUrl;
    return data;
  }
}
