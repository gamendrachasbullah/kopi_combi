import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = FlutterSecureStorage();

  Future storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future destroyToken() async {
    await storage.delete(key: 'token');
  }

  Future<Map<String, String>?> authorizationHeader() async {
    String? token = await getToken();
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    throw FormatException('undefined token');
  }
}
