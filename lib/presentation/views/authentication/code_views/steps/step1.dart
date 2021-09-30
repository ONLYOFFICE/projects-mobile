part of '../get_code_views.dart';

class _Step1 extends StatelessWidget {
  const _Step1({
    Key key,
    this.topPadding,
  }) : super(key: key);

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: topPadding),
          const SizedBox(height: 12),
          Text(tr('step1'), style: _stepStyle(context)),
          const SizedBox(height: 16.5),
          AppIcon(
            icon: PngIcons.download_GA,
            hasDarkVersion: true,
            isPng: true,
            height: 184.5.h,
          ),
          const SizedBox(height: 23),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: Text(
              tr('step1SetupText1'),
              textAlign: TextAlign.center,
              style: _setup1Style(context),
            ),
          ),
          const SizedBox(height: 34),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              tr('step1SetupText2'),
              textAlign: TextAlign.center,
              style: _setup2Style(context),
            ),
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: WideButton(
                text: tr('install'),
                onPressed: () {
                  // TODO change the package
                  LaunchReview.launch(
                    androidAppId: Const.Identificators.tfa2GooglePlayAppBundle,
                    iOSAppId: Const.Identificators.tfa2GoogleAppStore,
                    writeReview: false,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

double getTopPadding(bool isMobile, double height) {
  if (isMobile) return 0;

  const contentArea = 550;
  var freeArea = height - Get.statusBarHeight - 128;

  if (freeArea - contentArea > 0) return (freeArea - contentArea) / 3;
  return 0;
}
