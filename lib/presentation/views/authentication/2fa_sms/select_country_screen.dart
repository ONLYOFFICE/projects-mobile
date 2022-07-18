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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/2fa_sms_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectCountryScreen extends StatelessWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TFASmsController>();

    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          titleText: controller.searching.value == true ? null : tr('selectCountry'),
          title: controller.searching.value == true ? const _SarchField() : null,
          actions: [
            if (controller.searching.value == false)
              PlatformIconButton(
                icon: Icon(PlatformIcons(context).search),
                onPressed: controller.onSearchPressed,
              )
          ],
        ),
        body: ListView.builder(
            itemCount: controller.countriesToShow.length,
            itemBuilder: (BuildContext context, int index) {
              return _CountryWithCodeTile(
                showFirstLetter: controller.countriesToShow[index].showFirstLetter,
                showBorder: index != 0,
                country: controller.countriesToShow[index].countrie,
              );
            }),
      ),
    );
  }
}

class _SarchField extends StatelessWidget {
  const _SarchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TFASmsController>();

    return PlatformTextField(
      makeCupertinoDecorationNull: true,
      autofocus: true,
      style: TextStyleHelper.headline6(),
      hintText: tr('search'),
      cupertino: (_, __) => CupertinoTextFieldData(placeholderStyle: TextStyleHelper.headline6()),
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration.collapsed(
          hintText: tr('search'),
          hintStyle: TextStyleHelper.headline6().copyWith(height: 1),
        ),
      ),
      onChanged: controller.onSearch,
    );
  }
}

class _CountryWithCodeTile extends StatelessWidget {
  final CountryWithPhoneCode country;
  final bool showBorder;
  final bool showFirstLetter;
  const _CountryWithCodeTile({
    Key? key,
    required this.country,
    this.showFirstLetter = false,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TFASmsController>();
    return InkWell(
      onTap: () => controller.selectCountry(country),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (showBorder) const Divider(height: 2, thickness: 1, indent: 56),
            SizedBox(height: showFirstLetter ? 7 : 14),
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: showFirstLetter
                      ? Text(country.countryName![0],
                          style: TextStyleHelper.headline6(
                              color: Theme.of(context).colors().onBackground.withOpacity(0.6)))
                      : null,
                ),
                Expanded(
                  child: Text(
                    country.countryName!,
                    style: TextStyleHelper.body2(color: Theme.of(context).colors().onBackground),
                  ),
                ),
                Text(
                  '+ ${country.phoneCode}',
                  style: TextStyleHelper.subtitle2(
                      color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
