class AuthToken {
  AuthToken({
    this.expires,
    this.tfa,
    this.tfaKey,
    this.token,
  });

  bool tfa;
  String token;
  String tfaKey;
  String expires;

  AuthToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
    tfa = json['tfa'];
    tfaKey = json['tfaKey'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['expires'] = expires;
    data['tfa'] = tfa;
    data['tfaKey'] = tfaKey;

    return data;
  }
}
