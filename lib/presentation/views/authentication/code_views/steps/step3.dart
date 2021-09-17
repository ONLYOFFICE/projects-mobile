part of '../get_code_views.dart';

class _Step3 extends StatelessWidget {
  const _Step3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(tr('step3'), style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.authentificator_s3, isPng: true, height: 184.5),
        const SizedBox(height: 23),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Text(
            tr('step3SetupText1'),
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
            tr('step3SetupText2'),
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
    var controller = Get.find<LoginController>();
    var code = _splitCode(controller.tfaKey);

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              tr('code'),
              style: TextStyleHelper.caption(
                  color: Get.theme.colors().onSurface.withOpacity(0.6)),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              Text(code,
                  style: TextStyleHelper.subtitle2(
                      color: Get.theme.colors().onSurface)),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: code.removeAllWhitespace));
                  MessagesHandler.showSnackBar(
                      context: context, text: tr('keyCopied'));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: SizedBox(child: AppIcon(icon: SvgIcons.copy)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const StyledDivider()
        ],
      ),
    );
  }
}

String _splitCode(String code) {
  var result = code[0];
  for (var i = 1; i <= code.length - 1; i++) {
    if (i % 4 == 0) {
      result += ' ';
    }
    result += code[i];
  }
  return result;
}
