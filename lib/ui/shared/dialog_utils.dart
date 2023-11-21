import 'package:flutter/material.dart';

// Hàm hiển thị hộp thoại xác nhận
Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Are you sure?'), // Tiêu đề hộp thoại
      content: Text(message), // Nội dung hộp thoại
      actions: <Widget>[
        // Nút "No" để đóng hộp thoại và trả về giá trị false
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        // Nút "Yes" để đóng hộp thoại và trả về giá trị true
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
        ),
      ],
    ),
  );
}

// Hàm hiển thị hộp thoại lỗi
Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('An Error Occurred!'), // Tiêu đề hộp thoại lỗi
      content: Text(message), // Nội dung hộp thoại lỗi
      actions: <Widget>[
        // Nút "Okay" để đóng hộp thoại lỗi
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
