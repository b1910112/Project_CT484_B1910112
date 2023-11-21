import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';
import '../models/http_exception.dart';

class AuthService {
  static const _authTokenKey = 'authToken';
  late final String? _apiKey;

  AuthService() {
    _apiKey = dotenv.env['FIREBASE_API_KEY'];
  }

  String _buildAuthUrl(String method) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=$_apiKey';
  }

  // Phương thức xác thực chung
  Future<AuthToken> _authenticate(
      String email, String password, String method) async {
    try {
      final url = Uri.parse(_buildAuthUrl(method));
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseJson = json.decode(response.body);
      if (responseJson['error'] != null) {
        throw HttpException.firebase(responseJson['error']['message']);
      }

      // Chuyển đổi dữ liệu JSON thành đối tượng AuthToken
      final authToken = _fromJson(responseJson);

      // Ghi log thông tin đăng nhập
      log('User ID: ${authToken.userId}');
      log('Auth Token: ${authToken.token!}');

      // Lưu AuthToken vào SharedPreferences
      _saveAuthToken(authToken);

      return authToken;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Phương thức đăng ký
  Future<AuthToken> signup(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  // Phương thức đăng nhập
  Future<AuthToken> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Phương thức lưu AuthToken vào SharedPreferences
  Future<void> _saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_authTokenKey, json.encode(authToken.toJson()));
  }

  // Phương thức chuyển đổi dữ liệu JSON thành đối tượng AuthToken
  AuthToken _fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['idToken'],
      userId: json['localId'],
      expiryDate: DateTime.now().add(
        Duration(
          seconds: int.parse(
            json['expiresIn'],
          ),
        ),
      ),
    );
  }

  // Phương thức load AuthToken đã lưu từ SharedPreferences
  Future<AuthToken?> loadSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_authTokenKey)) {
      return null;
    }

    final savedToken = prefs.getString(_authTokenKey);

    final authToken = AuthToken.fromJson(json.decode(savedToken!));
    if (!authToken.isValid) {
      return null;
    }
    return authToken;
  }

  // Phương thức xóa AuthToken đã lưu từ SharedPreferences
  Future<void> clearSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_authTokenKey);
  }
}
