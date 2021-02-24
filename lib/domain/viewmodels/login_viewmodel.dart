import 'dart:async';

import 'package:only_office_mobile/data/enums/loginstate.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/domain/viewmodels/base_viewmodel.dart';
import 'package:only_office_mobile/internal/locator.dart';

class LoginViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String errorMessage;

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

  validatePortal(String portalName) {
    //TODO
    // validate portal and get portal capabilities}

    setLoginState(LoginState.Password);
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

  String portalValidator(value) {
    if (value.isEmpty) return 'Введите корректный адрес портала';

    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.onlyoffice+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;
    return 'Введите корректный адрес портала';
  }

  LoginState _loginState = LoginState.Portal;

  LoginState get loginState => _loginState;

  void setLoginState(LoginState viewState) {
    _loginState = viewState;
    notifyListeners();
  }
}
