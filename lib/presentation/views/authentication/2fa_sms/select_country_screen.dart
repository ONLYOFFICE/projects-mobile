import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/2fa_sms_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectCountryScreen extends StatelessWidget {
  const SelectCountryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TFASmsController>();

    var previousContrysFirstLetter = '';

    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          titleText:
              controller.searching.value == true ? null : tr('selectCountry'),
          title:
              controller.searching.value == true ? const _SarchField() : null,
          actions: [
            if (controller.searching.value == false)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: controller.onSearchPressed,
              )
          ],
        ),
        body: ListView.builder(
          itemCount: controller.countriesToShow.length,
          itemBuilder: (BuildContext context, int index) {
            if (controller.countriesToShow[index].countryName[0] !=
                previousContrysFirstLetter) {
              previousContrysFirstLetter =
                  controller.countriesToShow[index].countryName[0];
              return _CountryWithCodeTile(
                showFirstLetter: true,
                showBorder: index != 0 ? true : false,
                country: controller.countriesToShow[index],
              );
            }

            return _CountryWithCodeTile(
                country: controller.countriesToShow[index]);
          },
        ),
      ),
    );
  }
}

class _SarchField extends StatelessWidget {
  const _SarchField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TFASmsController>();

    return TextField(
      autofocus: true,
      style: TextStyleHelper.headline6(),
      decoration: InputDecoration.collapsed(
        hintText: tr('search'),
        hintStyle: TextStyleHelper.headline6().copyWith(height: 1),
      ),
      onChanged: (value) => controller.onSearch(value),
    );
  }
}

class _CountryWithCodeTile extends StatelessWidget {
  final CountryWithPhoneCode country;
  final bool showBorder;
  final bool showFirstLetter;
  const _CountryWithCodeTile({
    Key key,
    @required this.country,
    this.showFirstLetter = false,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TFASmsController>();
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
                      ? Text(country?.countryName[0],
                          style: TextStyleHelper.headline5(
                              color: Get.theme
                                  .colors()
                                  .onBackground
                                  .withOpacity(0.6)))
                      : null,
                ),
                Expanded(
                  child: Text(
                    country?.countryName,
                    style: TextStyleHelper.body2(
                        color: Get.theme.colors().onBackground),
                  ),
                ),
                Text(
                  '+ ${country?.phoneCode}',
                  style: TextStyleHelper.subtitle2(
                      color: Get.theme.colors().primarySurface),
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
