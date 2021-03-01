import 'package:flutter/material.dart';

import 'package:only_office_mobile/data/enums/loginstate.dart';
import 'package:only_office_mobile/domain/viewmodels/login_viewmodel.dart';
import 'package:only_office_mobile/presentation/views/login_view/widgets/password_form.dart';
import 'package:only_office_mobile/presentation/views/login_view/widgets/portal_form.dart';

class Authorization extends StatefulWidget {
  final LoginViewModel viewmodel;
  Authorization({this.viewmodel});

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController portalController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //TODO Separate to different stateful vidgets: portalscreen and loginscreen
            widget.viewmodel.loginState == LoginState.Portal
                ? PortalForm(viewmodel: widget.viewmodel)
                : PasswordForm(viewmodel: widget.viewmodel)
          ],
        ),
      ),
    );
  }
}
