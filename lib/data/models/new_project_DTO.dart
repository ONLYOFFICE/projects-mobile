// ignore_for_file: file_names

/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

class NewProjectDTO {
  String? title;
  String? description;
  String? responsibleId;
  String? tags;
  bool? private;
  List<Participant>? participants;
  bool? notify;

  // List<Null> tasks;
  // List<Null> milestones;
  bool? notifyResponsibles;

  NewProjectDTO(
      {this.title,
      this.description,
      this.responsibleId,
      this.tags,
      this.private,
      this.participants,
      this.notify,
      // tasks,
      // milestones,
      this.notifyResponsibles});

  NewProjectDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String?;
    description = json['description'] as String?;
    responsibleId = json['responsibleId'] as String?;
    tags = json['tags'] as String?;
    private = json['private'] as bool?;
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants!.add(Participant.fromJson(v as Map<String, dynamic>));
      });
    }
    notify = json['notify'] as bool?;
    notifyResponsibles = json['notifyResponsibles'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['responsibleId'] = responsibleId;
    data['tags'] = tags;
    data['private'] = private;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['notify'] = notify;
    // if (tasks != null) {
    //   data['tasks'] = tasks.map((v) => v.toJson()).toList();
    // }
    // if (milestones != null) {
    //   data['milestones'] = milestones.map((v) => v.toJson()).toList();
    // }
    data['notifyResponsibles'] = notifyResponsibles;
    return data;
  }
}

class Participant {
  String? iD;
  bool? canReadFiles;
  bool? canReadMilestones;
  bool? canReadMessages;
  bool? canReadTasks;
  bool? canReadContacts;

  Participant({
    this.iD,
    // this.projectID,
    this.canReadFiles,
    this.canReadMilestones,
    this.canReadMessages,
    this.canReadTasks,
    this.canReadContacts,
  });

  Participant.fromJson(Map<String, dynamic> json) {
    iD = json['ID'] as String?;
    canReadFiles = json['CanReadFiles'] as bool?;
    canReadMilestones = json['CanReadMilestones'] as bool?;
    canReadMessages = json['CanReadMessages'] as bool?;
    canReadTasks = json['CanReadTasks'] as bool?;
    canReadContacts = json['CanReadContacts'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = iD;
    data['CanReadFiles'] = canReadFiles;
    data['CanReadMilestones'] = canReadMilestones;
    data['CanReadMessages'] = canReadMessages;
    data['CanReadTasks'] = canReadTasks;
    data['CanReadContacts'] = canReadContacts;
    return data;
  }
}

class EditProjectDTO {
  String? title;
  String? description;
  String? responsibleId;
  String? tags;
  List<Participant>? participants;
  bool? private;
  int? status;
  bool? notify;

  EditProjectDTO({
    this.title,
    this.description,
    this.responsibleId,
    this.tags,
    this.participants,
    this.private,
    this.status,
    this.notify,
  });

  EditProjectDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String?;
    description = json['description'] as String?;
    responsibleId = json['responsibleId'] as String?;
    tags = json['tags'] as String?;
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants!.add(Participant.fromJson(v as Map<String, dynamic>));
      });
    }
    private = json['private'] as bool?;
    status = json['status'] as int?;
    notify = json['notify'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['responsibleId'] = responsibleId;
    data['tags'] = tags;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.iD).toList();
    }
    data['private'] = private;
    data['status'] = status;
    // data['notify'] = notify;
    return data;
  }
}
