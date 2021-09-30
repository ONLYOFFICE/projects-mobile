part of '../get_code_views.dart';

class _Step3 extends StatelessWidget {
  const _Step3({Key key, this.topPadding}) : super(key: key);

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: topPadding),
          const SizedBox(height: 12),
          Text(tr('step3'), style: _stepStyle(context)),
          const SizedBox(height: 16.5),
          AppIcon(
            icon: PngIcons.authentificator_s3,
            hasDarkVersion: true,
            isPng: true,
            height: 184.5.h,
          ),
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
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    // TODO УБРАТЬ
    String code;
    if (testMode) code = _splitCode('1234567891011121');
    if (!testMode) code = _splitCode(controller.tfaKey);
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
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: code.removeAllWhitespace));
                  MessagesHandler.showSnackBar(
                      context: context, text: tr('keyCopied'));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 10),
                  child: AppIcon(
                    icon: SvgIcons.copy,
                    color: Get.theme.colors().onBackground,
                  ),
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
