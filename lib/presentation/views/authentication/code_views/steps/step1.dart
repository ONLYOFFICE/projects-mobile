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

part of '../get_code_views.dart';

class _Step1 extends StatelessWidget {
  const _Step1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _setupText1 =
        'Set up an application to generate the authentication codes';
    const _setupText2 =
        'Please set up an application to generate the codes for the portal access (e.g. Google Authenticator) to continue the work at the portalx';

    return Column(
      children: [
        const SizedBox(height: 12),
        Text('Step 1 of 4', style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.download_GA, isPng: true, height: 184.5),
        const SizedBox(height: 23),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Text(
            _setupText1,
            textAlign: TextAlign.center,
            style: _setup1Style(context),
          ),
        ),
        const SizedBox(height: 34),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _setupText2,
            textAlign: TextAlign.center,
            style: _setup2Style(context),
          ),
        ),
        const SizedBox(height: 70),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: WideButton(
            text: 'Install',
            onPressed: () {
              // TODO change the package
              LaunchReview.launch(
                androidAppId: 'com.google.android.apps.authenticator2',
                iOSAppId: '388497605',
                writeReview: false,
              );
            },
          ),
        )
      ],
    );
  }
}
