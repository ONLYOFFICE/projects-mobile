import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class Storage {
  final _storage = GetStorage();

  Future read(String key, {bool returnCopy = false}) async {
    var data = await _storage.read(key);

    if (returnCopy) return json.decode(json.encode(data));

    return data;
  }

  // ignore: always_declare_return_types
  getValue(String key) => _storage.read(key);

  Future getKeys() async => await _storage.getKeys();

  Future getValues() async => await _storage.getValues();

  Future write(String key, var value) async => await _storage.write(key, value);

  Future<void> remove(String key) async => await _storage.remove(key);

  Future<void> removeAll() async => await _storage.erase();
}
