import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static const _registered = 'account_registered';
  static const _name = 'account_name';
  static const _email = 'account_email';
  static const _phone = 'account_phone';
  static const _country = 'account_country';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> isRegistered() async =>
      (await _prefs).getBool(_registered) ?? false;

  Future<void> saveAccount({
    required String name,
    required String email,
    required String phone,
    required String country,
  }) async {
    final prefs = await _prefs;
    await prefs.setBool(_registered, true);
    await prefs.setString(_name, name);
    await prefs.setString(_email, email);
    await prefs.setString(_phone, phone);
    await prefs.setString(_country, country);
  }

  Future<String> get name async => (await _prefs).getString(_name) ?? '';
  Future<String> get email async => (await _prefs).getString(_email) ?? '';
  Future<String> get phone async => (await _prefs).getString(_phone) ?? '';
  Future<String> get country async =>
      (await _prefs).getString(_country) ?? 'Nigeria';

  Future<void> clearAccount() async {
    final prefs = await _prefs;
    for (final key in [_registered, _name, _email, _phone, _country]) {
      await prefs.remove(key);
    }
  }
}
