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

class Status {
  int? statusType;
  bool? canChangeAvailable;
  int? id;
  String? image;
  String? imageType;
  String? title;
  String? description;
  String? color;
  int? order;
  bool? isDefault;
  bool? available;

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
    statusType = json['statusType'] as int?;
    canChangeAvailable = json['canChangeAvailable'] as bool?;
    id = json['id'] as int?;
    image = json['image'] as String?;
    imageType = json['imageType'] as String?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    color = json['color'] as String?;
    order = json['order'] as int?;
    isDefault = json['isDefault'] as bool?;
    available = json['available'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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

  bool get isNull => id == null || title == null;
}
