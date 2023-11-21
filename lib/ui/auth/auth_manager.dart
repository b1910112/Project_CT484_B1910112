import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../services/auth_service.dart';

/// Quản lý xác thực người dùng và token
class AuthManager with ChangeNotifier {
  AuthToken? _authToken; // Token hiện tại của người dùng
  Timer? _authTimer; // Hẹn giờ tự động đăng xuất

  final AuthService _authService = AuthService(); // Dịch vụ xác thực

  /// Kiểm tra xem người dùng có đang được xác thực hay không
  bool get isAuth {
    return authToken != null && authToken!.isValid;
  }

  /// Lấy thông tin về token hiện tại
  AuthToken? get authToken {
    return _authToken;
  }

  /// Đặt giá trị cho [_authToken], cập nhật và bắt đầu hẹn giờ tự động đăng xuất
  void _setAuthToken(AuthToken token) {
    _authToken = token;
    _autoLogout();
    notifyListeners();
  }

  /// Phương thức đăng ký người dùng
  Future<void> signup(String email, String password) async {
    _setAuthToken(await _authService.signup(email, password));
  }

  /// Phương thức đăng nhập
  Future<void> login(String email, String password) async {
    _setAuthToken(await _authService.login(email, password));
  }

  /// Thử tự động đăng nhập từ token đã lưu trữ
  Future<bool> tryAutoLogin() async {
    final savedToken = await _authService.loadSavedAuthToken();
    if (savedToken == null) {
      return false;
    }

    _setAuthToken(savedToken);
    return true;
  }

  /// Đăng xuất người dùng, đặt [_authToken] thành null và hủy bỏ hẹn giờ
  Future<void> logout() async {
    _authToken = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await _authService.clearSavedAuthToken();
  }

  /// Tự động đăng xuất người dùng dựa trên thời gian hết hạn của token
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry =
        _authToken!.expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
