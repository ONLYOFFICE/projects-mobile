import 'package:flutter/foundation.dart';

void printWarning(var data) => debugPrint('\x1B[33m$data\x1B[0m');

void printError(var data) => print('\x1B[31m$data\x1B[0m');
