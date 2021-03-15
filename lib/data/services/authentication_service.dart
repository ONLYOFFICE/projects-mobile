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
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:only_office_mobile/data/api/authentication_api.dart';
import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/data/models/error.dart';
import 'package:only_office_mobile/data/models/portal_user.dart';
import 'package:only_office_mobile/data/models/self_user_profile.dart';
import 'package:only_office_mobile/data/services/secure_storage.dart';
import 'package:only_office_mobile/domain/dialogs.dart';
import 'package:only_office_mobile/internal/locator.dart';

class AuthenticationService {
  AuthApi _api = locator<AuthApi>();
  var _secureStorage = locator<Storage>();

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

    _secureStorage.putString('token', authResponse.response.token);
    _secureStorage.putString('expires', authResponse.response.expires);

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
