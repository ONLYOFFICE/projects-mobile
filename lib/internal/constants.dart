// ignore_for_file: avoid_field_initializers_in_const_classes

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

import 'package:projects/presentation/shared/widgets/app_icons.dart';

class Const {
  static const _ConstUrl Urls = _ConstUrl();
  static const _ConstIdentificator Identificators = _ConstIdentificator();

  static const Map<int, String> standartTaskStatuses = {
    -1: SvgIcons.taskOpen,
    -2: SvgIcons.taskClosed,
  };
}

class _ConstUrl {
  const _ConstUrl();

  final appStoreDocuments = 'https://apps.apple.com/app/onlyoffice-documents/id944896972';
  final forumSupport = 'https://cloud.onlyoffice.org/viewforum.php?f=48';
  final userAgreement = 'https://www.onlyoffice.com/legalterms.aspx';
  final help = 'https://helpcenter.onlyoffice.com/mobile-applications/androidprojects/index.aspx';
  final supportMail = 'mailto:support@onlyoffice.com';
  final openDocument = 'oodocuments://openfile?data=';
}

class _ConstIdentificator {
  const _ConstIdentificator();

  final projectsAndroidAppBundle = 'com.onlyoffice.projects';
  final projectsAppStore = '1353395928';
  final documentsAndroidAppBundle = 'com.onlyoffice.documents';
  final documentsAppStore = '944896972';
  final tfa2GoogleAppStore = '388497605';
  final tfa2GooglePlayAppBundle = 'com.google.android.apps.authenticator2';
}
