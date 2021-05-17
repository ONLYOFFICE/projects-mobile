import 'package:intl/intl.dart';

class NewMilestoneDTO {
  String title;
  DateTime deadline;
  bool isKey;
  bool isNotify;
  String description;
  String responsible;
  bool notifyResponsible;

  NewMilestoneDTO(
      {this.title,
      this.deadline,
      this.isKey,
      this.isNotify,
      this.description,
      this.responsible,
      this.notifyResponsible});

  NewMilestoneDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    deadline = json['deadline'];
    isKey = json['isKey'];
    isNotify = json['isNotify'];
    description = json['description'];
    responsible = json['responsible'];
    notifyResponsible = json['notifyResponsible'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;

    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');
    var duedate = formatter.format(deadline);
    data['deadline'] = duedate;

    data['isKey'] = isKey;
    data['isNotify'] = isNotify;
    data['description'] = description;
    data['responsible'] = responsible;
    data['notifyResponsible'] = notifyResponsible;
    return data;
  }
}
