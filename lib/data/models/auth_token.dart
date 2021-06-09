class AuthToken {
  AuthToken({
    this.expires,
    this.sms,
    this.tfa,
    this.tfaKey,
    this.token,
  });

  bool tfa;
  bool sms;
  String token;
  String tfaKey;
  String expires;

  AuthToken.fromJson(Map<String, dynamic> json) {
    expires = json['expires'];
    sms = json['sms'];
    token = json['token'];
    tfa = json['tfa'];
    tfaKey = json['tfaKey'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['sms'] = sms;
    data['expires'] = expires;
    data['tfa'] = tfa;
    data['tfaKey'] = tfaKey;

    return data;
  }
}
