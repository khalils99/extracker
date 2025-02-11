import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

import '../../domain/user_model.dart';

class UserRepo {
  static final UserRepo _instance = UserRepo._internal();

  factory UserRepo() => _instance;

  late Box _userBox;

  UserRepo._internal() {
    _userBox = Hive.box('user_data');
  }

  _encryptToken(String? token) {
    if (token == null) {
      return null;
    }
    final key = dotenv.env['HASH_KEY'];
    if (key == null) {
      throw Exception('HASH_KEY not found');
    }
    final iv = encrypt.IV.allZerosOfLength(16);
    final hashedPin = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)))
        .encrypt(token, iv: iv);
    if (hashedPin.base64.isNotEmpty) {
      return hashedPin.base64;
    }
    return null;
  }

  _decryptToken(String? token) {
    if (token == null) {
      return null;
    }
    final key = dotenv.env['HASH_KEY'];
    if (key == null) {
      throw Exception('HASH_KEY not found');
    }
    final iv = encrypt.IV.allZerosOfLength(16);
    final hashedPin = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)))
        .decrypt(encrypt.Encrypted.fromBase64(token), iv: iv);
    if (hashedPin.isNotEmpty) {
      return hashedPin;
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', {
      'id': user.id,
      'email': user.email,
      'token': await _encryptToken(user.token),
    });
  }

  Future<UserModel?> getUserModel() async {
    final data = await _userBox.get('current_user');
    if (data != null) {
      return UserModel(
          id: data['id'],
          email: data['email'],
          token: await _decryptToken(data['token']));
    }
    return null;
  }

  Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }
}
