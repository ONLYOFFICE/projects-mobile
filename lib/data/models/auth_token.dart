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
    final data = <String, dynamic>{};
    data['token'] = token;
    data['expires'] = expires;

    return data;
  }
}
