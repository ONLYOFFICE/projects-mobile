import 'package:html/parser.dart';

String parseHtml(String htmlString) {
  final document = parse(htmlString);
  final parsedString = parse(document.body.text).documentElement.text;

  return parsedString ?? '';
}
