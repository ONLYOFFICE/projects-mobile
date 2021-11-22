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

class NewTaskDTO {
  NewTaskDTO({
    this.copyFiles,
    this.copySubtasks,
    this.deadline,
    this.description,
    this.id,
    this.milestoneid,
    this.notify,
    this.priority,
    this.projectId,
    this.removeOld,
    this.responsibles,
    this.startDate,
    this.title,
  });

  final String? description;
  final String? priority;
  final String? title;
  final int? id;
  final int? milestoneid;
  final int? projectId;
  final List<String?>? responsibles;
  // DateTime here but Iso8601String when sends to api
  final DateTime? deadline;
  // DateTime here but Iso8601String when sends to api
  final DateTime? startDate;
  // currently this is only used when copying
  final bool? copyFiles;
  // currently this is only used when copying
  final bool? copySubtasks;
  final bool? notify;
  // currently this is only used when copying
  final bool? removeOld;

  factory NewTaskDTO.fromJson(Map<String, dynamic> json) => NewTaskDTO(
        description: json['description'],
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        id: json['id'],
        priority: json['priority'],
        title: json['title'],
        milestoneid: json['milestoneid'],
        projectId: json['projectid'],
        responsibles: List<String>.from(json['responsibles'].map((x) => x)),
        notify: json['notify'],
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : null,
        copyFiles: json['copyFiles'],
        copySubtasks: json['copySubtasks'],
        removeOld: json['removeOld'],
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'deadline': deadline != null ? deadline!.toIso8601String() : null,
        'id': id,
        'priority': priority,
        'title': title,
        'milestoneid': milestoneid,
        'projectid': projectId,
        'responsibles': responsibles != null
            ? List<dynamic>.from(responsibles!.map((x) => x))
            : null,
        'notify': notify,
        'startDate': startDate != null ? startDate!.toIso8601String() : null,
        'copyFiles': copyFiles,
        'copySubtasks': copySubtasks,
        'removeOld': removeOld,
      };
}
