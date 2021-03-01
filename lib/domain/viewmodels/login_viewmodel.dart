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

import 'dart:async';

import 'package:only_office_mobile/data/enums/loginstate.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/data/services/portal_service.dart';
import 'package:only_office_mobile/domain/viewmodels/base_viewmodel.dart';
import 'package:only_office_mobile/internal/locator.dart';

class LoginViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final PortalService _portalService = locator<PortalService>();

  Capabilities capabilities;

  Future<bool> login(String email, String pass, String portalName) async {
    setState(ViewState.Busy);

    StreamController<User>().stream.handleError(onError);

    var success = await _authenticationService.login(email, pass, portalName);

    // Handle potential error here too.

    setState(ViewState.Idle);
    return success;
  }

  onError() {
    setState(ViewState.Idle);
  }

  loginByPassword(String username, String password) {
    //todo
    // refactor login process
  }

  Future<bool> prepareAuthorization(String portalName) async {
    //TODO
    // validate portal and get portal capabilities}
    setState(ViewState.Busy);
    var _capabilities = await _portalService.portalCapabilities(portalName);

    if (_capabilities.response != null) {
      capabilities = _capabilities.response;
      setLoginState(LoginState.Login);
    }
    setState(ViewState.Idle);
    return true;
  }

  String emailValidator(value) {
    if (value.isEmpty) return 'Введите корректный email';

    /// regex pattern to validate email inputs.
    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;

    return 'Введите корректный email';
  }

  String passValidator(value) {
    if (!value.isEmpty) return null;
    return 'Введите пароль';
  }

  LoginState _loginState = LoginState.Portal;

  LoginState get loginState => _loginState;

  void setLoginState(LoginState viewState) {
    _loginState = viewState;
    notifyListeners();
  }
}
