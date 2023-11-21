class AuthToken {
  final String _token;
  final String _userId;
  final DateTime _expiryDate;

  // Constructor
  AuthToken({
    required String token,
    required String userId,
    required DateTime expiryDate,
  })  : _token = token,
        _userId = userId,
        _expiryDate = expiryDate;

  // Kiểm tra xem token có hợp lệ không dựa trên ngày hết hạn
  bool get isValid {
    return _expiryDate.isAfter(DateTime.now());
  }

  // Lấy giá trị token nếu nó còn hợp lệ, ngược lại trả về null
  String? get token {
    if (isValid) {
      return _token;
    }
    return null;
  }

  // Lấy giá trị userId
  String get userId {
    return _userId;
  }

  // Lấy giá trị ngày hết hạn
  DateTime get expiryDate {
    return _expiryDate;
  }

  // Chuyển đối tượng thành dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'authToken': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    };
  }

  // Tạo đối tượng từ dữ liệu JSON
  static AuthToken fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['authToken'],
      userId: json['userId'],
      expiryDate: DateTime.parse(json['expiryDate']),
    );
  }
}
