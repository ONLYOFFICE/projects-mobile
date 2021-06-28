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
                      child: Text(tr('back'), style: _buttonsStyle))),
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
                    child: Text(tr('next'), style: _buttonsStyle)),
              ),
          ],
        ),
      ),
    );
  }
}
