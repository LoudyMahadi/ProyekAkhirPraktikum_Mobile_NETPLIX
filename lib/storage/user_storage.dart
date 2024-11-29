import 'package:hive/hive.dart';

class UserStorage {
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('userBox');
  }

  static Future<void> saveUser(String username, String password) async {
    await _box.put('username', username);
    await _box.put('password', password);
  }

  static String? getUsername() {
    return _box.get('username');
  }

  static String? getPassword() {
    return _box.get('password');
  }

  static Future<void> clear() async {
    await _box.clear();
  }

  static Future<void> clearUser() async {
    await _box.clear(); // Hapus semua data dalam box
  }

  static String? getUserId() {}
}
