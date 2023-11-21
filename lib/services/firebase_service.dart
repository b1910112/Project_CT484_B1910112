import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/auth_token.dart';

abstract class FirebaseService {
  String? _token; // Token xác thực cho Firebase
  String? _userId; // ID người dùng cho Firebase
  late final String? databaseUrl; // URL của Realtime Database

  // Constructor với AuthToken tùy chọn để có thể truyền thông tin xác thực từ Auth Service
  FirebaseService([AuthToken? authToken])
      : _token = authToken?.token,
        _userId = authToken?.userId {
    databaseUrl = dotenv.env['FIREBASE_RTDB_URL'];
  }

  // Setter để cập nhật thông tin xác thực
  set authToken(AuthToken? authToken) {
    _token = authToken?.token;
    _userId = authToken?.userId;
  }

  // Getter bảo vệ cho Token
  @protected
  String? get token => _token;

  // Getter bảo vệ cho User ID
  @protected
  String? get userId => _userId;
}
