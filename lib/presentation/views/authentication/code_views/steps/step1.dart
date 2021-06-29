part of '../get_code_views.dart';

class _Step1 extends StatelessWidget {
  const _Step1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(tr('step1'), style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.download_GA, isPng: true, height: 184.5),
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
          child: WideButton(
            text: tr('install'),
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
