import 'dart:core';

import 'package:projects/data/models/from_api/portal_user.dart';

class Item {
  Item({
    this.id,
    this.title,
    this.status,
    this.responsible,
    this.date,
    this.subCount,
    this.isImportant,
  });
  int id;
  String title;
  int status;
  PortalUser responsible;
  String date;
  int subCount;
  bool isImportant;
}
