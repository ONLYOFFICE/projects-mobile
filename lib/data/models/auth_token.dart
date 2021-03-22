class AuthToken {
  AuthToken({
    this.token,
    this.expires,
    this.tfa,
  });
  String token;
  String expires;
  bool tfa;

  AuthToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
    tfa = json['tfa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expires'] = this.expires;

    return data;
  }
}
