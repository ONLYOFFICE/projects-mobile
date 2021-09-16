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

class _Step3 extends StatelessWidget {
  const _Step3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(tr('step3'), style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.authentificator_s3, isPng: true, height: 184.5),
        const SizedBox(height: 23),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Text(
            tr('step3SetupText1'),
            textAlign: TextAlign.center,
            style: _setup1Style(context),
          ),
        ),
        const SizedBox(height: 10),
        const _Code(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            tr('step3SetupText2'),
            textAlign: TextAlign.center,
            style: _setup2Style(context),
          ),
        ),
      ],
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    var code = _splitCode(controller.tfaKey);

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              tr('code'),
              style: TextStyleHelper.caption(
                  color: Get.theme.colors().onSurface.withOpacity(0.6)),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              Text(code,
                  style: TextStyleHelper.subtitle2(
                      color: Get.theme.colors().onSurface)),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: code.removeAllWhitespace));
                  MessagesHandler.showSnackBar(
                      context: context, text: tr('keyCopied'));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: SizedBox(child: AppIcon(icon: SvgIcons.copy)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const StyledDivider()
        ],
      ),
    );
  }
}

String _splitCode(String code) {
  var result = code[0];
  for (var i = 1; i <= code.length - 1; i++) {
    if (i % 4 == 0) {
      result += ' ';
    }
    result += code[i];
  }
  return result;
}
