class Contact {
  Contact({this.type, this.value});

  Contact.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  String type;
  String value;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
