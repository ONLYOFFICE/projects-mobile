import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_office_mobile/data/enums/loginstate.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/domain/viewmodels/login_viewmodel.dart';
import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';
import 'package:only_office_mobile/presentation/views/login_view/widgets/password_form.dart';
import 'package:only_office_mobile/presentation/views/login_view/widgets/portal_form.dart';

class LoginForm extends StatefulWidget {
  final LoginViewModel viewmodel;
  LoginForm({this.viewmodel});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    final emailField = TextFormField(
      controller: emailController,
      validator: widget.viewmodel.emailValidator,
      autofillHints: [AutofillHints.email],
      obscureText: false,
      style: mainStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Регистрационный email",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final passwordField = TextFormField(
      validator: widget.viewmodel.passValidator,
      controller: passController,
      autofillHints: [AutofillHints.password],
      obscureText: true,
      style: mainStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Пароль",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final portalField = TextFormField(
      validator: widget.viewmodel.portalValidator,
      controller: portalController,
      autofillHints: [AutofillHints.url],
      obscureText: false,
      style: mainStyle,
      decoration: InputDecoration(
        prefixIcon: Text(
          'https://',
          style: mainStyle,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Адрес портала",
        // border:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    var onLoginPressed = () async {
      var loginSuccess = await widget.viewmodel.login(
          emailController.text, passController.text, portalController.text);
      if (loginSuccess) {
        Navigator.pushNamed(context, '/');
      }
    };
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onLoginPressed,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: mainStyle.copyWith(
                color: backgroundColor, fontWeight: FontWeight.bold)),
      ),
    );

    // final String assetName = 'resources/logo_new.svg';
    // final Widget svg =
    //     SvgPicture.asset(assetName, semanticsLabel: 'resources/logo_new.svg');

    return new Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // svg,
            // SizedBox(height: 10.0),
            // emailField,
            // SizedBox(height: 10.0),
            // passwordField,
            // SizedBox(height: 10.0),
            // portalField,
            // SizedBox(
            //   height: 10.0,
            // ),
            // loginButon,
            widget.viewmodel.loginState == LoginState.Portal
                ? PortalForm(viewmodel: widget.viewmodel)
                : PasswordForm(viewmodel: widget.viewmodel)
            // SizedBox(
            //   height: 15.0,
            // ),
          ],
        ),
      ),
    );
  }
}
