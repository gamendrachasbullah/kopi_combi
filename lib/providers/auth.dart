import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:kopi_combi/dto/user.dart';
import 'package:kopi_combi/utils/dio.dart';
import 'package:kopi_combi/utils/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool authenticated = false;
  bool get isAuthenticated => authenticated;
  UserDTO? _user;
  UserDTO? get user => _user;
  final local = LocalStorage();

  setUser(payload) {
    _user = UserDTO.fromJson(payload);
    notifyListeners();
  }

  Future storeToken(String token, Map<String, dynamic> payload) async {
    await local.storeToken(token);
    authenticated = true;
    setUser(payload);
  }

  Future signUp(Map<String, dynamic> payload) async {
    try {
      di.Response res = await dioInstance().post('register', data: payload);
      Map<String, dynamic> result = await res.data;
      await storeToken(result['data']['access_token'], result['data']['user']);
      return true;
    } on di.DioException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future signIn({credential}) async {
    try {
      di.Response res = await dioInstance().post('login', data: credential);
      Map<String, dynamic> result = await res.data;
      await storeToken(result['data']['access_token'], result['data']['user']);
      return true;
    } on di.DioException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future updateProfil({credential}) async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      di.Response res = await dioInstance().post('user',
          data: credential, options: di.Options(headers: headers));
      Map<String, dynamic> result = await res.data;
      _user = UserDTO.fromJson(result['data']);
      notifyListeners();
      return true;
    } on di.DioException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future me() async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      di.Response res = await dioInstance()
          .get('user', options: di.Options(headers: headers));
      Map<String, dynamic> result = await res.data;
      setUser(result['data']);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      await Future.wait([
        dioInstance().post('logout', options: di.Options(headers: headers)),
        local.destroyToken()
      ]);
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
