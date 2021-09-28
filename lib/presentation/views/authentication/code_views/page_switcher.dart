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
  ValueNotifier<double> page = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      page.value = widget.pageController.page;
    });
  }

  double get _backButtonOpacity {
    if (page.value >= 1) return 1;
    if (page.value <= 0.6) return 0;
    var value = (page.value - 0.6) / 0.4;
    return value;
  }

  double get _nextButtonOpacity {
    if (page.value <= 2) return 1;
    if (page.value >= 2.4) return 0;
    var value = (0.4 - (page.value - 2)) / 0.4;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    const _duration = Duration(milliseconds: 250);
    const _curve = Curves.easeIn;
    var _buttonsStyle =
        TextStyleHelper.button(color: Get.theme.colors().primary);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Get.theme.colors().backgroundColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                offset: const Offset(0, 0.85),
                color: Get.theme.colors().onSurface.withOpacity(0.19),
              ),
              BoxShadow(
                blurRadius: 1,
                offset: const Offset(0, 0.25),
                color: Get.theme.colors().onSurface.withOpacity(0.039),
              ),
            ]),
        child: ValueListenableBuilder(
          valueListenable: page,
          builder: (_, value, __) {
            return Row(
              children: [
                const SizedBox(width: 6),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: _backButtonOpacity,
                  child: TextButton(
                    onPressed: () {
                      if (value >= 1)
                        return widget.pageController
                            .previousPage(duration: _duration, curve: _curve);
                    },
                    child: Text(tr('back'), style: _buttonsStyle),
                  ),
                ),
                const Expanded(child: SizedBox()),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: _nextButtonOpacity,
                  child: TextButton(
                    onPressed: () async {
                      if (value <= 2)
                        await widget.pageController
                            .nextPage(duration: _duration, curve: _curve);
                    },
                    child: Text(tr('next'), style: _buttonsStyle),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            );
          },
        ),
      ),
    );
  }
}
