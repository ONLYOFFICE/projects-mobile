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

part of 'select_item_template.dart';

class AppBarTitleWithSearch extends StatelessWidget {
  const AppBarTitleWithSearch({
    Key? key,
    required this.appBarText,
    required this.searchController,
  }) : super(key: key);

  final BaseSearchController searchController;
  final String appBarText;

  @override
  Widget build(BuildContext context) {
    void _clearFunction() {
      if (searchController.switchToSearchView.value) searchController.clearSearch();

      searchController.switchToSearchView.value = !searchController.switchToSearchView.value;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => searchController.switchToSearchView.value
              ? Expanded(
                  child: SearchField(
                    controller: searchController.textController,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    autofocus: true,
                    alwaysShowSuffixIcon: true,
                    hintText: tr('enterQuery'),
                    onSubmitted: searchController.search,
                    onChanged: searchController.search,
                    onClearPressed: _clearFunction,
                  ),
                )
              : Text(
                  appBarText,
                  style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
                ),
        ),
      ],
    );
  }
}
