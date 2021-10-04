part of '../get_code_views.dart';

class _Step2 extends StatelessWidget {
  const _Step2({Key key, this.topPadding}) : super(key: key);

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: topPadding),
          const SizedBox(height: 12),
          Text(tr('step2'), style: _stepStyle(context)),
          const SizedBox(height: 16.5),
          AppIcon(
            icon: PngIcons.authentificator_s2,
            isPng: true,
            height: 184.5.h,
            hasDarkVersion: true,
          ),
          const SizedBox(height: 23),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: Text(tr('step2SetupText1'),
                textAlign: TextAlign.center, style: _setup1Style(context)),
          ),
          const SizedBox(height: 34),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              tr('step2SetupText2'),
              textAlign: TextAlign.center,
              style: _setup2Style(context),
            ),
          ),
        ],
      ),
    );
  }
}
