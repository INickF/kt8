import 'dart:convert';

import 'package:authexample/app/data/models/tokens/tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeTokens(Tokens key) async {
    await _storage.write(key: "JWT_TOKENS", value: jsonEncode(key.toJson()));
  }

  Future<Tokens?> readTokens() async {
    String? poTok = await _storage.read(key: "JWT_TOKENS");
    if (poTok == null) return null;
    return Tokens.fromJson(jsonDecode(poTok));
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: "JWT_TOKENS");
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}