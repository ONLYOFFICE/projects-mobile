class AuthToken {
  AuthToken({
    this.expires,
    this.phoneNoise,
    this.sms,
    this.tfa,
    this.tfaKey,
    this.token,
  });

  bool tfa;
  bool sms;
  String expires;
  String phoneNoise;
  String token;
  String tfaKey;

  AuthToken.fromJson(Map<String, dynamic> json) {
    expires = json['expires'];
    phoneNoise = json['phoneNoise'];
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
    data['phoneNoise'] = phoneNoise;
    data['tfa'] = tfa;
    data['tfaKey'] = tfaKey;

    return data;
  }
}
