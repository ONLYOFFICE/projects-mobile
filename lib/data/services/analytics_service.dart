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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/internal/locator.dart';

class AnalyticsService {
  AnalyticsService._privateConstructor();

  static final AnalyticsService shared = AnalyticsService._privateConstructor();

  // Event names
  static const Events = _AnalyticsEvents();
  static const Params = _AnalyticsParams();

  // Private
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final Storage _storage = locator<Storage>();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Lifecycle Methods
  Future<void> logEvent(String event, Map<String, Object?> parameters) async {
    final allowAnalytics = await _storage.getBool('shareAnalytics');

    // Allow analytics by default
    if (allowAnalytics == null || allowAnalytics) {
      await _analytics.logEvent(name: event, parameters: parameters);
    }
  }
}

class _AnalyticsEvents {
  const _AnalyticsEvents();

  final createPortal = 'portal_create';
  final loginPortal = 'portal_login';
  final switchAccount = 'account_switch';
  final openEditor = 'open_editor';
  final openPdf = 'open_pdf';
  final openMedia = 'open_media';
  final openExternal = 'open_external';
  final createEntity = 'create_entity';
  final editEntity = 'edit_entity';
  final deleteEntity = 'delete_entity';
}

class _AnalyticsParams {
  const _AnalyticsParams();

  // ignore: non_constant_identifier_names
  final _AnalyticsParamKeys Key = const _AnalyticsParamKeys();
  // ignore: non_constant_identifier_names
  final _AnalyticsParamValues Value = const _AnalyticsParamValues();
}

class _AnalyticsParamKeys {
  const _AnalyticsParamKeys();

  final portal = 'portal';
  final entity = 'entity';
  final extension = 'extension';
}

class _AnalyticsParamValues {
  const _AnalyticsParamValues();

  final project = 'project';
  final task = 'task';
  final subtask = 'subtask';
  final milestone = 'milestone';
  final discussion = 'discussion';
  final reply = 'reply';
  final folder = 'folder';
  final file = 'file';
}
