import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/models/from_api/self_user_profile.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class AuthService {
  AuthApi _api = locator<AuthApi>();
  var _storage = locator<Storage>();

  Future<ApiDTO<SelfUserProfile>> getSelfInfo() async {
    ApiDTO<SelfUserProfile> authResponse = await _api.getUserInfo();

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> login(String email, String pass) async {
    ApiDTO<AuthToken> authResponse = await _api.loginByUsername(email, pass);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
      String email, String pass, String code) async {
    ApiDTO<AuthToken> authResponse =
        await _api.confirmTFACode(email, pass, code);

    var tokenReceived = authResponse.response != null;

    _storage.putString('token', authResponse.response.token);
    _storage.putString('expires', authResponse.response.expires);

    if (!tokenReceived) {
      ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      ErrorDialog.show(new CustomError(message: 'Ошибка'));
    }
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final AccessToken result = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final FacebookAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(result.token);

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);
  // }

  // Future<UserCredential> signInWithTwitter() async {
  //   // Create a TwitterLogin instance
  //   final TwitterLogin twitterLogin = new TwitterLogin(
  //     consumerKey: '<your consumer key>',
  //     consumerSecret: ' <your consumer secret>',
  //   );

  //   // Trigger the sign-in flow
  //   final TwitterLoginResult loginResult = await twitterLogin.authorize();

  //   // Get the Logged In session
  //   final TwitterSession twitterSession = loginResult.session;

  //   // Create a credential from the access token
  //   final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
  //       accessToken: twitterSession.token, secret: twitterSession.secret);

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(twitterAuthCredential);
  // }
}
