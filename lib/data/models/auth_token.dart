class AuthToken {
  AuthToken({
    this.token,
    this.expires,
  });
  String token;
  String expires;

  AuthToken.fromJson(Map<String, dynamic> json) {
    token = json['response']['token'];
    expires = json['response']['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expires'] = this.expires;

    return data;
  }
}
