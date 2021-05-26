part of '../get_code_views.dart';

class _Step3 extends StatelessWidget {
  const _Step3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _setupText1 = 'Add a secret key';
    const _setupText2 =
        'Copy the key and paste it to the Google Authenticator application';

    return Column(
      children: [
        const SizedBox(height: 12),
        Text('Step 3 of 4', style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.authentificator_s3, isPng: true, height: 184.5),
        const SizedBox(height: 23),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Text(
            _setupText1,
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
            _setupText2,
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
    var code = 'WWWW WWWW WWWW WWWW';

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              'Code',
              style: TextStyleHelper.caption(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6)),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              Text(code,
                  style: TextStyleHelper.subtitle2(
                      color: Theme.of(context).customColors().onSurface)),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
                      context: context, text: 'Key copied to clipboard.'));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: SizedBox(child: AppIcon(icon: SvgIcons.copy)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const StyledDivider()
        ],
      ),
    );
  }
}
