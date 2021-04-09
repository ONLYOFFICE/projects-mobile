class Contact {
  String type;
  String value;

  Contact({this.type, this.value});

  Contact.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
