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

  final appStoreDocuments =
      'https://apps.apple.com/app/onlyoffice-documents/id944896972';
  final forumSupport = 'https://cloud.onlyoffice.org/viewforum.php?f=48';
  final userAgreement = 'https://www.onlyoffice.com/legalterms.aspx';
  final help = 'https://helpcenter.onlyoffice.com/userguides/projects.aspx';
  final supportMail = 'mailto:support@onlyoffice.com';
  final openDocument = 'oodocuments://openfile?data=';
}

class _ConstIdentificator {
  const _ConstIdentificator();

  final projectsAndroidAppBundle = 'com.onlyoffice.projects';
  final projectsAppStore = '1353395928';
  final documentsAndroidAppBundle = 'com.onlyoffice.documents';
  final tfa2GoogleAppStore = '388497605';
  final tfa2GooglePlayAppBundle = 'com.google.android.apps.authenticator2';
}
