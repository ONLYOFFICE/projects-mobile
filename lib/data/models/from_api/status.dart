class Status {
  int statusType;
  bool canChangeAvailable;
  int id;
  String image;
  String imageType;
  String title;
  String description;
  String color;
  int order;
  bool isDefault;
  bool available;

  Status(
      {this.statusType,
      this.canChangeAvailable,
      this.id,
      this.image,
      this.imageType,
      this.title,
      this.description,
      this.color,
      this.order,
      this.isDefault,
      this.available});

  Status.fromJson(Map<String, dynamic> json) {
    statusType = json['statusType'];
    canChangeAvailable = json['canChangeAvailable'];
    id = json['id'];
    image = json['image'];
    imageType = json['imageType'];
    title = json['title'];
    description = json['description'];
    color = json['color'];
    order = json['order'];
    isDefault = json['isDefault'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusType'] = statusType;
    data['canChangeAvailable'] = canChangeAvailable;
    data['id'] = id;
    data['image'] = image;
    data['imageType'] = imageType;
    data['title'] = title;
    data['description'] = description;
    data['color'] = color;
    data['order'] = order;
    data['isDefault'] = isDefault;
    data['available'] = available;
    return data;
  }
}
