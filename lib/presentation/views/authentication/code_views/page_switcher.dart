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

part of 'get_code_views.dart';

class _PageSwitcher extends StatefulWidget {
  final PageController pageController;
  _PageSwitcher({
    Key key,
    @required this.pageController,
  }) : super(key: key);

  @override
  __PageSwitcherState createState() => __PageSwitcherState();
}

class __PageSwitcherState extends State<_PageSwitcher> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    const _duration = Duration(milliseconds: 350);
    const _curve = Curves.easeIn;
    var _buttonsStyle =
        TextStyleHelper.button(color: Theme.of(context).customColors().primary);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).customColors().backgroundColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                offset: const Offset(0, 0.85),
                color: Theme.of(context)
                    .customColors()
                    .onSurface
                    .withOpacity(0.19),
              ),
              BoxShadow(
                blurRadius: 1,
                offset: const Offset(0, 0.25),
                color: Theme.of(context)
                    .customColors()
                    .onSurface
                    .withOpacity(0.039),
              ),
            ]),
        child: Stack(
          children: [
            if (index != 0)
              Positioned(
                  left: 8,
                  top: 3.5,
                  child: TextButton(
                      onPressed: () {
                        widget.pageController
                            .previousPage(duration: _duration, curve: _curve);
                        setState(() => index--);
                      },
                      child: Text('BACK', style: _buttonsStyle))),
            if (index != 3)
              Positioned(
                right: 8,
                top: 3.5,
                child: TextButton(
                    onPressed: () {
                      widget.pageController
                          .nextPage(duration: _duration, curve: _curve);
                      setState(() => index++);
                    },
                    child: Text('NEXT', style: _buttonsStyle)),
              ),
          ],
        ),
      ),
    );
  }
}
