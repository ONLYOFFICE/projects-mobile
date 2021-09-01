import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final secureStorage = const FlutterSecureStorage();

  Future<String> getString(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> putString(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future readAll() async => await secureStorage.readAll();

  Future<void> delete(String key) async => await secureStorage.delete(key: key);

  Future<void> deleteAll() async => await secureStorage.deleteAll();
}
