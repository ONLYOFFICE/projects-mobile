import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class HtmlTextEditor extends StatelessWidget {
  const HtmlTextEditor({
    Key key,
    this.height,
    this.hintText,
    this.hasError = false,
    this.initialText,
    this.textController,
  }) : super(key: key);

  final HtmlEditorController textController;
  final String hintText;
  final String initialText;
  final double height;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    print('has error $hasError');
    return HtmlEditor(
      plugins: [],
      controller: textController ?? HtmlEditorController(),
      htmlToolbarOptions: HtmlToolbarOptions(
        textStyle:
            TextStyleHelper.body2(color: Get.theme.colors().onBackground),
        defaultToolbarButtons: const [
          StyleButtons(),
          FontSettingButtons(fontSizeUnit: false),
          FontButtons(
            clearAll: false,
            subscript: false,
            superscript: false,
          ),
          // they don't work
          ColorButtons(foregroundColor: false, highlightColor: false),
          ListButtons(listStyles: false),
          ParagraphButtons(
            textDirection: false,
            lineHeight: false,
            caseConverter: false,
          ),
          InsertButtons(
            video: false,
            audio: false,
            table: false,
            hr: false,
            otherFile: false,
          ),
        ],
      ),
      htmlEditorOptions: HtmlEditorOptions(
        hint: hintText,
        initialText: initialText,
      ),
      otherOptions: OtherOptions(
        decoration: BoxDecoration(
          border: Border.all(
            color: Get.theme.colors().colorError,
            width: 2,
            style: hasError ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        height: Get.height - Get.bottomBarHeight - Get.statusBarHeight,
      ),
    );
  }
}
