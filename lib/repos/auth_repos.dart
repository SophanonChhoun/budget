import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepo {
  final _storage = new FlutterSecureStorage();

  Future<bool> verifyExistingPin() async {
    String pin = await _storage.read(key: 'pin');

    if (pin == null) {
      return false;
    }

    return true;
  }

  Future<void> deletePin() async {
    await _storage.delete(key: 'pin');

    print("Delete done");
  }

  Future<void> savePin(String pinCode) async {
    if (await verifyExistingPin() == true) {
      deletePin();
    }
    print("Saving Pin");
    _storage.write(key: 'pin', value: pinCode).then((value) {
      print("Pin saved");
    });
  }

  Future<bool> verifyPin(String pinCode) async {
    String pin = await _storage.read(key: 'pin');
    print("Current Pin: $pin");
    print("Pin code: $pinCode");

    if (pin == pinCode) {
      return true;
    }

    return false;
  }
}
