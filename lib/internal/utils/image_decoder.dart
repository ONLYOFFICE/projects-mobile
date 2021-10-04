import 'dart:convert';

String decodeImageString(String image) => utf8.decode(base64.decode(image));
