import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/internal/locator.dart';

class AnalyticsService {

  AnalyticsService._privateConstructor();
  static final AnalyticsService shared = AnalyticsService._privateConstructor();

  // Event names
  static const _AnalyticsEvents Events = const _AnalyticsEvents();
  static const _AnalyticsParams Params = const _AnalyticsParams();

  // Private
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final _storage = locator<Storage>();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);


  // Lifecycle Methods
  Future<void> logEvent(String event, Map<String, Object> parameters) async {
    var allowAnalytics = await _storage.read('shareAnalytics');

    // Allow analytics by default
    if (allowAnalytics == null || allowAnalytics) {
      await _analytics.logEvent(name: event, parameters: parameters);
    }
  }

}

class _AnalyticsEvents {
  const _AnalyticsEvents();

  final createPortal     = 'portal_create';
  final loginPortal      = 'portal_login';
  final switchAccount    = 'account_switch';
  final openEditor       = 'open_editor';
  final openPdf          = 'open_pdf';
  final openMedia        = 'open_media';
  final openExternal     = 'open_external';
  final createEntity     = 'create_entity';
  final editEntity       = 'edit_entity';
  final deleteEntity     = 'delete_entity';
}

class _AnalyticsParams {
  const _AnalyticsParams();

  final _AnalyticsParamKeys Key = const _AnalyticsParamKeys();
  final _AnalyticsParamValues Value = const _AnalyticsParamValues();
}

class _AnalyticsParamKeys {
  const _AnalyticsParamKeys();

  final portal    = 'portal';
  final entity    = 'entity';
  final extension = 'extension';
}

class _AnalyticsParamValues {
  const _AnalyticsParamValues();

  final project   = 'project';
  final task      = 'task';
  final subtask   = 'subtask';
  final milestone = 'milestone';
  final discussion= 'discussion';
  final reply     = 'reply';
  final folder    = 'folder';
  final file      = 'file';
}
