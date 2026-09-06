import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static const _registered = 'account_registered';
  static const _name = 'account_name';
  static const _email = 'account_email';
  static const _phone = 'account_phone';
  static const _country = 'account_country';
  static const _packageId = 'account_package_id';
  static const _paymentStatus = 'payment_status';
  static const _receiptPath = 'payment_receipt_path';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> isRegistered() async => (await _prefs).getBool(_registered) ?? false;

  Future<void> saveAccount({
    required String name,
    required String email,
    required String phone,
    required String country,
    required String packageId,
  }) async {
    final prefs = await _prefs;
    await prefs.setBool(_registered, true);
    await prefs.setString(_name, name);
    await prefs.setString(_email, email);
    await prefs.setString(_phone, phone);
    await prefs.setString(_country, country);
    await prefs.setString(_packageId, packageId);
    await prefs.setString(_paymentStatus, 'not_submitted');
  }

  Future<String> get name async => (await _prefs).getString(_name) ?? '';
  Future<String> get email async => (await _prefs).getString(_email) ?? '';
  Future<String> get phone async => (await _prefs).getString(_phone) ?? '';
  Future<String> get country async => (await _prefs).getString(_country) ?? 'Nigeria';
  Future<String> get packageId async => (await _prefs).getString(_packageId) ?? '';
  Future<String> get paymentStatus async => (await _prefs).getString(_paymentStatus) ?? 'not_submitted';
  Future<String?> get receiptPath async => (await _prefs).getString(_receiptPath);

  Future<void> saveReceipt(String path) async {
    final prefs = await _prefs;
    await prefs.setString(_receiptPath, path);
    await prefs.setString(_paymentStatus, 'pending');
  }

  Future<void> clearAccount() async {
    final prefs = await _prefs;
    for (final key in [_registered, _name, _email, _phone, _country, _packageId, _paymentStatus, _receiptPath]) {
      await prefs.remove(key);
    }
  }
}
