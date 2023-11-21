class HttpException implements Exception {
  final String message;

  // Constructor chính
  HttpException(this.message);

  // Constructor tùy chọn để xử lý mã lỗi từ Firebase
  HttpException.firebase(String code)
      : message = _translateFirebaseErrorCode(code);

  // Phương thức tĩnh để chuyển đổi mã lỗi từ Firebase thành thông báo đọc hiểu
  static String _translateFirebaseErrorCode(code) {
    switch (code) {
      case 'EMAIL_EXISTS':
        return 'This email address is already in use';
      case 'INVALID_EMAIL':
        return 'This is not a valid email address';
      case 'WEAK_PASSWORD':
        return 'This password is too weak';
      case 'EMAIL_NOT_FOUND':
        return 'Could not find a user with that email';
      case 'INVALID_PASSWORD':
        return 'Invalid password';
      default:
        return code;
    }
  }

  // Ghi đè phương thức toString để trả về thông báo khi exception được in ra
  @override
  String toString() {
    return message;
  }
}
