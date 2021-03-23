import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = FlutterSecureStorage();

  Future<String> getString(String key) async {
    return await storage.read(key: key);
  }

  Future<void> putString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
}
