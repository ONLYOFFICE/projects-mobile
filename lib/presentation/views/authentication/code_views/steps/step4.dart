part of '../get_code_views.dart';

class _Step4 extends StatelessWidget {
  const _Step4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    var codeController = MaskedTextController(mask: '000 000');

    return Column(
      children: [
        const SizedBox(height: 12),
        Text(tr('step4'), style: _stepStyle(context)),
        const SizedBox(height: 16.5),
        AppIcon(icon: PngIcons.code_light, isPng: true, height: 184.5),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Text(
            tr('step4SetupText1'),
            textAlign: TextAlign.center,
            style: _setup1Style(context),
          ),
        ),
        const SizedBox(height: 40.59),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: tr('code'),
                contentPadding:
                    const EdgeInsets.only(left: 12, bottom: 8, top: 2),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.5,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
                labelStyle: TextStyleHelper.caption(
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6))),
            style: TextStyleHelper.subtitle1(
                color: Theme.of(context).customColors().onSurface),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            tr('step4SetupText2'),
            textAlign: TextAlign.center,
            style: _setup2Style(context),
          ),
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: WideButton(
            text: tr('confirm'),
            onPressed: () async =>
                await controller.sendCode(codeController.text),
          ),
        )
      ],
    );
  }
}
