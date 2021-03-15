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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['title'] = this.title;
    data['avatarSmall'] = this.avatarSmall;
    data['profileUrl'] = this.profileUrl;
    return data;
  }
}
